//
//  File.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/07.
//

import Foundation
import Firebase
import FirebaseStorage

protocol BookRegisterModelInput {
    func postBookInfo(inputTitle: String, inputAuthor: String, inputPublisher: String, inputImage: Data?)
    func fetchBookInfo(ISBNCode: String) async throws -> Book
    
    var delegate: BookRegisterModelDelegate? { get set }
}

protocol BookRegisterModelDelegate {
    func postBookInfoResult(result: Result<String, Error>)
}

final class BookRegisterModel: BookRegisterModelInput {
    
    var delegate: BookRegisterModelDelegate?
    
    func postBookInfo(inputTitle: String, inputAuthor: String, inputPublisher: String, inputImage: Data?) {
        
        if inputImage == nil {
            return
        }
        
        let storage = Storage.storage()
        let reference = storage.reference()
        
        let path = "bookImage/test.jpeg"
        let imageRef = reference.child(path)
      
        let uploadTask = imageRef.putData(inputImage!)
        
        uploadTask.observe(.success) { _ in
            self.delegate?.postBookInfoResult(result: .success("登録完了"))
        }
        
        uploadTask.observe(.failure) { snapshot in
            self.delegate?.postBookInfoResult(result: .failure(snapshot.error!))
        }
        
    }
    
    //OpenDBAPIを使用して図書データ取得
    func fetchBookInfo(ISBNCode: String) async throws -> Book{
        let baseURL = "https://api.openbd.jp/v1/get?isbn="
        do {
            let data = try await downloadData(urlString: baseURL + ISBNCode)
            let bookdata:[Isbn] = try JSONDecoder().decode([Isbn].self, from: data)
            
            var image: Data? = nil
            if bookdata[0].summary.cover != "" {
                image = try? await downloadData(urlString: bookdata[0].summary.cover)
            }
            
            return Book(title: bookdata[0].summary.title, author: bookdata[0].summary.author, publisher: bookdata[0].summary.publisher, image: image)
       
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
    
    

}
