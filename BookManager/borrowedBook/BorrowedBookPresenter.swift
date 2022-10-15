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
    func startFetchBooks()
    func updateBooks()
    func finishedFetchBooks()
    func showMessage(title: String, message: String)
    func changedStateSuccess(title: String, message: String)
}

final class BorrowedBookPresenter: BorrowedBookPresenterInput {
    
    private(set) weak var view: BorrowedBookPresenterOutput!
    private(set) var model: BorrowedBookModelInput
    
    private(set) var user: User
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
        self.startFetchBooks()
        
        Task.detached {
            do {
                self.books = try await self.model.fetchBooks()
                self.borrowedBooks = self.model.filteredBorrowedBooks(books: self.books, userName: self.user.name)
                
                self.view.updateBooks()
                self.finishedFetchBooks()
                
            }catch {
                self.view.showMessage(title: "error", message: error.localizedDescription)
            }
        }
    }
    
    func startFetchBooks(){
        self.view.startFetchBooks()
    }
    
    func finishedFetchBooks(){
        self.view.finishedFetchBooks()
    }
    
    func pressedBookReturn(row: Int) {
        Task.detached {
            do {
                let updateState = try await self.model.returnBook(book: self.borrowedBooks[row])
                switch updateState {
                case .success:
                    self.view.changedStateSuccess(title: "success", message: updateState.rawValue)
                case .nomatch:
                    self.view.showMessage(title: "error", message: updateState.rawValue)
                }
            }catch {
                self.view.showMessage(title: "error", message: error.localizedDescription)
            }
        }
    }
}
