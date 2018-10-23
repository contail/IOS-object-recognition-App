//
//  MainFeatureCell.swift
//  FirstMyApp
//
//  Created by sangjin park on 2018. 9. 3..
//  Copyright © 2018년 Loguin. All rights reserved.
//

import UIKit

class MainFeatureCell: UITableViewCell {

    @IBOutlet weak var featureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
