//
//  AuthController.swift
//  MyPlaces
//
//  Created by Toni Casas on 11/12/18.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit
import FirebaseAuth

class AuthController: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repetirPasswordTxt: UITextField!
    @IBOutlet weak var registratBt: UIButton!
    @IBOutlet weak var avisoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Afegim un avisador pq quan piquem fora els textfield amagi el teclat
        let hideKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardAction))
        view.addGestureRecognizer(hideKeyboard)
        
        // Moure la vista quan surt el teclat
        NotificationCenter.default.addObserver(self, selector: #selector(addModifyContoller.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addModifyContoller.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func registrarBt(_ sender: Any) {
        if(registratBt.titleLabel?.text == "Cancelar"){
            repetirPasswordTxt.isHidden = true
            repetirPasswordTxt.text = ""
            registratBt.setTitle("¿No tienes cuenta? Regístrate", for: .normal)
        }else{
            repetirPasswordTxt.isHidden = false
            registratBt.setTitle("Cancelar", for: .normal)
        }
    }
    
    @IBAction func enterBt(_ sender: Any) {
        let email = emailTxt.text
        let password = passwordTxt.text
        let repPassword = repetirPasswordTxt.text
        
        if(repetirPasswordTxt.isHidden == false) {
            if(email != "" && password != "" && repPassword==password){
                Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
                    guard let _ = authResult?.user.email, error == nil else {
                        self.avisoLbl.text = "Error creando usuario"
                        return
                    }
                    self.emailTxt.text = ""
                    self.passwordTxt.text = ""
                    self.repetirPasswordTxt.text = ""
                    self.repetirPasswordTxt.isHidden = true
                    self.avisoLbl.text = "Usuario creado correctamente"
                    self.performSegue(withIdentifier: "enterApp", sender: nil)
                }
            }else{
                self.avisoLbl.text = "Debe introducir todos los datos"
            }
        }else{
            if(email != "" && password != ""){
                Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                    if (error != nil) {
                        self.avisoLbl.text = "Error de usuario / password"
                        return
                    }
                    self.emailTxt.text = ""
                    self.passwordTxt.text = ""
                    self.repetirPasswordTxt.text = ""
                    self.repetirPasswordTxt.isHidden = true
                    self.avisoLbl.text = ""
                    self.performSegue(withIdentifier: "enterApp", sender: nil)
                }
            }else{
                self.avisoLbl.text = "Debe introducir todos los datos"
            }
        }
    }
    
    @objc func hideKeyboardAction(){
        emailTxt.endEditing(true)
        passwordTxt.endEditing(true)
        repetirPasswordTxt.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height - 55
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @IBAction func unwindToLogin(_ sender: UIStoryboardSegue){}
}
