//
//  PlaceCellItem.swift
//  MyPlaces
//
//  Created by Toni Casas on 22/10/18.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit

class PlaceCellItem: UITableViewCell {

    @IBOutlet weak var name_txt: UILabel!
    @IBOutlet weak var description_txt: UILabel!
    @IBOutlet weak var discount_txt: UILabel!
    @IBOutlet weak var place_img: UIImageView!
    @IBOutlet weak var colorBarType: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
