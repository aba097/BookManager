//
//  ViewController.swift
//  BookManager
//
//  Created by 相場智也 on 2022/09/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userSelectionPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userSelectionPickerView.dataSource = self
        userSelectionPickerView.delegate = self
        
        
    }


    @IBAction func pressedLoginButton(_ sender: Any) {
    }
    
}

extension LoginViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    //pickerviewの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //pickerviewの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        2
    }
    
    //pickerviewの各データ
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "test"
    }
    
    
   /*
   // pickerview選択時
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       self.textField.text = list[row]
   }
    */
}

