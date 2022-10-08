//
//  File.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/06.
//

import Foundation

class User {
    var id: String
    var name: String
    var order: Int
    
    init(id: String, name: String, order: Int) {
        self.id = id
        self.name = name
        self.order = order
    }
}
