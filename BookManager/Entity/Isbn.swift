//
//  Isbん.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/07.
//

import Foundation

class Isbn: Decodable {
    let summary:Summary
}

class Summary: Decodable {
    let title: String
    let publisher: String
    let author: String
    let cover: String
}
