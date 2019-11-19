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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let service = NetworkService(session: SessionFactory().createDefaultSession())
        let interactor = Interactor(networkService: service)
        let viewController = ViewController(interactor: interactor)
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

