//
//  BorrowedBookPresenter.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/08.
//

import Foundation

protocol BorrowedBookPresenterInput {
    var numberOfBooks: Int { get }
    func book(forRow row: Int) -> Book?
    func viewWillAppear()
    func reloadBooks()
    func pressedBookReturn(row: Int)
}

protocol BorrowedBookPresenterOutput: AnyObject {
    func showInFetchActivityIndicatorAndHideBookManageView()
    func hideInFetchActivityIndicatorAndShowBookManageView()
    func changedStateSuccess(message: String)
    func changedStateError(message: String)
    func showErrorFetchBooks(errorMessage: String)
    func updateBooks()
}

final class BorrowedBookPresenter: BorrowedBookPresenterInput {
    
    private weak var view: BorrowedBookPresenterOutput!
    private var model: BorrowedBookModelInput
    
    private var user: User
    private(set) var books: [Book] = []
    private(set) var borrowedBooks: [Book] = []
    
    init(view: BorrowedBookPresenterOutput, model: BorrowedBookModelInput, user: User){
        self.view = view
        self.model = model
        self.user = user
    }
    
    var numberOfBooks: Int {
        return borrowedBooks.count
    }
    
    func book(forRow row: Int) -> Book? {
        guard row < borrowedBooks.count else { return nil }
        return borrowedBooks[row]
    }
    
    func viewWillAppear() {
        fetchBooks()
    }
    
    func reloadBooks() {
        fetchBooks()
    }
    
    func fetchBooks() {
        self.view.showInFetchActivityIndicatorAndHideBookManageView()
        
        Task.detached {
            do {
                self.books = try await self.model.fetchBooks()
   
                //TODO: 自分の借りている本のみ読み出す
                self.borrowedBooks = self.model.filteredBorrowedBooks(books: self.books, userName: self.user.name)
                
                self.view.updateBooks()
                
                self.view.hideInFetchActivityIndicatorAndShowBookManageView()
                
            }catch {
                self.view.showErrorFetchBooks(errorMessage: error.localizedDescription)
                //self.view.hideInFetchActivityIndicatorAndShowBookManageView()
            }
        }
    }
    
    func pressedBookReturn(row: Int) {
        Task.detached {
            do {
                let updateState = try await self.model.returnBook(book: self.borrowedBooks[row])
                switch updateState {
                case .success:
                    self.view.changedStateSuccess(message: updateState.rawValue)
                case .nomatch:
                    self.view.changedStateError(message: updateState.rawValue)
                }
                
            }catch {
                self.view.changedStateError(message: error.localizedDescription)
            }
        }
    }
}
