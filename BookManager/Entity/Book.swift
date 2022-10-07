//
//  Book.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/07.
//

import Foundation

class Book {
    public var id = UUID().uuidString
    var title: String
    var author: String
    var publisher: String
    var image: Data?
    
    init(title: String, author: String, publisher: String, image: Data?) {
        self.title = title
        self.author = author
        self.publisher = publisher
        self.image = image
    }
}
