//
//  BorrowReturnViewController.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/13.
//

import UIKit

class BorrowReturnViewController: UIViewController {

    @IBOutlet weak var readByISBNBarcodeView: UIView!
    
    @IBOutlet weak var stateChangeProcess: UIActivityIndicatorView!
    
    
    @IBOutlet weak var cameraBootOrEndButton: UIButton!
    
    @IBOutlet weak var borrowButton: UIButton!
    
    @IBOutlet weak var returnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedCameraBootOrEndButton(_ sender: Any) {
    }
    
    @IBAction func pressedBorrowButton(_ sender: Any) {
    }
    
    @IBAction func pressedReturnButton(_ sender: Any) {
    }
    
}
