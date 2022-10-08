//
//  BorrowedBookViewController.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/08.
//

import UIKit

class BorrowedBookViewController: UIViewController {

    @IBOutlet weak var showBorrowedBookListTableView: UITableView!
    
    @IBOutlet weak var inFetchActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var borrowedBookView: UIView!
    
    private var presenter: BorrowedBookPresenterInput!
    func inject(presenter: BorrowedBookPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //TODO: reloadDataする
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BorrowedBookViewController: BorrowedBookPresenterOutput {
    
    func changedStateSuccess(message: String) {
        let alert = UIAlertController(title: "成功", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.sync {
            present(alert, animated: true, completion: nil)
        }
    }
    
    func changedStateError(message: String) {
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.sync {
            present(alert, animated: true, completion: nil)
        }
    }
}
