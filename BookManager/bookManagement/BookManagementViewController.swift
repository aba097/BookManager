//
//  BookManagementViewController.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/02.
//

import UIKit

class BookManagementViewController: UIViewController {

    @IBOutlet weak var bookSearchBar: UISearchBar!
    
    @IBOutlet weak var showBookListTableView: UITableView!
    
    @IBOutlet weak var inFetchActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bookManageView: UIView!
    
    @IBOutlet weak var borrowedBookSwitch: UISwitch!
    
    private var presenter: BookManagementPresenterInput!
    func inject(presenter: BookManagementPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
        
        setup()
    }
    
    func setup(){
        //クルクルがストップした時にクルクルを非表示にする
        self.inFetchActivityIndicator.hidesWhenStopped = true
        
        self.bookSearchBar.delegate = self
        self.bookSearchBar.showsCancelButton = true
        
        self.showBookListTableView.delegate = self
        self.showBookListTableView.dataSource = self
        self.showBookListTableView.allowsSelection = false //セルの選択を不可能にする
    }

    @IBAction func borrowedBookSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            presenter.borrowedBookSwitchIsOn()
        }else {
           presenter.borrowedBookSwitchIsOff()
        }
    }
    
    @IBAction func pressedReloadButton(_ sender: Any) {
        self.presenter.pressedReloadButton(searchText: self.bookSearchBar.text!)
    }
    
}

//MARK: - TableView -
extension BookManagementViewController: UITableViewDelegate, UITableViewDataSource {
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
        
        let (swipeTitle, bookState, book) = presenter.swipeCellState(row: indexPath.row)
        
        let editAction = UIContextualAction(style: .normal, title: swipeTitle) { (action, view, completionHandler) in
            
            self.presenter.pressedChangeState(state: bookState, book: book)
            // 実行結果に関わらず記述
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [editAction])

    }
    
    
}

//MARK: - UISearchBarDelegate -
extension BookManagementViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        presenter.searchBarSearchButtonClicked(searchText: searchBar.text!)
    }
}

//MARK: - BookManagementPresenterOutput -
extension BookManagementViewController: BookManagementPresenterOutput {
    
    func startFetchBooks() {
        self.inFetchActivityIndicator.startAnimating()
        self.bookManageView.isHidden = true
    }
    
    func finishedFetchBooks() {
        DispatchQueue.main.sync {
            self.inFetchActivityIndicator.stopAnimating()
            self.bookManageView.isHidden = false
            self.borrowedBookSwitch.isOn = false
            self.showBookListTableView.reloadData()
        }
    }
    
    func upadteBooksFilteredBorrowedBook() {
        self.showBookListTableView.reloadData()
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
