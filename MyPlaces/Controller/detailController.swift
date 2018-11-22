//
//  DetailController.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    var place: Place?
    
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    @IBOutlet weak var place_img: UIImageView!
    @IBOutlet weak var name_txt: UILabel!
    @IBOutlet weak var description_txt: UILabel!
    @IBOutlet weak var discount_txt: UILabel!
    @IBOutlet weak var image_background: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image_background.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        discount_txt.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        if let place = place {
            name_txt.text = place.name
            description_txt.text = place.descript
            discount_txt.isHidden = true
            switch place.type {
                case .generic:
                    image_background.backgroundColor = UIColor(red:0.97, green:0.67, blue:0.09, alpha:1.0)
                case .touristic:
                    if(place.discount.count > 0){
                        discount_txt.isHidden = false
                        discount_txt.text = "-\(place.discount)%"
                    }
                    image_background.backgroundColor = UIColor(red:0.32, green:0.64, blue:0.23, alpha:1.0)
            }
            if(place.image != nil){
                place_img.image = UIImage(data: place.image!)
            }
        }       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEditPlace" {
            if let dc = segue.destination as? addModifyContoller {
                dc.place = sender as? Place
            }
        }
    }
    
    @IBAction func edit_bt(_ sender: Any) {
        performSegue(withIdentifier: "ShowEditPlace", sender: place)
    }
    
    @IBAction func back_bt(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
