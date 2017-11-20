//
//  IndexBarSelCell.swift
//  Project0410
//
//  Created by yipei zhu on 4/24/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import UIKit

class IndexBarSelCell:  UICollectionViewCell{
    @IBOutlet var IndexImg:UIImageView!
    @IBOutlet var IndexName:UILabel!
    
    //var ifSelected:Bool = false
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0
    }
    
    
}
