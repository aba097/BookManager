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
    
    private var presenter: BorrowReturnPresenterInput!
    func inject(presenter: BorrowReturnPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.hoge()
    }
    
    @IBAction func pressedCameraBootOrEndButton(_ sender: Any) {
    }
    
    @IBAction func pressedBorrowButton(_ sender: Any) {
    }
    
    @IBAction func pressedReturnButton(_ sender: Any) {
    }
    
}

extension BorrowReturnViewController: BorrowReturnPresenterOutput {
    func hoge() {
        
    }
    
}
