//
//  File.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/07.
//

import Foundation
import AVFoundation

protocol BookRegisterPresenterInput {
    func pressedBookRegisterButton(inputTitle: String, inputAuthor: String, inputPublisher: String, inputImage: Data?)
    func pressedISBNSearchButton(inputISBNCode: String)
    func scanISBNCode(avMetadataObjects: [AVMetadataObject])
    func pressedPhotoUploadButton()
    func pressedCameraBootOrEndButton(buttonIsSelected: Bool)
    func viewDidDisappear()
    func viewWillAppear()
    func viewDidLoad(viewBounds: CGRect)
    func closedShowErrorFetchBookInfo(fromScanISBNCode: Bool)
}

protocol BookRegisterPresenterOutput: AnyObject {
    func showMessage(title: String, message: String)
    func showPhotoUploadAlert()
    func setFetchBookInfo(title: String, author: String, publisher: String, image: Data?)
    func showErrorFetchBookInfo(errorMessage: String, fromScanISBNCode: Bool)
    func captureStart()
    func captureStop()
    func setDefaultValue()
    func setupBarcodeCapture(output: inout AVCaptureMetadataOutput, capturePreviewLayer: inout AVCaptureVideoPreviewLayer)
    func doEnbaleRegiterButton()
}

final class BookRegisterPresenter: BookRegisterPresenterInput {

    private(set) weak var view: BookRegisterPresenterOutput!
    private(set) var model: BookRegisterModelInput
    
    private(set) var captureSession: AVCaptureSession?
    private(set) var captureSessionQueue: DispatchQueue?
    private(set) var videoLayer : AVCaptureVideoPreviewLayer?
    
    init(view: BookRegisterPresenterOutput, model: BookRegisterModelInput) {
        self.view = view
        self.model = model
        self.model.delegate = self
    }
    
    func viewDidLoad(viewBounds: CGRect) {
        self.setupBarcodeCapture(viewBounds: viewBounds)
    }
    
    func viewWillAppear() {
        self.view.setDefaultValue()
    }
    
    func viewDidDisappear() {
        self.captureStop()
        self.view.setDefaultValue()
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
    
    
    func pressedBookRegisterButton(inputTitle: String, inputAuthor: String, inputPublisher: String, inputImage: Data?) {
        if inputTitle == "" {
            self.view.showMessage(title: "error", message: "Title is required")
            self.view.doEnbaleRegiterButton()
            return
        }
    
        self.model.postBookInfo(inputTitle: inputTitle, inputAuthor: inputAuthor, inputPublisher: inputPublisher, inputImage: inputImage)
    }
    
    func pressedISBNSearchButton(inputISBNCode: String) {
        fetchBookInfo(inputISBNCode: inputISBNCode, fromScanISBNCode: false)
    }
    
    func scanISBNCode(avMetadataObjects: [AVMetadataObject]) {
        let objects = avMetadataObjects
        
        for metadataObject in objects {
            if metadataObject.type == AVMetadataObject.ObjectType.ean8 ||  metadataObject.type == AVMetadataObject.ObjectType.ean13 {
                guard self.videoLayer!.transformedMetadataObject(for: metadataObject) is AVMetadataMachineReadableCodeObject else { continue }
                    if let object = metadataObject as? AVMetadataMachineReadableCodeObject {
                        self.captureStop()
                        fetchBookInfo(inputISBNCode: object.stringValue!, fromScanISBNCode: true)
                }
            }
        }
    }
        
    func fetchBookInfo(inputISBNCode: String, fromScanISBNCode: Bool){
        Task.detached {
            do {
                let book: Book = try await self.model.fetchBookInfo(ISBNCode: inputISBNCode)
                self.view.setFetchBookInfo(title: book.title, author: book.author, publisher: book.publisher, image: book.image)
                if fromScanISBNCode {
                    DispatchQueue.main.sync {
                        self.captureStart()
                    }
                }
            }catch {
                DispatchQueue.main.sync {
                    self.view.showErrorFetchBookInfo(errorMessage: error.localizedDescription, fromScanISBNCode: fromScanISBNCode)
                }
            }
        }
    }
    
    func closedShowErrorFetchBookInfo(fromScanISBNCode: Bool) {
        if fromScanISBNCode {
            self.captureStart()
        }
    }
    
    func pressedPhotoUploadButton() {
        self.view.showPhotoUploadAlert()
    }
    
    func pressedCameraBootOrEndButton(buttonIsSelected: Bool) {
        //MARK: IsSelectedは初期値がfalseなので注意
        if !buttonIsSelected {
            self.captureStart()
        }else {
            self.captureStop()
        }
    }
    
}

extension BookRegisterPresenter: BookRegisterModelDelegate {
    func postBookInfoResult(result: Result<String, Error>) {
        switch result {
        case .success(let successMessage):
            DispatchQueue.main.sync{
                self.view.showMessage(title: "success", message: successMessage)
                self.view.doEnbaleRegiterButton()
            }
        case .failure(let error):
            DispatchQueue.main.sync {
                self.view.showMessage(title: "error", message: error.localizedDescription)
                self.view.doEnbaleRegiterButton()
            }
        }

    }
    
    
}
