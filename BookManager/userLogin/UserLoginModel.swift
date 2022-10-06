//
//  UserLoginModel.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/06.
//

import Foundation

protocol UserLoginModelInput {
    //TODO: firebaseから取得するように
    func fetchUserMock() -> [User]
}

final class UserLoginModel: UserLoginModelInput {
    func fetchUserMock() -> [User] {
        var users: [User] = []
        users.append(User(name: "test1", isRoot: false))
        users.append(User(name: "test2", isRoot: true))
        users.append(User(name: "test3", isRoot: false))
        return users
    }
}
