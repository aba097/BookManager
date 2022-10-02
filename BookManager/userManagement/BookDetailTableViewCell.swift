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

}
