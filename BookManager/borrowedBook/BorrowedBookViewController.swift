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

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
        
    }
    
    func setup() {
        //クルクルがストップした時にクルクルを非表示にする
        self.inFetchActivityIndicator.hidesWhenStopped = true
        
        self.showBorrowedBookListTableView.delegate = self
        self.showBorrowedBookListTableView.dataSource = self
        //セルの選択をできないようにする
        self.showBorrowedBookListTableView.allowsSelection = false
    }

}

//MARK: - TableView -
extension BorrowedBookViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfBooks
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookInfoCell", for: indexPath) as! BookDetailTableViewCell
        
        if let book = presenter.book(forRow: indexPath.row) {
            cell.configure(book: book)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "返す") { (action, view, completionHandler) in
            
            self.presenter.pressedBookReturn(row: indexPath.row)
            // 実行結果に関わらず記述
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [editAction])

    }
}

//MARK: - BorrowedBookPresenterOutput -
extension BorrowedBookViewController: BorrowedBookPresenterOutput {
  
    func startFetchBooks() {
        self.inFetchActivityIndicator.startAnimating()
        self.borrowedBookView.isHidden = true
    }
    
    func finishedFetchBooks() {
        DispatchQueue.main.sync {
            self.inFetchActivityIndicator.stopAnimating()
            self.borrowedBookView.isHidden = false
        }
    }
    
    func updateBooks() {
        DispatchQueue.main.sync {
            self.showBorrowedBookListTableView.reloadData()
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
    
    func changedStateSuccess(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{(action: UIAlertAction!) in
            self.presenter.reloadBooks()
        })
                        
        alert.addAction(okAction)
        DispatchQueue.main.sync {
            present(alert, animated: true, completion: nil)
        }
    }

}
