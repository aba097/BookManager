//
//  File.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/07.
//

import Foundation
import Firebase

protocol BookRegisterModelInput {
    func postBookInfo(inputTitle: String, inputAuthor: String, inputPublisher: String, inputImage: Data?)
    func fetchBookInfo(ISBNCode: String) async throws -> Book
}

final class BookRegisterModel: BookRegisterModelInput {
   
    func postBookInfo(inputTitle: String, inputAuthor: String, inputPublisher: String, inputImage: Data?) {
        
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
