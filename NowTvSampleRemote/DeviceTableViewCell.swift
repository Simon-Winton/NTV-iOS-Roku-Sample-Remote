//
//  DeviceTableViewCell.swift
//  NowTvSampleRemote
//
//  Created by Winton, Simon (Associate Software Developer) on 28/11/2016.
//  Copyright © 2016 Winton, Simon (Associate Software Developer). All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {

    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var DeviceSNLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
