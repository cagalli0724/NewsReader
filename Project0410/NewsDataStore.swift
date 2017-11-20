//
//  NewsDataStore.swift
//  Project0410
//
//  Created by yipei zhu on 4/10/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import Foundation


import UIKit

class NewsDataStore {
    
    var allItems = [[NewsDataItem]]()
    var allItemsCount = [Int]()
    
    init()
    {
        //super.init()
        
    }
    
    func setIndexNum(_ IndexNum:Int) -> Void{
        if (IndexNum > 0) {
            self.clearAll()
            for _ in 1...IndexNum{
                
                allItems.append([NewsDataItem]())
                allItemsCount.append(0)
            }

        }
        
    }
    
    func clearItemsByIndx(_ index:Int){
        if allItems.count > index {
            allItems[index].removeAll(keepingCapacity: true)
            allItemsCount[index] = 0
        }
    }
    
    func getItemCount(_ index:Int)->Int{
        if(allItems[index].count < allItemsCount[index]){
            allItemsCount[index] = allItems[index].count
        }
        return allItemsCount[index]
    }
    
    func appendItemCount(_ index:Int){
        if(allItems[index].count > (allItemsCount[index] + 10)){
            allItemsCount[index] = allItemsCount[index] + 10
        }
        else{
            allItemsCount[index] = allItems[index].count
        }
    }
    

    func clearAll() -> Void{
        allItems.removeAll(keepingCapacity: false)
        
        allItemsCount.removeAll(keepingCapacity: false)
        //allItems = [[NewsDataItem]]()
    }
    
    func append(_ index:Int ,_ item:NewsDataItem) -> Void{
        print("NewsDataStore append!")
        allItems[index].append(item)
        
        print("index: \(index), count: \(allItems[index].count)")
        
        
    }
    
   
    
}
