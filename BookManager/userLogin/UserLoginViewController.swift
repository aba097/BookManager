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
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    @IBAction func pressedLoginButton(_ sender: Any) {
        self.presenter.pressedLoginButton()
    }
    
}

//MARK: - pickerView -
extension UserLoginViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    //pickerviewの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //MARK: マジックナンバーだが，今後1でない数値になることはないと思われる
        return 1
    }
    
    //pickerviewの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.presenter.numberOfUsers
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

//MARK: - Extension UserLoginPresenterOutput -
extension UserLoginViewController: UserLoginPresenterOutput{
    func showErrorAtUsersFetchAndExit(errorMessage: String) {
        let alert = UIAlertController(title: "エラー", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            //TODO: アプリを強制終了するようにしているが，再接続を試みるなど他のやり方があるかも
            //TODO: （Appleのガイドラインによるとプログラムから終了は勧められていない）
            exit(0)
        })
        alert.addAction(okAction)
        DispatchQueue.main.sync {
            present(alert, animated: true, completion: nil)
        }
    }
    
    func setupPickerView(){
        DispatchQueue.main.sync {
            self.userSelectionPickerView.dataSource = self
            self.userSelectionPickerView.delegate = self
        }
    }
    
    func transitonToBookManagement(user: User) {
        //TODO: 画面遷移のコードを追加

        let bookTabVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "BookTabBar") as! UITabBarController
        bookTabVC.modalPresentationStyle = .fullScreen
        //(bookTabVC.viewControllers![1] as! BookRegisterViewController).test = "hoge"
        
        self.present(bookTabVC, animated: true, completion: nil) // 画面遷移
    }
    
    
}

