//
//  BorrowReturnViewController.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/13.
//

import UIKit
import AVFoundation

class BorrowReturnViewController: UIViewController {

    @IBOutlet weak var readByISBNBarcodeView: UIView!
    
    @IBOutlet weak var stateChangeProcess: UIActivityIndicatorView!
    
    @IBOutlet weak var cameraBootOrEndButton: UIButton!
    
    @IBOutlet weak var borrowButton: UIButton!
    
    @IBOutlet weak var returnButton: UIButton!
    
    private var presenter: BorrowReturnPresenterInput!
    func inject(presenter: BorrowReturnPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad(viewBounds: self.readByISBNBarcodeView!.bounds)
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.presenter.viewDidDisappear()
    }
    
    func setup(){
        self.stateChangeProcess.hidesWhenStopped = true
    }
    
    
    @IBAction func pressedCameraBootOrEndButton(_ sender: Any) {
        self.presenter.pressedCameraBootOrEndButton(buttonIsSelected: self.cameraBootOrEndButton.isSelected)
    }
    
    @IBAction func pressedBorrowButton(_ sender: Any) {
        self.presenter.pressedBorrowButton()
    }
    
    @IBAction func pressedReturnButton(_ sender: Any) {
        self.presenter.pressedReturnButton()
    }
    
}

//MARK: - AVCaptureMetadataOutputObjects -
extension BorrowReturnViewController: AVCaptureMetadataOutputObjectsDelegate {
    //バーコード読み取り
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

       self.presenter.scanISBNCode(avMetadataObjects: metadataObjects)

    }
}

//MARK: - BorrowReturnPresenterOutput
extension BorrowReturnViewController: BorrowReturnPresenterOutput {

    func captureStart() {
        self.cameraBootOrEndButton.isSelected = true
        self.readByISBNBarcodeView.isHidden = false
    }
    
    func captureStop() {
       self.cameraBootOrEndButton.isSelected = false
       self.readByISBNBarcodeView.isHidden = true
   }
    
    func stateSelectedBorrowButton() {
        self.borrowButton.isSelected = true
        self.returnButton.isSelected = false
    }
    
    func stateSelectedReturnButton() {
        self.returnButton.isSelected = true
        self.borrowButton.isSelected = false
    }
    
    func startActivityIndicator() {
        self.stateChangeProcess.startAnimating()
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.sync {
            self.stateChangeProcess.stopAnimating()
        }
    }
    
    func showMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.sync {
            present(alert, animated: true, completion: nil)
        }
    }
    
    func setupBarcodeCapture(output: inout AVCaptureMetadataOutput, capturePreviewLayer: inout AVCaptureVideoPreviewLayer) {
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        self.readByISBNBarcodeView?.layer.addSublayer(capturePreviewLayer)
    }
    
    func guidedToSetting() {
        let alert = UIAlertController(title: "カメラ使用のリクエスト", message:"バーコードを読み取るためカメラの使用を許可してください", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "設定を開く", style: .default, handler: { (_) -> Void in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString ) else {
                return
            }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        })
        let closeAction: UIAlertAction = UIAlertAction(title: "閉じる", style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
