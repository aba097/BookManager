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

    @IBOutlet weak var readByISBNBarcodeView: UIView!
    
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
  
    @IBAction func pressedISBNSearchButton(_ sender: Any) {
    }
    
    
    @IBAction func pressedCameraBootOrEndButton(_ sender: Any) {
    }
    
    @IBAction func pressedBookRegisterButton(_ sender: Any) {
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
