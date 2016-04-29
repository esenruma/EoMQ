//
//  CustomCell.swift
//  EoMQ
//
//  Created by Roma on 28/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    
    @IBOutlet var imageViewCustom: UIImageView!
    
    @IBOutlet var nameLabelCustom: UILabel!
    
    @IBOutlet var resultsLabelCustom: UILabel!
    
    
    
    
// ---------------------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
