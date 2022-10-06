//
//  File.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/06.
//

import Foundation

class User {
    var name: String
    var isRoot: Bool
    
    init(name: String, isRoot: Bool) {
        self.name = name
        self.isRoot = isRoot
    }
}
