//
//  CreateAccountController.swift
//  Project0410
//
//  Created by yipei zhu on 4/26/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import Foundation


import Firebase
import FirebaseAuth



class CreateAccountController: UIViewController, UITextFieldDelegate{
    /**
     Sent to the delegate when the button was used to logout.
     - Parameter loginButton: The button that was clicked.
     */
    
    
    //login buttom
    @IBOutlet var createAccountBtn: UIButton!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var confField: UITextField!
    
    //var LgViewController:LoginViewController?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailField.text = ""
        pwField.text = ""
        confField.text = ""
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func viewDidLoad()
    {
        //
        createAccountBtn.layer.cornerRadius=4.0
        createAccountBtn.layer.masksToBounds=true
        pwField.delegate = self
        confField.delegate = self
        emailField.delegate = self
        
    }
    
    @IBAction func userTappedBackground(gestureRecognizer: UITapGestureRecognizer) {
        if (emailField.isFirstResponder) {
            emailField.resignFirstResponder()
        }
        else if (pwField.isFirstResponder) {
            pwField.resignFirstResponder()
        }else if (confField.isFirstResponder) {
            confField.resignFirstResponder()
        }

        
        
        
        
        view.endEditing(true)
        
        
        
    }

    
        
    @IBAction func CreateAccount(button: UIButton){
        guard emailField.text != "", pwField.text != "", confField.text != "" else{
            let alert = UIAlertController(title: "No Data", message: "Please input email or passwords!", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            return
        }
        if pwField.text == confField.text{
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: pwField.text!, completion: { (user, error) in
                if error != nil{
                    print(error!)
                    let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .destructive, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion:nil)
                    return
                }
                
                let alert = UIAlertController(title: "Create an Account Successfully", message: "Please input email and passwords in Login page!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .destructive, handler: {(action: UIAlertAction)->Void in
                    self.performSegue(withIdentifier: "login", sender: self)
                    
                    
                })

                alert.addAction(ok)
                self.present(alert, animated: true, completion:nil)
                
                
            })
            
        }else{
            let alert = UIAlertController(title: "Password does not match", message: "Please put correct password on both fields", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "cancel", style: .destructive, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    
    
    
}
