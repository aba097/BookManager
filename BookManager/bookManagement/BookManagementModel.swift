//
//  BookManagementModel.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/08.
//

import Foundation
import Firebase

enum UpdateState: String{
    case success = "Update completed"
    case nomatch = "The book state is different"
}
protocol BookManagementModelInput {
    func fetchBooks()async throws -> [Book]
    func filteringFromBooks(searchText: String, books: [Book]) -> [Book]
    func borrowedBookSwitchIsOn(filteredInSearchWordBooks: [Book]) -> [Book]
    func borrowBook(book: Book, userName: String) async throws -> UpdateState
    func returnBook(book: Book) async throws -> UpdateState
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
        
        var filteredInSearchWordBooks: [Book] = []
        
        for book in books {
            if book.title.lowercased().contains(searchText.lowercased()) {
                filteredInSearchWordBooks.append(book)
                continue
            }
            
            if book.author.lowercased().contains(searchText.lowercased()) {
                filteredInSearchWordBooks.append(book)
                continue
            }
            
            if book.publisher.lowercased().contains(searchText.lowercased()) {
                filteredInSearchWordBooks.append(book)
                continue
            }
        }
        
        return filteredInSearchWordBooks
    }
    
    
    func borrowedBookSwitchIsOn(filteredInSearchWordBooks: [Book]) -> [Book] {
        var matchedBooks: [Book] = []
        for filteredInSearchWordBook in filteredInSearchWordBooks {
            if filteredInSearchWordBook.state != "" {
                matchedBooks.append(filteredInSearchWordBook)
            }
        }
        
        return matchedBooks
    }
    
    func borrowBook(book: Book, userName: String) async throws -> UpdateState {
        let db = Firestore.firestore()
        do {
            let document = try await db.collection("books").document(book.id).getDocument()
            if document.get("state") as! String != book.state {
                return .nomatch
            }
            
            try await db.collection("books").document(book.id).updateData(["state" : userName])
        }catch {
            throw error
        }
        
        return .success
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
