//
//  BookManagementPresenter.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/08.
//

import Foundation

protocol BookManagementPresenterInput {
    func viewDidLoad()
    var numberOfBooks: Int { get }
    func book(forRow row: Int) -> Book?
    func searchBarSearchButtonClicked(searchText: String)
    func borrowedBookSwitchIsOn()
    func borrowedBookSwitchIsOff()
}

protocol BookManagementPresenterOutput: AnyObject {
    func showInFetchActivityIndicatorAndHideBookManageView()
    func hideInFetchActivityIndicatorAndShowBookManageView()
    func showErrorFetchBooks(errorMessage: String)
    func updateBooksFilteredSearchWord()
    func upadteBooksFilteredBorrowedBook()
}

final class BookManagementPresenter: BookManagementPresenterInput {
    
    private weak var view: BookManagementPresenterOutput!
    private var model: BookManagementModelInput
    
    private var user: User
    private(set) var books: [Book] = []
    private(set) var matchedBooks: [Book] = []
    private(set) var filteredInSearchWordBooks: [Book] = []
    
    init(view: BookManagementPresenterOutput, model: BookManagementModelInput, user: User) {
        self.view = view
        self.model = model
        self.user = user
    }
    
    var numberOfBooks: Int {
        return matchedBooks.count
    }
    
    func book(forRow row: Int) -> Book? {
        guard row < matchedBooks.count else { return nil }
        return matchedBooks[row]
    }
    
    func viewDidLoad() {
        fetchBooks(searchText: "")
    }
    
    func searchBarSearchButtonClicked(searchText: String) {
        fetchBooks(searchText: searchText)
    }
    
    func fetchBooks(searchText: String){
        self.view.showInFetchActivityIndicatorAndHideBookManageView()
        
        Task.detached {
            do {
                self.books = try await self.model.fetchBooks()
                //TODO: 借りている人のみ表示
                self.filteredInSearchWordBooks = self.model.filteringFromBooks(searchText: searchText, books: self.books)
                
                self.matchedBooks = self.filteredInSearchWordBooks
                
                self.view.hideInFetchActivityIndicatorAndShowBookManageView()
                self.view.updateBooksFilteredSearchWord()
                
            }catch {
                //TODO: この後ReloadDataとか，hideInFetchActivityIndicatorAndShowBookManageViewした方がいいかも
                self.view.showErrorFetchBooks(errorMessage: error.localizedDescription)
                //self.view.hideInFetchActivityIndicatorAndShowBookManageView()
            }
        }
    }
    
    func borrowedBookSwitchIsOn() {
        self.matchedBooks = self.model.borrowedBookSwitchIsOn(filteredInSearchWordBooks: self.filteredInSearchWordBooks)
        
        self.view.upadteBooksFilteredBorrowedBook()
        
    }
    
    func borrowedBookSwitchIsOff() {
        self.matchedBooks = self.filteredInSearchWordBooks
        
        self.view.upadteBooksFilteredBorrowedBook   ()
    }
    
}
