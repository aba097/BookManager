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
    var isRoot: Bool
    
    init(id: String, name: String, isRoot: Bool) {
        self.id = id
        self.name = name
        self.isRoot = isRoot
    }
}
