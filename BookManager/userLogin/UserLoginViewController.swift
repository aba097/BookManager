//
//  ViewController.swift
//  BookManager
//
//  Created by 相場智也 on 2022/09/21.
//

import UIKit

class UserLoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var userSelectionPickerView: UIPickerView!
    
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    
   
    private var presenter: UserLoginPresenterInput!
    func inject(presenter: UserLoginPresenterInput){
        self.presenter = presenter
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.loginButton.isEnabled = false
        //クルクルがストップした時にクルクルを非表示にする
        self.loginActivityIndicator.hidesWhenStopped = true
        
        self.presenter.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.loginActivityIndicator.stopAnimating()
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
    
    func setupPickerView() {
        DispatchQueue.main.sync {
            self.userSelectionPickerView.dataSource = self
            self.userSelectionPickerView.delegate = self
        }
    }
    
    func doEnableLoginButton() {
        DispatchQueue.main.sync {
            self.loginButton.isEnabled = true
        }
    }
    
    func transitonToBookManagement(user: User) {
        
        self.loginActivityIndicator.startAnimating()
        
        let bookTabVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "BookTabBar") as! UITabBarController
        bookTabVC.modalPresentationStyle = .fullScreen
        
        //本登録画面
        let bookRegisterViewController = bookTabVC.viewControllers![3] as! BookRegisterViewController
        let bookRegisterModel = BookRegisterModel()
        let bookRegisterPresenter = BookRegisterPresenter(view: bookRegisterViewController, model: bookRegisterModel)
        bookRegisterViewController.inject(presenter: bookRegisterPresenter)
        
        //借りている本一覧画面
        let borrowedBookViewController = bookTabVC.viewControllers![2] as! BorrowedBookViewController
        let borrowedBookModel = BorrowedBookModel()
        let borrowedBookPresenter = BorrowedBookPresenter(view: borrowedBookViewController, model: borrowedBookModel, user: user)
        borrowedBookViewController.inject(presenter: borrowedBookPresenter)
        
        //本一覧画面
        let bookManagementViewController = bookTabVC.viewControllers![0] as! BookManagementViewController
        let bookManagementModel = BookManagementModel()
        let bookManagementPresenter = BookManagementPresenter(view: bookManagementViewController, model: bookManagementModel, user: user)
        bookManagementViewController.inject(presenter: bookManagementPresenter)
        
        self.present(bookTabVC, animated: true, completion: nil) // 画面遷移
    }
    
    
}

