//
//  BookManagementPresenter.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/08.
//

import Foundation

protocol BookManagementPresenterInput {
    func viewDidLoad()
}

protocol BookManagementPresenterOutput: AnyObject {
    
}

final class BookManagementPresenter: BookManagementPresenterInput {
    
    private weak var view: BookManagementPresenterOutput!
    private var model: BookManagementModelInput
    
    private var user: User
    
    init(view: BookManagementPresenterOutput, model: BookManagementModelInput, user: User) {
        self.view = view
        self.model = model
        self.user = user
    }
    
    func viewDidLoad() {
        Task.detached {
            do {
                try await self.model.fetchBooks()
            }catch {
                
            }
        }
    }
    
}
