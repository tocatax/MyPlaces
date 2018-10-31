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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let place = place {
            name_txt.text = place.name
            description_txt.text = place.description
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
