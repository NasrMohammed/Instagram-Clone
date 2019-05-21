//
//  ViewController.swift
//  Instagram
//
//  Created by Nasr Mohammed on 5/2/19.
//  Copyright © 2019 Nasr Mohammed. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupModeActive = true;
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signupOrLogin(_ sender: Any) {
        if email.text == "" || password.text == "" {
           displayAlert(title: "Could not sign you up", message: "Please enter an email and password")
            
        } else {
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            activityIndicator.center = self.view.center
            
            activityIndicator.hidesWhenStopped = true
            
            activityIndicator.style = UIActivityIndicatorView.Style.gray
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if (signupModeActive) {
            print("Signing up...")
                let user = PFUser()
                user.username = email.text
                user.password = password.text
                user.email = email.text
                
                user.signUpInBackground { (success, error) in
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if let error = error {
                        // let errorString = error.userInfo["error"] as? NSString
                        // Show the errorString somewhere and let the user try again.
                        self.displayAlert(title: "Could not sign you up", message: error.localizedDescription)
                        print(error)
                    } else {
                        print("signed up!")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                }
            } else {
                PFUser.logInWithUsername(inBackground: email.text!, password: password.text!) { (user, error) in
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if user != nil {
                        print("Login Successful")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)

                    } else {
                        var errorText = "Uknown error: please try again"
                        
                        if let error = error {
                            errorText = error.localizedDescription
                        }
                        self.displayAlert(title: "Could not sign you up", message: errorText)
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var signupOrLoginButton: UIButton!
    
    @IBAction func switchLoginMode(_ sender: Any) {
        if (signupModeActive) {
            signupModeActive = false
            
            signupOrLoginButton.setTitle("Log in", for: [])
            switchLoginModeButton.setTitle("Sign Up", for: [])
        } else {
            signupModeActive = true
            signupOrLoginButton.setTitle("Sign up", for: [])
            switchLoginModeButton.setTitle("Log In", for: [])
        }
    }
    @IBOutlet weak var switchLoginModeButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
        
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
