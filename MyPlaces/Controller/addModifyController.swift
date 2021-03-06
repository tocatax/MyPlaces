//
//  addModifyContoller.swift
//  MyPlaces
//
//  Created by Toni Casas on 24/10/18.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit
import MapKit

class addModifyContoller: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UITextViewDelegate {

    let manager = PlaceManager.shared
    let imagePicker = UIImagePickerController()
    var locationManager = CLLocationManager()
    var coordinates = CLLocationCoordinate2D()
    var annotation = MKPointAnnotation()
    var newPlace: Place!
    var place: Place?
    
    @IBOutlet weak var place_img: UIImageView!
    @IBOutlet weak var mapView_bt: UIButton!
    @IBOutlet weak var name_txt: UITextField!
    @IBOutlet weak var description_txt: UITextView!
    @IBOutlet weak var discount_txt: UITextField!
    @IBOutlet weak var touristic_sw: UISwitch!
    @IBOutlet weak var delete_place_bt: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var foto_lbl: UILabel!
    @IBOutlet weak var localizacion_lbl: UILabel!
    @IBOutlet weak var descPlaceholder: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            let noGpsMessage = UIAlertController(title: "Atención!", message: "Debe tener activado el GPS para poder guardar una localización", preferredStyle: .alert)
            noGpsMessage.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            self.present(noGpsMessage, animated: true, completion: nil)
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        discount_txt.delegate = self
        description_txt.delegate = self
        
        place_img.layer.borderColor = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 1.0).cgColor
        mapView_bt.layer.borderColor = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 1.0).cgColor
        foto_lbl.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        localizacion_lbl.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        imagePicker.delegate = self

        // Afegim un avisador pq quan piquem fora els textfield amagi el teclat
        let hideKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardAction))
        view.addGestureRecognizer(hideKeyboard)
        
        // Moure la vista quan surt el teclat
        NotificationCenter.default.addObserver(self, selector: #selector(addModifyContoller.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addModifyContoller.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if let place = place {
            if (place.descript != "") { descPlaceholder.isHidden = true}
            locationManager.stopUpdatingLocation()
            if(place.image != nil){
                place_img.image = UIImage(data: place.image!)
            }
            name_txt.text = place.name
            description_txt.text = place.descript
            if(place.type == .touristic){
                touristic_sw.isOn = true
                discount_txt.isEnabled = true
                discount_txt.text = place.discount
            }
            coordinates = place.coordinate
            delete_place_bt.isHidden = false
            let Region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
            mapView.setRegion(Region, animated: true)
            mapView.addAnnotation(place)
        }else{
            delete_place_bt.isHidden = true
            guard let coordinate = locationManager.location?.coordinate else { return }
            coordinates = coordinate
            locationManager.stopUpdatingLocation()
            let Region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
            mapView.setRegion(Region, animated: true)
            annotation.coordinate = coordinates
            mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func unwindToAddModifyController(_ sender: UIStoryboardSegue){}
    
    @IBAction func isTouristic(_ sender: UISwitch) {
        if (!sender.isOn) { discount_txt.text = ""}
        discount_txt.isEnabled = sender.isOn
    }
    
    // TextView DELEGATE
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        descPlaceholder.isHidden = true
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            descPlaceholder.isHidden = false
        }
    }
    
    // TextFiled DELEGATE
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Sempre volem permetre esborrar
        if string.isEmpty { return true }
        
        // Mirem com quedaria el contingut si acceptéssim els canvis
        let oldText = textField.text as NSString?
        let newText = oldText?.replacingCharacters(in: range, with: string)
        
        // Si el que quedaria és un enter entre 0 i 100 ho posem
        if let text = newText, let discount = Int(text) {
            if 0...100 ~= discount {
                textField.text = "\(discount)"
            }
        }
        return false
    }

    
    @IBAction func save_place(_ sender: Any) {
        if (name_txt.text == "") {
            name_txt.backgroundColor = UIColor(red:0.98, green:0.91, blue:0.91, alpha:1.0)
            return
        }else{
            name_txt.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1.0)
        }

        let image = place_img.image != nil ? place_img.image!.pngData() : nil
        
        if (place != nil) { manager.remove(place!)}
        
        let newType = touristic_sw.isOn ? Place.PlaceType.touristic : Place.PlaceType.generic
        newPlace = Place(type: newType, name: name_txt.text!, descript: description_txt.text!, location: coordinates, discount: discount_txt.text!, image_in: image)
        manager.append(newPlace!)
        saveToFile()
        performSegue(withIdentifier: "unwindToList", sender: nil)
    }
    
    // Popup per sel.leccionar foto desde càmara o galeria
    @IBAction func change_img_bt(_ sender: Any) {
        let alert = UIAlertController(title: "Seleccione imagen", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { _ in self.openCamera()}))
        alert.addAction(UIAlertAction(title: "Galería", style: .default, handler: { _ in self.openGallary()}))
        alert.addAction(UIAlertAction.init(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelar_bt(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Popup per confirmar i eliminar una place
    @IBAction func delete_place(_ sender: Any) {
        let deletePlaceMessage = UIAlertController(title: "Atención!", message: "¿Seguro que quiere eliminar este sitio?", preferredStyle: .alert)
        deletePlaceMessage.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: {( action: UIAlertAction!) in
            self.manager.remove(self.place!)
            self.saveToFile()
            self.performSegue(withIdentifier: "unwindToList", sender: nil)
        }))
        deletePlaceMessage.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: {( action: UIAlertAction!) in return}))
        self.present(deletePlaceMessage, animated: true, completion: nil)
    }
    
    @objc func hideKeyboardAction(){
        name_txt.endEditing(true)
        description_txt.endEditing(true)
        discount_txt.endEditing(true)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height - 65
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @IBAction func getLocation(_ sender: Any) {
        performSegue(withIdentifier: "GetLocation", sender: place)
    }
    
    // Funció per a obrir i sel.leccionar una foto desde càmara
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Atención!", message: "No tiene permiso para usar la cámara", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Funció per a obrir la galeria de fotos
    func openGallary() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage{
            place_img.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    // Guardar l'array de places a l'arxiu JSON
    func saveToFile(){
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
    }
}
