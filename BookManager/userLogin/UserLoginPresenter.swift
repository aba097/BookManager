//
//  UserLoginPresenter.swift
//  BookManager
//
//  Created by 相場智也 on 2022/10/06.
//

import Foundation

protocol UserLoginPresenterInput {
    var numberOfUsers: Int { get }
    func userName(row: Int) -> String
    func viewDidLoad()
    func didSelectRow(row: Int)
    func pressedLoginButton()
}

protocol UserLoginPresenterOutput: AnyObject {
    func transitonToBookManagement(user: User)
    func showErrorAtUsersFetchAndExit(errorMessage: String)
    func setupPickerView()
    func doEnableLoginButton()
}

final class UserLoginPresenter: UserLoginPresenterInput {
    
    private(set) var users: [User] = []
    private(set) var user: User?
    
    private weak var view: UserLoginPresenterOutput!
    private var model: UserLoginModelInput
    
    init(view: UserLoginPresenterOutput, model: UserLoginModelInput) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        Task.detached {
            do {
                self.users = try await self.model.fetchUser()
                self.view.setupPickerView()
                self.view.doEnableLoginButton()
            }catch{
                self.view.showErrorAtUsersFetchAndExit(errorMessage: error.localizedDescription)
            }
        }
    }
    
    var numberOfUsers: Int {
        return users.count
    }
    
    func userName(row: Int) -> String {
        return users[row].name
    }
    
    func didSelectRow(row: Int) {
        user = users[row]
    }
    
    func pressedLoginButton() {
        
        if user == nil {
            user = users[0]
        }
        
        view.transitonToBookManagement(user: user!)
    }
}

