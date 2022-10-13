//
//  File.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/07.
//

import Foundation
import AVFoundation

protocol BookRegisterPresenterInput {
    func pressedBookRegisterButton(inputTitle: String, inputAuthor: String, inputPublisher: String, inputImage: Data?)
    func pressedISBNSearchButton(inputISBNCode: String)
    func scanISBNCode(avMetadataObjects: [AVMetadataObject])
    func pressedPhotoUploadButton()
    func pressedCameraBootOrEndButton(buttonIsSelected: Bool)
    func viewDidDisappear()
}

protocol BookRegisterPresenterOutput: AnyObject {
    func showSuccessPostBookInfo(message: String)
    func showErrorPostBookInfo(message: String)
    func showErrorNotInputTitle(errorMessage: String)
    func showPhotoUploadAlert()
    func setFetchBookInfo(title: String, author: String, publisher: String, image: Data?)
    func showErrorFetchBookInfo(errorMessage: String)
    func captureStart()
    func captureStop()
}

final class BookRegisterPresenter: BookRegisterPresenterInput {
    
    private weak var view: BookRegisterPresenterOutput!
    private var model: BookRegisterModelInput
    
    init(view: BookRegisterPresenterOutput, model: BookRegisterModelInput) {
        self.view = view
        self.model = model
        self.model.delegate = self
    }
    
    func viewDidDisappear() {
        self.view.captureStop()
    }
    
    
    func pressedBookRegisterButton(inputTitle: String, inputAuthor: String, inputPublisher: String, inputImage: Data?) {
        if inputTitle == "" {
            self.view.showErrorNotInputTitle(errorMessage: "Title is required")
            return
        }
    
        self.model.postBookInfo(inputTitle: inputTitle, inputAuthor: inputAuthor, inputPublisher: inputPublisher, inputImage: inputImage)
    }
    
    func pressedISBNSearchButton(inputISBNCode: String) {
        fetchBookInfo(inputISBNCode: inputISBNCode)
    }
    
    func scanISBNCode(avMetadataObjects: [AVMetadataObject]) {
        let objects = avMetadataObjects
        
        for metadataObject in objects {
            if metadataObject.type == AVMetadataObject.ObjectType.ean8 ||  metadataObject.type == AVMetadataObject.ObjectType.ean13 {
//                guard self.capturePreviewLayer.transformedMetadataObject(for: metadataObject) is AVMetadataMachineReadableCodeObject else { continue }
                    if let object = metadataObject as? AVMetadataMachineReadableCodeObject {
                    fetchBookInfo(inputISBNCode: object.stringValue!)
                }
            }
        }
    }
        
    func fetchBookInfo(inputISBNCode: String){
        Task.detached {
            do {
                let book: Book = try await self.model.fetchBookInfo(ISBNCode: inputISBNCode)
                self.view.setFetchBookInfo(title: book.title, author: book.author, publisher: book.publisher, image: book.image)
            }catch {
                self.view.showErrorFetchBookInfo(errorMessage: error.localizedDescription)
            }
        }
    }
    
    func pressedPhotoUploadButton() {
        self.view.showPhotoUploadAlert()
    }
    
    func pressedCameraBootOrEndButton(buttonIsSelected: Bool) {
        //MARK: IsSelectedは初期値がfalseなので注意
        if buttonIsSelected {
            self.view.captureStop()
        }else {
            self.view.captureStart()
        }
    }
    
}

extension BookRegisterPresenter: BookRegisterModelDelegate {
    func postBookInfoResult(result: Result<String, Error>) {
        switch result {
        case .success(let successMessage):
            self.view.showSuccessPostBookInfo(message: successMessage)
        case .failure(let error):
            self.view.showErrorPostBookInfo(message: error.localizedDescription)
        }

    }
    
    
}
