//
//  UserLoginModel.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/06.
//

import Foundation
import Firebase

protocol UserLoginModelInput {
    func fetchUserMock() -> [User]
    func fetchUser() async throws -> [User]
}

final class UserLoginModel: UserLoginModelInput {
    y
    func fetchUser() async throws -> [User] {
        var users: [User] = []
        let db = Firestore.firestore()
        do {
            let documents = try await db.collection("users").getDocuments(source: .default)
            for document in documents.documents {
                users.append(User(id: document.documentID, name: document.get("name") as! String, isRoot: document.get("isRoot") as! Bool))
            }
        }catch{
            print("ERROR Message", error.localizedDescription)
            throw error
        }
        return users
    }
    
    func fetchUserMock() -> [User] {
        var users: [User] = []
        users.append(User(id: "aaaa", name: "test1", isRoot: false))
        users.append(User(id: "bbbb", name: "test2", isRoot: true))
        users.append(User(id: "cccc", name: "test3", isRoot: false))
        return users
    }
    
}
