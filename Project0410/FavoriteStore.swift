//
//  FavoriteStore.swift
//  Project0410
//
//  Created by yipei zhu on 4/27/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import Foundation


struct FavoriteItem{
    var title:String!
    var url:String!
    init(Title title:String,Url url:String){
        self.title = title
        self.url = url
    }
}

class FavoriteStore{
    
    var allItems = [FavoriteItem]()
    init()
    {
        //super.init()
        
    }
    
    
    
    
    
    
    
    func clearAll() -> Void{
        allItems.removeAll(keepingCapacity: false)
    
        //allItems = [[NewsDataItem]]()
    }
    
    func append(_ item:NewsDataItem) -> Void{
        
        var ifHas = false
        for Myitem in allItems{
            if(Myitem.url == item.url){
                ifHas = true
                break
            }
            
        }
        
        if(!ifHas){
            print("favorite item append")
            let fvtItem = FavoriteItem(Title: item.title!,Url: item.url!)
            allItems.append(fvtItem)
        }
        
        
        
    }
    
    
    func  remove(_ index: Int) -> Void {
        
        allItems.remove(at:index)
        
    }
    
    
}
