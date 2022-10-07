//
//  File.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/07.
//

import Foundation
import Firebase

protocol BookRegisterModelInput {
    func postBookInfo(inputTitle: String, inputAuthor: String, inputPublisher: String, inputImage: Data?)
}

final class BookRegisterModel: BookRegisterModelInput {
    func postBookInfo(inputTitle: String, inputAuthor: String, inputPublisher: String, inputImage: Data?) {
        
    }
    

}
