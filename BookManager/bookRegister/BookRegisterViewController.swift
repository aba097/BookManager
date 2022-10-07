//
//  BookRegisterViewController.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/02.
//

import UIKit

class BookRegisterViewController: UIViewController {

    @IBOutlet weak var inputTitleTextField: UITextField!
    @IBOutlet weak var inputAuthorTextField: UITextField!
    @IBOutlet weak var inputPublisherTextField: UITextField!
    @IBOutlet weak var inputISBNCodeTextField: UITextField!

    @IBOutlet weak var uploadedPhotoImageView: UIImageView!
    
    @IBOutlet weak var readByISBNBarcodeView: UIView!
    
    private var imagepicker: UIImagePickerController! //フォトライブラリ操作

    private var presenter: BookRegisterPresenterInput!
    func inject(presenter: BookRegisterPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //TextField以外をタッチしたときにキーボードを閉じる
        self.view.endEditing(true)
    }
    
    func setupDelegate(){
        inputTitleTextField.delegate = self
        inputAuthorTextField.delegate = self
        inputPublisherTextField.delegate = self
        inputISBNCodeTextField.delegate = self
        
        imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        
    }
  
    @IBAction func pressedPhotoUploadButton(_ sender: Any) {
        self.presenter.pressedPhotoUploadButton()
    }
    
    @IBAction func pressedISBNSearchButton(_ sender: Any) {
        self.presenter.pressedISBNSearchButton(inputISBNCode: inputISBNCodeTextField.text!)
    }
    
    
    @IBAction func pressedCameraBootOrEndButton(_ sender: Any) {
    }
    
    @IBAction func pressedBookRegisterButton(_ sender: Any) {
        self.presenter.pressedBookRegisterButton(inputTitle: inputTitleTextField.text!, inputAuthor: inputAuthorTextField.text!, inputPublisher: inputPublisherTextField.text!, inputImage: uploadedPhotoImageView.image?.jpegData(compressionQuality: 0.5))
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

    func showErrorPostBookInfo(errorMessage: String) {
        
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
    
    func showErrorFetchBookInfo(errorMessage: String) {
        let alert = UIAlertController(title: "エラー", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.sync {
            present(alert, animated: true, completion: nil)
        }
    }
    
}
