//
//  MainTableViewCell.swift
//  Sweet Memories
//
//  Created by Mac air on 11/27/16.
//  Copyright © 2016 Mac air. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var note: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
