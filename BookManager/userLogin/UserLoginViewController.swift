//
//  ViewController.swift
//  BookManager
//
//  Created by 相場智也 on 2022/09/21.
//

import UIKit

class UserLoginViewController: UIViewController {

    @IBOutlet weak var userSelectionPickerView: UIPickerView!
    
    private var presenter: UserLoginPresenterInput!
    func inject(presenter: UserLoginPresenterInput){
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup(){
        self.userSelectionPickerView.dataSource = self
        self.userSelectionPickerView.delegate = self
    }
    
    @IBAction func pressedLoginButton(_ sender: Any) {
        self.presenter.pressedLoginButton()
    }
    
}

//MARK: - pickerView -
extension UserLoginViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    //pickerviewの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //マジックナンバーだが，今後1でない数値になることはないと思われる
        return 1
    }
    
    //pickerviewの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.presenter.numberOfUsers
    }
    
    //pickerviewの各データ
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.presenter.userName(row: row)
    }
    
    
   
   // pickerview選択時
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       self.presenter.didSelectRow(row: row)
   }
    
}

extension UserLoginViewController: UserLoginPresenterOutput{
    func transitonToBookManagement(user: User) {
        //TODO: 画面遷移のコードを追加
    }
    
    
}

