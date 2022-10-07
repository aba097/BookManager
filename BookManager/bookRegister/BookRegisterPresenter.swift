//
//  File.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/07.
//

import Foundation

protocol BookRegisterPresenterInput {
    func pressedBookRegisterButton(inputTitle: String, inputAuthor: String, inputPublisher: String, inputImage: Data?)
    func pressedISBNSearchButton(inputISBNCode: String)
}

protocol BookRegisterPresenterOutput: AnyObject {
    func showErrorPost(errorMessage: String)
}

final class BookRegisterPresenter: BookRegisterPresenterInput {
    
    private weak var view: BookRegisterPresenterOutput!
    private var model: BookRegisterModelInput
    
    init(view: BookRegisterPresenterOutput, model: BookRegisterModelInput) {
        self.view = view
        self.model = model
    }
    
    func pressedBookRegisterButton(inputTitle: String, inputAuthor: String, inputPublisher: String, inputImage: Data?) {
        
    }
    
    func pressedISBNSearchButton(inputISBNCode: String) {
        
    }
}
