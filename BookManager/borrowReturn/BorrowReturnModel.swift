//
//  BorrowReturnModel.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/14.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

//enum UpdateState: String{
//    case success = "Update completed"
//    case nomatch = "Book state is different"
//}

protocol BorrowReturnModelInput {
    func fetchBookInfo(ISBNCode: String) async throws -> Book
    func fetchBooks() async throws -> [Book]
    func borrowBook(book: Book, userName: String) async throws -> UpdateState
    func returnBook(book: Book) async throws -> UpdateState
}

class BorrowReturnModel: BorrowReturnModelInput {
    
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
            throw error
        }
        return books
    }
    
    //OpenDBAPIを使用して図書データ取得
    func fetchBookInfo(ISBNCode: String) async throws -> Book{
        let baseURL = "https://api.openbd.jp/v1/get?isbn="
        do {
            let data = try await downloadData(urlString: baseURL + ISBNCode)
            let bookdata:[Isbn] = try JSONDecoder().decode([Isbn].self, from: data)
    
            return Book(id: nil, title: bookdata[0].summary.title, author: bookdata[0].summary.author, publisher: bookdata[0].summary.publisher, state: "", image: nil, imageUrl: "")
        }catch {
            throw error
        }
    }
    
    func downloadData(urlString:String) async throws -> Data {
        let url = URL(string: urlString)!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        }catch {
            throw error
        }
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
