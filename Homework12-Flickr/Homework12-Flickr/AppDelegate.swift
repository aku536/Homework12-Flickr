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
        
        setup()
        
        let navigationController = UINavigationController(rootViewController: viewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
 
        return true
    }
    
    private func setup() {
        let interactor = Interactor()
        let presenter = Presenter()
        let networkWorker = NetworkWorker()
        let coreDataWorker = CoreDataWorker()
        let router = Router()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        interactor.networkWorker = networkWorker
        interactor.coreDataWorker = coreDataWorker
        router.viewController = viewController
    }
    
}
