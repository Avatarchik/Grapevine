//
//  EventTableViewCell.swift
//  Grapevine
//
//  Created by Jenny Yang on 12/7/15.
//  Copyright © 2015 Jenny Yang. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet var eventNameLabel: UILabel!
    @IBOutlet var eventDateLabel: UILabel!
    @IBOutlet var eventTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
