//
//  BookManagementPresenter.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/08.
//

import Foundation

enum BookState{
    case borrow
    case myselfReturn
    case otherUser
}

protocol BookManagementPresenterInput {
    func viewDidLoad()
    var numberOfBooks: Int { get }
    func book(forRow row: Int) -> Book?
    func searchBarSearchButtonClicked(searchText: String)
    func borrowedBookSwitchIsOn()
    func borrowedBookSwitchIsOff()
    func swipeCellState(row: Int) -> (String, BookState, Book)
    func pressedChangeState(state: BookState, book: Book)
    func pressedReloadButton(searchText: String)
}

protocol BookManagementPresenterOutput: AnyObject {
    func showInFetchActivityIndicatorAndHideBookManageView()
    func hideInFetchActivityIndicatorAndShowBookManageView()
    func showErrorFetchBooks(errorMessage: String)
    func updateBooksFilteredSearchWord()
    func upadteBooksFilteredBorrowedBook()
    func changedStateSuccess(message: String)
    func changedStateError(message: String)
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
    
    
    func pressedReloadButton(searchText: String) {
        fetchBooks(searchText: searchText)
    }
    
    func fetchBooks(searchText: String){
        self.view.showInFetchActivityIndicatorAndHideBookManageView()
        
        Task.detached {
            do {
                self.books = try await self.model.fetchBooks()
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
        
        self.view.upadteBooksFilteredBorrowedBook()
    }
    
    func swipeCellState(row: Int) -> (String, BookState, Book) {
        //借りられていない -> 借りる
        //借りられている　かつ　本人　->　返す
        //借りられている　かつ　本人でない　-> 借りている人
        if matchedBooks[row].state == "" {
            return ("借りる", BookState.borrow, matchedBooks[row])
        }
        
        if matchedBooks[row].state == user.name {
            return ("返す", BookState.myselfReturn, matchedBooks[row])
        }else {
            return (matchedBooks[row].state, BookState.otherUser, matchedBooks[row])
        }
    }
    
    func pressedChangeState(state: BookState, book: Book) {
 
        switch state {
        //他人のものなのでなにもしない
        case .otherUser:
            break
        case .borrow:
            Task.detached {
                do {
                    let updateState = try await self.model.borrowBook(book: book, userName: self.user.name)
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
        case .myselfReturn:
            Task.detached {
                do {
                    let updateState = try await self.model.returnBook(book: book)
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
    
    
}
