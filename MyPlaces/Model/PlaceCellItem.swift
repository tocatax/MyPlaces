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
    @IBOutlet weak var backgroundCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        colorBarType.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        backgroundCell.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCell.layer.shadowColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0).cgColor
        backgroundCell.layer.shadowRadius = 6
        backgroundCell.layer.shadowOpacity = 1
        backgroundCell.layer.masksToBounds = false;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
