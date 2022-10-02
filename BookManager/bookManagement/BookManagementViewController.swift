//
//  BookManagementViewController.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/02.
//

import UIKit

class BookManagementViewController: UIViewController {

    @IBOutlet weak var bookSearchBar: UISearchBar!
    
    @IBOutlet weak var showBookListTableView: UITableView!
    
    //TODO: 絞り込みボタンを押したときの処理を書く
    //絞り込みボタンを押された時に、検索ワードの検索範囲（全て、タイトル、著者、出版社）、昇順降順、借りている本のみ
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
