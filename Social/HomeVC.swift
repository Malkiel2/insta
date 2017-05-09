//
//  HomeVC.swift
//  Social
//
//  Created by Malkiel Shaul on 4.5.2017.
//  Copyright © 2017 Malkiel Shaul. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func logout_TouchUpInside(_ sender: Any) {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let SignInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC")
        self.present(SignInVC, animated: true, completion: nil)
    }

}
