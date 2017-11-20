//
//  NewsDataItem.swift
//  Project0410
//
//  Created by yipei zhu on 4/10/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import Foundation
import UIKit


struct Photo {
    init(){
        
    }
    var ImageUrl:String?
    var copyright:String?
    var format:String?
    
}

class NewsDataItem: NSObject {
    var title: String?
    var desc: String?
    var byline:String?
    var url:String?
    var imageList = [Photo]()
    var publishedate:String?
    var type:String?
    //var image:UIImage?
    
    override init(){
        
    }
    
}
