//
//  AppDelegate.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 16/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let viewController = ViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        setup()
        
        return true
    }
    
    private func setup() {
        let interactor = Interactor()
        let presenter = Presenter()
        let worker = Worker()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        interactor.worker = worker
    }
    
}


