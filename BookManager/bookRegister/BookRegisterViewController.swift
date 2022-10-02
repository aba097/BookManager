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

    
    }
  
    @IBAction func pressedISBNSearchButton(_ sender: Any) {
    }
    
    
    @IBAction func pressedCameraBootOrEndButton(_ sender: Any) {
    }
    
    @IBAction func pressedBookRegisterButton(_ sender: Any) {
    }
}
