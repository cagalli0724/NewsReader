//
//  IndexBarCollCell.swift
//  Project0410
//
//  Created by yipei zhu on 4/24/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import Foundation
import UIKit

class IndexBarCollCell: UICollectionViewCell  {
    @IBOutlet var IndexImg:UIImageView!
    @IBOutlet var IndexName:UILabel!
    //sets fonts of labels
    override func awakeFromNib() {
        //self.backgroundColor = UIColor.black
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0
        
    }
}
