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
    }
  
    @IBAction func pressedPhotoUploadButton(_ sender: Any) {
    }
    
    @IBAction func pressedISBNSearchButton(_ sender: Any) {
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

//MARK: - Extension BookRegisterPresenterOutput -
extension BookRegisterViewController: BookRegisterPresenterOutput {
    
    func showErrorPost(errorMessage: String) {
        
    }
    

}
