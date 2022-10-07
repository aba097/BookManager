//
//  File.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/07.
//

import Foundation

protocol BookRegisterPresenterInput {
    func pressedBookRegisterButton(inputTitle: String, inputAuthor: String, inputPublisher: String)
}

protocol BookRegisterPresenterOutput: AnyObject{
    
}
