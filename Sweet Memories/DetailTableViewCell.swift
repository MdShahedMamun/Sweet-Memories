//
//  DetailTableViewCell.swift
//  Sweet Memories
//
//  Created by Mac air on 11/28/16.
//  Copyright © 2016 Mac air. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel:UILabel!;
    @IBOutlet var dateLabel:UILabel!;
    @IBOutlet var noteTextView:UITextView!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
