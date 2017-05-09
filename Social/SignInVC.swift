//
//  SignInVC.swift
//  Social
//
//  Created by Malkiel Shaul on 2.5.2017.
//  Copyright © 2017 Malkiel Shaul. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        handleTextField()
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegue(withIdentifier: "signInToTabBarVC", sender: nil)
        }
    }
    
    func handleTextField() {
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChanged), for: .editingChanged)
    }

    func textFieldDidChanged() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signInBtn.setTitleColor(UIColor.lightText, for: .normal)
            signInBtn.isEnabled = false
            return
        }
        signInBtn.setTitleColor(UIColor.white, for: .normal)
        signInBtn.isEnabled = true
    }
    
    
    @IBAction func signInButton_TouchUpInside(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            
            if error != nil {
                print("Malki: \(error!.localizedDescription)")
                return
            }
            
            self.performSegue(withIdentifier: "signInToTabBarVC", sender: nil)
            
        })
        
    }


}
