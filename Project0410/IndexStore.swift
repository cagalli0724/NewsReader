//
//  IndexStore.swift
//  Project0410
//
//  Created by yipei zhu on 4/24/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import Foundation


class IndexStore {
    
    var allItems = [String]()
    var SelectedIndex:Int = 0
    
    

    
    static func getIndexSelList()->[SubURLEnum]{
        return [SubURLEnum.HomeUrl, SubURLEnum.UpshotUrl, SubURLEnum.ScienceUrl, SubURLEnum.SportsUrl,SubURLEnum.ArtsUrl,SubURLEnum.HealthUrl]
    }

    
    func resetToDefaultList(){
        clearAll();
        let indexnamelist = IndexStore.getIndexSelList()
        for indexItem in indexnamelist{
            allItems.append(indexItem.rawValue)
            
        }

    }
    
    
    init()
    {
        //super.init()
        let indexnamelist = IndexStore.getIndexSelList()
        for indexItem in indexnamelist{
            allItems.append(indexItem.rawValue)
            
        }
        
    }
    
    
    func clearAll() -> Void{
        allItems.removeAll(keepingCapacity: false)
        SelectedIndex = 0
    }
    
    
    
}
