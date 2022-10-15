//
//  BookRegisterViewController.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/02.
//

import UIKit
import AVFoundation

class BookRegisterViewController: UIViewController {

    @IBOutlet weak var inputTitleTextField: UITextField!
    @IBOutlet weak var inputAuthorTextField: UITextField!
    @IBOutlet weak var inputPublisherTextField: UITextField!
    @IBOutlet weak var inputISBNCodeTextField: UITextField!

    @IBOutlet weak var uploadedPhotoImageView: UIImageView!
    
    @IBOutlet weak var readByISBNBarcodeView: UIView!
    
    @IBOutlet weak var cameraBootOrEndButton: UIButton!
    
    @IBOutlet weak var bookRegisterButton: UIButton!
    
    private var imagepicker: UIImagePickerController = UIImagePickerController() //フォトライブラリ操作
    
    private var presenter: BookRegisterPresenterInput!
    func inject(presenter: BookRegisterPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        
        presenter.viewDidLoad(viewBounds: self.readByISBNBarcodeView!.bounds)
       //uploadedPhotoImageView.image = UIImage(named: "noimage")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        presenter.viewDidDisappear()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //TextField以外をタッチしたときにキーボードを閉じる
        self.view.endEditing(true)
    }
    
    func setupDelegate(){
        self.inputTitleTextField.delegate = self
        self.inputAuthorTextField.delegate = self
        self.inputPublisherTextField.delegate = self
        self.inputISBNCodeTextField.delegate = self
        
        self.imagepicker.delegate = self
        
    }
    
    @IBAction func pressedPhotoUploadButton(_ sender: Any) {
        self.presenter.pressedPhotoUploadButton()
    }
    
    @IBAction func pressedISBNSearchButton(_ sender: Any) {
        self.presenter.pressedISBNSearchButton(inputISBNCode: self.inputISBNCodeTextField.text!)
    }
    
    
    @IBAction func pressedCameraBootOrEndButton(_ sender: UIButton) {
        presenter.pressedCameraBootOrEndButton(buttonIsSelected: self.cameraBootOrEndButton.isSelected)
    }
    
    @IBAction func pressedBookRegisterButton(_ sender: Any) {
        self.bookRegisterButton.isEnabled = false
        self.presenter.pressedBookRegisterButton(inputTitle: self.inputTitleTextField.text!, inputAuthor: self.inputAuthorTextField.text!, inputPublisher: self.inputPublisherTextField.text!, inputImage: self.uploadedPhotoImageView.image?.jpegData(compressionQuality: 0.5))
    }
}

//  MARK: - TextField -
extension BookRegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - AVCaptureMetadataOutputObjects -
extension BookRegisterViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    //バーコード読み取り
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    
        self.presenter.scanISBNCode(avMetadataObjects: metadataObjects)

    }
}

//MARK: - ImagePicker -
extension BookRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //画像アップロード時
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        self.uploadedPhotoImageView.image = info[.originalImage] as? UIImage
        //フォトライブラリと閉じる
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    //フォトライブラリのキャンセルボタンをクリック時
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //フォトライブラリ閉じる
        picker.dismiss(animated: true, completion: nil)

    }
}

//MARK: - Extension BookRegisterPresenterOutput -
extension BookRegisterViewController: BookRegisterPresenterOutput {

    func setDefaultValue() {
        self.inputTitleTextField.text = ""
        self.inputAuthorTextField.text = ""
        self.inputPublisherTextField.text = ""
        self.inputISBNCodeTextField.text = ""
        self.uploadedPhotoImageView.image = nil
        self.bookRegisterButton.isEnabled = true
    }
    
    func showSuccessPostBookInfo(message: String) {
        let alert = UIAlertController(title: "成功", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.sync {
            self.bookRegisterButton.isEnabled = true
            present(alert, animated: true, completion: nil)
        }
    }
    
    func showErrorPostBookInfo(message: String) {
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.sync {
            self.bookRegisterButton.isEnabled = true
            present(alert, animated: true, completion: nil)
        }
    }
    
    func showErrorNotInputTitle(errorMessage: String) {
        let alert = UIAlertController(title: "エラー", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showPhotoUploadAlert() {
        let alert: UIAlertController = UIAlertController(title: "選択してください", message:  "", preferredStyle:  UIAlertController.Style.alert)
        
        let cameraAction: UIAlertAction = UIAlertAction(title: "カメラを起動", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            self.imagepicker.sourceType = .camera
            self.present(self.imagepicker, animated: true)
        })
        
        let libraryAction: UIAlertAction = UIAlertAction(title: "フォトライブラリを起動", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            self.imagepicker.sourceType = .photoLibrary
            self.present(self.imagepicker, animated: true)
        })
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        //alert表示
        present(alert, animated: true, completion: nil)
    }
    
    func setFetchBookInfo(title: String, author: String, publisher: String, image: Data?) {
        DispatchQueue.main.sync {
            self.inputTitleTextField.text = title
            self.inputAuthorTextField.text = author
            self.inputPublisherTextField.text = publisher
            
            if let image = image {
                self.uploadedPhotoImageView.image = UIImage(data: image)
            }
        }
    }
    
    func showErrorFetchBookInfo(errorMessage: String, fromScanISBNCode: Bool) {
        let alert = UIAlertController(title: "エラー", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{(action: UIAlertAction!) in
            
            self.presenter.closedShowErrorFetchBookInfo(fromScanISBNCode: fromScanISBNCode)
        })

        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
        
    }
    
    func captureStart() {
        self.cameraBootOrEndButton.isSelected = true
        self.readByISBNBarcodeView.isHidden = false
    }
    
    func captureStop() {
        self.cameraBootOrEndButton.isSelected = false
        self.readByISBNBarcodeView.isHidden = true
    }
    
    func setupBarcodeCapture(output: inout AVCaptureMetadataOutput, capturePreviewLayer: inout AVCaptureVideoPreviewLayer) {
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        self.readByISBNBarcodeView?.layer.addSublayer(capturePreviewLayer)
    }
  
    
}
