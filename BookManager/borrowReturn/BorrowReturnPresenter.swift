//
//  BorrowReturnPresenter.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/14.
//

import Foundation
import AVFoundation

enum BorrowReturnState{
    case borrowState
    case returnState
}

protocol BorrowReturnPresenterInput {
    func pressedCameraBootOrEndButton(buttonIsSelected: Bool)
    func pressedBorrowButton()
    func pressedReturnButton()
    func viewDidLoad(viewBounds: CGRect)
    func viewWillAppear()
    func viewDidDisappear()
    func scanISBNCode(avMetadataObjects: [AVMetadataObject])
}

protocol BorrowReturnPresenterOutput: AnyObject {
    func captureStart()
    func captureStop()
    func stateSelectedBorrowButton()
    func stateSelectedReturnButton()
    func startActivityIndicator()
    func stopActivityIndicator()
    func showMessage(title: String, message: String)
    func setupBarcodeCapture(output: inout AVCaptureMetadataOutput, capturePreviewLayer: inout AVCaptureVideoPreviewLayer)
    func guidedToSetting()
}

final class BorrowReturnPresenter: BorrowReturnPresenterInput {
    
    private(set) weak var view: BorrowReturnPresenterOutput!
    private(set) var model: BorrowReturnModelInput
    private(set) var user: User
    
    private(set) var buttonState: BorrowReturnState?
    
    private(set) var isStateChange = false
    
    private(set) var captureSession: AVCaptureSession?
    private(set) var captureSessionQueue: DispatchQueue?
    private(set) var videoLayer : AVCaptureVideoPreviewLayer?
    
    init(view: BorrowReturnPresenterOutput, model: BorrowReturnModelInput, user: User) {
        self.view = view
        self.model = model
        self.user = user
    }
    
    func viewDidLoad(viewBounds: CGRect) {
        self.setupBarcodeCapture(viewBounds: viewBounds)
    }
    
    func viewWillAppear() {
        self.checkAuthorizationState()
        self.buttonState = BorrowReturnState.borrowState
        self.view.stateSelectedBorrowButton()
        self.captureStart()
    }
    
    func viewDidDisappear() {
        self.captureStop()
    }
    
