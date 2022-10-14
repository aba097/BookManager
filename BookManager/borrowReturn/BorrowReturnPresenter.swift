//
//  BorrowReturnPresenter.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/14.
//

import Foundation

protocol BorrowReturnPresenterInput {
    func hoge()
}

protocol BorrowReturnPresenterOutput: AnyObject {
    func hoge()
}

final class BorrowReturnPresenter: BorrowReturnPresenterInput {
    
    private weak var view: BorrowReturnPresenterOutput!
    private var model: BorrowReturnModelInput
    private var user: User
    
    init(view: BorrowReturnPresenterOutput, model: BorrowReturnModelInput, user: User) {
        self.view = view
        self.model = model
        self.user = user
    }
    
    func hoge(){
        
    }
}
