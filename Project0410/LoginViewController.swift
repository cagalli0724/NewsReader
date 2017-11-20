//
//  LoginViewController.swift
//  Project0410
//
//  Created by yipei zhu on 4/25/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth



class LoginViewController: UIViewController, UITextFieldDelegate{
    /**
     Sent to the delegate when the button was used to logout.
     - Parameter loginButton: The button that was clicked.
     */
  

    //login buttom
    @IBOutlet var LoginBtn: UIButton!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var pwField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailField.text = ""
        pwField.text = ""
        pwField.delegate = self
        emailField.delegate = self
        
        
        
    }
    
    
    override func viewDidLoad()
    {
        //
        LoginBtn.layer.cornerRadius=4.0
        LoginBtn.layer.masksToBounds=true
        
        emailField.delegate = self
        pwField.delegate = self
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    @IBAction func LoginAction(button: UIButton){
        guard emailField.text != "", pwField.text != "" else{
            let alert = UIAlertController(title: "No Data", message: "Please input email or passwords!", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: pwField.text!, completion: { (user, error) in
            if error != nil{
                print("LoginIN:\(error?.localizedDescription)")
                let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "OK", style: .destructive, handler: nil)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
                return
            }
            MyTabBarController.emailName = self.emailField.text
            MyTabBarController.ifLogin = true
            let storyboard = UIStoryboard(name:"Main",bundle:nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainView") as! MyTabBarController
            self.present(vc, animated: true, completion: nil)
            //self.performSegue(withIdentifier: "goMain", sender: self)
        })
    }
    
    @IBAction func userTappedBackground(gestureRecognizer: UITapGestureRecognizer) {
        if (emailField.isFirstResponder) {
            emailField.resignFirstResponder()
        }
        else if (pwField.isFirstResponder) {
            pwField.resignFirstResponder()
        }
        view.endEditing(true)
        
        
        
    }

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Segue invoked.")
        
        if segue.identifier == "goMain" {
            print("go to Main page")
            //let destinationController = segue.destination as! MyTabBarController
            MyTabBarController.emailName = emailField.text
            MyTabBarController.ifLogin = true
        }
    }




}
