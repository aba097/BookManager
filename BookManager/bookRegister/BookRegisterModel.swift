//
//  File.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/07.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

protocol BookRegisterModelInput {
    func postBookInfo(inputTitle: String, inputAuthor: String, inputPublisher: String, inputImage: Data?)
    func fetchBookInfo(ISBNCode: String) async throws -> Book
    
    var delegate: BookRegisterModelDelegate? { get set }
}

//delegateを追加したことによってテストがしづらくなった
//async awaitでimageRef.putDataの終了を待つことができれば必要なくなりそう
protocol BookRegisterModelDelegate {
    func postBookInfoResult(result: Result<String, Error>)
}

final class BookRegisterModel: BookRegisterModelInput {
    
    var delegate: BookRegisterModelDelegate?
    
    func postBookInfo(inputTitle: String, inputAuthor: String, inputPublisher: String, inputImage: Data?) {
        
        let book = Book(id: nil, title: inputTitle, author: inputAuthor, publisher: inputPublisher, state: "", image: inputImage, imageUrl: "")
        
        if inputImage == nil {
            self.postBookInfoToFireStore(book: book)
        }else {
            //画像がある場合は画像をアップロードし，画像のURLをbook.imageUrlに格納
            let storage = Storage.storage()
            let reference = storage.reference()
            
            let path = "bookImage/" + book.id + ".jpeg"
            let imageRef = reference.child(path)
            
            let uploadTask = imageRef.putData(inputImage!)
            
            uploadTask.observe(.success) { _ in
                imageRef.downloadURL { url, _ in
                    if let url = url {
                        book.imageUrl = url.absoluteString
                        self.postBookInfoToFireStore(book: book)
                    }
                }
            }
            
            uploadTask.observe(.failure) { snapshot in
                self.delegate?.postBookInfoResult(result: .failure(snapshot.error!))
            }
        }
    }
    
    func postBookInfoToFireStore(book: Book) {
        let db = Firestore.firestore()
        Task.detached {
            do {
                try await db.collection("books").document(book.id).setData([
                    "title": book.title,
                    "author": book.author,
                    "publisher": book.publisher,
                    "state": book.state,
                    "imageUrl": book.imageUrl
                ])
                self.delegate?.postBookInfoResult(result: .success("Completion of registration"))
            } catch {
                self.delegate?.postBookInfoResult(result: .failure(error))
            }
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
            
            return Book(id: nil, title: bookdata[0].summary.title, author: bookdata[0].summary.author, publisher: bookdata[0].summary.publisher, state: "", image: image, imageUrl: "")
       
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
