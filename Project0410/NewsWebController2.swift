//
//  NewsWebController2.swift
//  Project0410
//
//  Created by yipei zhu on 4/27/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import Foundation
//
//  ViewController.swift
//  Project0410
//
//  Created by yipei zhu on 4/10/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//


import UIKit
import Foundation

class NewsWebController2:UIViewController{
    
    @IBOutlet var webview:UIWebView!
    
    var url: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(url!)
        
        webview.loadRequest(URLRequest(url: URL(string:url!)!))
        
    }
    
    
    
}

