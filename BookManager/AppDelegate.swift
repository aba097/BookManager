//
//  AppDelegate.swift
//  BookManager
//
//  Created by 相場智也 on 2022/09/21.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //MARK: アプリ起動時にFirebaseに接続する
        //FirebaseApp.configure()
        
        //MARK: windowの作成とinjecton
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let userLoginViewController = UIStoryboard(name: "UserLogin", bundle: nil).instantiateInitialViewController() as! UserLoginViewController
        
        let model = UserLoginModel()
        let presenter = UserLoginPresenter(view: userLoginViewController, model: model)
        userLoginViewController.inject(presenter: presenter)
        
        self.window?.rootViewController = userLoginViewController
        //表示
        self.window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

