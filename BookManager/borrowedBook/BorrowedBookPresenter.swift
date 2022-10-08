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
}

protocol BorrowedBookPresenterOutput: AnyObject {
    func changedStateSuccess(message: String)
    func changedStateError(message: String)
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
}
