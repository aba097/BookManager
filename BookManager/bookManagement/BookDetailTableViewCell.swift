//
//  BookDetailTableViewCell.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/02.
//

import UIKit

class BookDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookThumbnailImageView: UIImageView!
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookPublisherLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(book: Book) {
        self.bookTitleLabel.text = book.title
        self.bookAuthorLabel.text = book.author
        self.bookPublisherLabel.text = book.publisher
        self.bookThumbnailImageView.image = UIImage(named: "noimage")
        
        if book.imageUrl == "" { return }
    
        //TODO: 非同期処理でImageUrlからImageを取得
        DispatchQueue.global().async {
            do {
                let imageData: Data? = try Data(contentsOf: URL(string: book.imageUrl)!)
                DispatchQueue.main.async {
                    if let data = imageData {
                        self.bookThumbnailImageView.image = UIImage(data: data)
                    }
                }
            }
            catch {
                //errorの場合はnoimageがセットされている
                print("Error : \(error.localizedDescription)")
            }
        }
   
    }

}
