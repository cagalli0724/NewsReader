//
//  MyTabBarController.swift
//  Project0410
//
//  Created by yipei zhu on 4/26/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import UIKit


class MyTabBarController: UITabBarController{
    
    static var emailName:String?
    
    static let itemStore = NewsDataStore()
    
    static let indexStore = IndexStore()
    
    static let imageStore = ImageStore()
    
    static let favoriteStore = FavoriteStore()
    
    static var ifLogin:Bool = false
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let viewControllers = self.viewControllers{
            let myNewsController = viewControllers[0] as! NewsViewController
            myNewsController.itemStore = MyTabBarController.itemStore
            myNewsController.indexStore = MyTabBarController.indexStore
            myNewsController.imageStore = MyTabBarController.imageStore
            myNewsController.favoriteStore = MyTabBarController.favoriteStore
        
            
            let favoriteController = viewControllers[1] as! FavoriteController
            
            favoriteController.favoriteStore = MyTabBarController.favoriteStore
            
            let indexController = viewControllers[2] as! IndexBarSelController
            indexController.indexStore = MyTabBarController.indexStore
            indexController.itemStore = MyTabBarController.itemStore
            indexController.newsViewController = myNewsController
            indexController.email = MyTabBarController.emailName!
            indexController.favoriteStore = MyTabBarController.favoriteStore
            
            
        }
        
        
    }
    
    
}
