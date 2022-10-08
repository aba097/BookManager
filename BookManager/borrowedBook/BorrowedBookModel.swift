//
//  BorrowedBookModel.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/08.
//

import Foundation
import Firebase

//TODO: BookManagementModelと同じようなところが多いので再利用できるようにシステムアーキテクチャの導入を検討する

protocol BorrowedBookModelInput {
    func fetchBooks()async throws -> [Book]
    func returnBook(book: Book) async throws -> UpdateState
    func filteredBorrowedBooks(books: [Book], userName: String) -> [Book]
}

final class BorrowedBookModel: BorrowedBookModelInput {
    
    func fetchBooks() async throws -> [Book] {
        var books: [Book] = []
        let db = Firestore.firestore()
        
        do {
            let documents = try await db.collection("books").getDocuments(source: .default)
            for document in documents.documents {
                books.append(Book(id:        document.documentID,
                                  title:     document.get("title")     as! String,
                                  author:    document.get("author")    as! String,
                                  publisher: document.get("publisher") as! String,
                                  state:     document.get("state")     as! String,
                                  image:     nil,
                                  imageUrl:  document.get("imageUrl")  as! String))
            }
        }catch{
            print("ERROR Message", error.localizedDescription)
            throw error
        }
        return books
    }
    
    func filteredBorrowedBooks(books: [Book], userName: String) -> [Book] {
        var borrowedBooks: [Book] = []
        for book in books {
            if book.state == userName {
                borrowedBooks.append(book)
            }
        }
        
        return borrowedBooks
    }
    
    
    func returnBook(book: Book) async throws -> UpdateState {
        let db = Firestore.firestore()
        do {
            let document = try await db.collection("books").document(book.id).getDocument()
            if document.get("state") as! String != book.state {
                return .nomatch
            }
                        
            try await db.collection("books").document(book.id).updateData(["state" : ""])
        }catch {
            throw error
        }
        
        return .success
    }
    
}
