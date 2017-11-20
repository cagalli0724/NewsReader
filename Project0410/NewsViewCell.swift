//
//  NewsViewCell.swift
//  Project0410
//
//  Created by yipei zhu on 4/10/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import UIKit


class NewsViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var authorLabel:UILabel!
    @IBOutlet var newsImage: UIImageView!
    
    
    //sets fonts of labels
    func updateLabels() {
        
        let bodyFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        descriptionLabel.font = bodyFont
        authorLabel.font = bodyFont

        
        let captionFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        titleLabel.font = captionFont
    }
}
