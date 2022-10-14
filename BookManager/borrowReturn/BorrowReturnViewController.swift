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
    
    private lazy var captureSession: AVCaptureSession = AVCaptureSession()
    private let captureSessionQueue = DispatchQueue(label: "captureSessionQueue")
    
    private var presenter: BorrowReturnPresenterInput!
    func inject(presenter: BorrowReturnPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupBarcodeCapture()
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
    
    func setupBarcodeCapture(){
        lazy var captureDevice: AVCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)!
            
        var captureInput: AVCaptureInput? = nil
        lazy var Output: AVCaptureMetadataOutput = {
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: .main)
            return output
        }()
        lazy var capturePreviewLayer: AVCaptureVideoPreviewLayer = {
            let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            return layer
        }()
        
        do {
            captureInput = try AVCaptureDeviceInput(device: captureDevice)
            self.captureSession.addInput(captureInput!)
            self.captureSession.addOutput(Output)
            Output.metadataObjectTypes = Output.availableMetadataObjectTypes
            capturePreviewLayer.frame = self.readByISBNBarcodeView?.bounds ?? CGRect.zero
            capturePreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
           // capturePreviewLayer.connection?.videoOrientation = .landscapeRight
            self.readByISBNBarcodeView?.layer.addSublayer(capturePreviewLayer)
        }catch {
            self.captureSession.commitConfiguration()
        }
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
        self.captureSessionQueue.async {
            self.captureSession.startRunning()
        }
    }
    
    func captureStop() {
       self.cameraBootOrEndButton.isSelected = false
       self.readByISBNBarcodeView.isHidden = true
       self.captureSession.stopRunning()
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
    
    
    
}
