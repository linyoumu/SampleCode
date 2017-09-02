//
//  NewsCell.swift
//  SwiftGrammar
//
//  Created by Myfly on 17/9/2.
//  Copyright © 2017年 Myfly. All rights reserved.
//

import UIKit
import SDWebImage

class NewsCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    @IBOutlet weak var voteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension NewsCell{
    func homeCellWith(cellModel:NewModel) {
        title.text = cellModel.title
        sourceLabel.text = cellModel.source
        let voteC = String(cellModel.votecount)
        voteLabel.text = "\(voteC)人跟帖"
        
        if let imgUrl = URL(string:cellModel.imgsrc) {
            icon.sd_setImage(with: imgUrl)
        }
        
    }
}
