//
//  addModifyContoller.swift
//  MyPlaces
//
//  Created by Toni Casas on 24/10/18.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit

class addModifyContoller: UIViewController {

    let manager = PlaceManager.shared
    var newPlace: Place!
    var place: Place?
    @IBOutlet weak var name_txt: UITextField!
    @IBOutlet weak var description_txt: UITextView!
    @IBOutlet weak var discount_txt: UITextField!
    @IBOutlet weak var touristic_sw: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Afegim un avisador pq quan piquem fora els textfield amagi el teclat
        let hideKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardAction))
        view.addGestureRecognizer(hideKeyboard)
        
        if let place = place {
            name_txt.text = place.name
            description_txt.text = place.description
            if(place.type == .touristic){
                touristic_sw.isOn = true
                discount_txt.isEnabled = true
                let placeTourist = place as? PlaceTourist
                discount_txt.text = placeTourist!.discount_tourist
            }
        }
    }

    @IBAction func isTouristic(_ sender: UISwitch) {
        discount_txt.isEnabled = sender.isOn
    }
    
    @IBAction func save_place(_ sender: Any) {
        if (name_txt.text == "") {
            name_txt.backgroundColor = UIColor(red:0.98, green:0.91, blue:0.91, alpha:1.0)
            return
        }else{
            name_txt.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1.0)
        }
        
        if (place != nil) {
            //Afegirem una funció mes endavant per a poder modificar les dades de la Place
            let update_message = UIAlertController(title: "Atención!", message: "Esta función se añadirá en una próxima actualización", preferredStyle: .alert)
            update_message.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            self.present(update_message, animated: true, completion: nil)
            return
        }else{
            if (touristic_sw.isOn){
                newPlace = PlaceTourist(name: name_txt.text!, description: description_txt.text!, discount_tourist: discount_txt.text!, image_in: nil)
            }else{
                newPlace = Place(name: name_txt.text!, description: description_txt.text!, image_in: nil)
            }
            manager.append(newPlace!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelar_bt(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func hideKeyboardAction(){
        name_txt.endEditing(true)
        description_txt.endEditing(true)
        discount_txt.endEditing(true)
    }
}
