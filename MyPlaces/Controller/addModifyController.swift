//
//  addModifyContoller.swift
//  MyPlaces
//
//  Created by Toni Casas on 24/10/18.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit
import MapKit

class addModifyContoller: UIViewController, CLLocationManagerDelegate {

    let manager = PlaceManager.shared
    var locationManager = CLLocationManager()
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
        
        // Moure la vista quan surt el tecalt
        NotificationCenter.default.addObserver(self, selector: #selector(addModifyContoller.keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addModifyContoller.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        if let place = place {
            name_txt.text = place.name
            description_txt.text = place.descript
            if(place.type == .touristic){
                touristic_sw.isOn = true
                discount_txt.isEnabled = true
                discount_txt.text = place.discount
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
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            let noGpsMessage = UIAlertController(title: "Atención!", message: "Debe teer activado el GPS para poder guardar una localización", preferredStyle: .alert)
            noGpsMessage.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            self.present(noGpsMessage, animated: true, completion: nil)
            return
        }
        
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        locationManager.stopUpdatingLocation()

print(place)
        if (place != nil) { manager.remove(place!)}
        let newType = touristic_sw.isOn ? Place.PlaceType.touristic : Place.PlaceType.generic
        newPlace = Place(type: newType, name: name_txt.text!, descript: description_txt.text!, location: locValue, discount: discount_txt.text!, image_in: nil)
        manager.append(newPlace!)
    
        if let jsonData = manager.jsonFrom(places: manager.places) {
            
            let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let filePath = docsPath.appendingPathComponent("places.json")
            
            do {
                try jsonData.write(to: filePath)
                print("Datos guardados")
            } catch {
                print("Error guardando datos")
            }
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height - 80
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}
