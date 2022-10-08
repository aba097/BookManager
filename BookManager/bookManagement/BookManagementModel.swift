//
//  BookManagementModel.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/08.
//

import Foundation
import Firebase

protocol BookManagementModelInput {
    func fetchBooks()async throws -> [Book]
    func filteringFromBooks(searchText: String, books: [Book]) -> [Book]
}

final class BookManagementModel: BookManagementModelInput {
        
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
    
    func filteringFromBooks(searchText: String, books: [Book]) -> [Book] {
        
        if searchText == "" {
            return books
        }
        
        var matchedBooks: [Book] = []
        
        for book in books {
            if book.title.lowercased().contains(searchText.lowercased()) {
                matchedBooks.append(book)
                continue
            }
            
            if book.author.lowercased().contains(searchText.lowercased()) {
                matchedBooks.append(book)
                continue
            }
            
            if book.publisher.lowercased().contains(searchText.lowercased()) {
                matchedBooks.append(book)
                continue
            }
        }
        
        return matchedBooks
    }
    
}
