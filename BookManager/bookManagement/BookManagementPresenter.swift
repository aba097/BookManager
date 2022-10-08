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
}

protocol BookManagementPresenterOutput: AnyObject {
    func showInFetchActivityIndicatorAndHideBookManageView()
    func hideInFetchActivityIndicatorAndShowBookManageView()
    func showErrorFetchBooks(errorMessage: String)
    func updateBooks()
}

final class BookManagementPresenter: BookManagementPresenterInput {
    
    private weak var view: BookManagementPresenterOutput!
    private var model: BookManagementModelInput
    
    private var user: User
    private(set) var books: [Book] = []
    private(set) var matchedBooks: [Book] = []
    
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
        view.showInFetchActivityIndicatorAndHideBookManageView()
        
        Task.detached {
            do {
                self.books = try await self.model.fetchBooks()
                //TODO: 借りている人のみ表示
                self.matchedBooks = self.model.filteringFromBooks(searchText: searchText, books: self.books)
                self.view.hideInFetchActivityIndicatorAndShowBookManageView()
                self.view.updateBooks()
                
            }catch {
                //TODO: この後ReloadDataとか，hideInFetchActivityIndicatorAndShowBookManageViewした方がいいかも
                self.view.showErrorFetchBooks(errorMessage: error.localizedDescription)
                //self.view.hideInFetchActivityIndicatorAndShowBookManageView()
            }
        }
    }
    
}