    func checkAuthorizationState() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied: // The user has previously denied access.
            self.view.guidedToSetting()
        default:
            break
        }
    }
    
    func setupBarcodeCapture(viewBounds: CGRect){
    
        //画像や動画といった出力データの管理を行うクラス
        let session = AVCaptureSession()
        self.captureSessionQueue = DispatchQueue(label: "captureSessionQueue")

        //カメラデバイスの管理を行うクラス
        let device : AVCaptureDevice = AVCaptureDevice.default(for: .video)!
        //AVCaptureDeviceをAVCaptureSessionに渡すためのクラス
        guard let input : AVCaptureInput = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        //inputをセッションに追加
        session.addInput(input)
        //outputをセッションに追加
        var output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.metadataObjectTypes = [.ean8, .ean13]
        
        //画面上にカメラの映像を表示するためにvideoLayerを作る
        var videoLayer = AVCaptureVideoPreviewLayer(session: session)
        //アスペクト比を保ったままレイヤー矩形いっぱいに表示する。
        videoLayer.videoGravity = .resizeAspectFill
        videoLayer.frame = viewBounds
        
        self.view.setupBarcodeCapture(output: &output, capturePreviewLayer: &videoLayer)
        
        self.videoLayer = videoLayer
        self.captureSession = session
    }
    
    func captureStart(){
        self.captureSessionQueue?.async {
            self.captureSession?.startRunning()
         }
         self.view.captureStart()
    }
    
    func captureStop(){
        self.captureSession?.stopRunning()
        self.view.captureStop()
    }
    
    
    
    func pressedCameraBootOrEndButton(buttonIsSelected: Bool) {
        //MARK: IsSelectedは初期値がfalseなので注意
        if !buttonIsSelected {
            self.checkAuthorizationState()
            self.captureStart()
        }else {
            self.captureStop()
        }
    }
    
    func pressedBorrowButton() {
        self.buttonState = BorrowReturnState.borrowState
        self.view.stateSelectedBorrowButton()
    }
    
    func pressedReturnButton() {
        self.buttonState = BorrowReturnState.returnState
        self.view.stateSelectedReturnButton()
    }
    
    func scanISBNCode(avMetadataObjects: [AVMetadataObject]) {
        
        let objects = avMetadataObjects
        
        for metadataObject in objects {
            if metadataObject.type == AVMetadataObject.ObjectType.ean8 ||  metadataObject.type == AVMetadataObject.ObjectType.ean13 {
                guard self.videoLayer!.transformedMetadataObject(for: metadataObject) is AVMetadataMachineReadableCodeObject else { continue }
                    if let object = metadataObject as? AVMetadataMachineReadableCodeObject {
                        fetchBook(inputISBNCode: object.stringValue!)
                }
            }
        }
    }
    
    func startStateChangeAction() -> Bool{
        //現在借りている・返却を行なっていない
        if !isStateChange {
            isStateChange = true
            self.view.startActivityIndicator()
            self.captureStop()
            return true
        }

        return false
    }
    
    
    func finishStateChangeAction(title: String, message: String){
        self.view.stopActivityIndicator()
        self.view.showMessage(title: title, message: message)
        self.isStateChange = false
        
    }
    
    func fetchBook(inputISBNCode: String){
        
        if self.startStateChangeAction() {
            
            Task.detached {
                do {
                    async let book: Book = self.model.fetchBookInfo(ISBNCode: inputISBNCode)
                    async let books: [Book] = self.model.fetchBooks()
                    //バーコードの本の取得と、本一覧を非同期並列で取得
                    let list = try await (book, books)
                    self.chageBookState(targetBook: list.0, books: list.1)
                    
                }catch {
                    self.finishStateChangeAction(title: "error", message: error.localizedDescription)
                }
            }
        }
    }
    
    func chageBookState(targetBook: Book, books: [Book]){
        
        var existed = false
        for book in books {
            if targetBook.title     == book.title &&
               targetBook.author    == book.author &&
               targetBook.publisher == book.publisher {
                existed = true
                
                if self.buttonState == .borrowState && book.state == "" {
                    Task.detached {
                        do {
                            let updateState = try await self.model.borrowBook(book: book, userName: self.user.name)
                            switch updateState {
                            case .success:
                                self.finishStateChangeAction(title: "success", message: updateState.rawValue)
                            case .nomatch:
                                self.finishStateChangeAction(title: "error", message: updateState.rawValue)
                            }
                            
                        }catch {
                            self.finishStateChangeAction(title: "error", message: error.localizedDescription)
                        }
                    }
                    return
                }
                if self.buttonState == .returnState && book.state == self.user.name {
                    Task.detached {
                        do {
                            let updateState = try await self.model.returnBook(book: book)
                            switch updateState {
                            case .success:
                                self.finishStateChangeAction(title: "success", message: updateState.rawValue)
                            case .nomatch:
                                self.finishStateChangeAction(title: "error", message: updateState.rawValue)                            }
                            
                        }catch {
                            self.finishStateChangeAction(title: "error", message: error.localizedDescription)                        }
                    }
                    return
                }
            }
        }
        
        if !existed {
            self.finishStateChangeAction(title: "error", message: "The book does not exist, please register it")
            return
        }
        //stateが""の場合でない場合は借りれない
        if self.buttonState == .borrowState {
            self.finishStateChangeAction(title: "error", message: "The book is already borrowed by another user")
        }
        
        //stateがuser.nameでない場合返却済み
        if self.buttonState == .returnState {
            self.finishStateChangeAction(title: "error", message: "This book has already been returned")
        }
     
    }
    
    

}
