//
//  SignUpVC.swift
//  Social
//
//  Created by Malkiel Shaul on 2.5.2017.
//  Copyright © 2017 Malkiel Shaul. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpVC: UIViewController {
    
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var selectedImage: UIImage?
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        handleTextField()
        
    }
    
    func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(self.textFieldDidChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChanged), for: .editingChanged)
    }
    
    func textFieldDidChanged() {
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signUpBtn.setTitleColor(UIColor.lightText, for: .normal)
            signUpBtn.isEnabled = false
            return
        }
        signUpBtn.setTitleColor(UIColor.white, for: .normal)
        signUpBtn.isEnabled = true
    }
    
    func handleSelectProfileImageView() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func dismissOnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func signUpBtn_TouchUpInside(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text {
            
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                
                if error != nil {
                    print("Malki: \(error!.localizedDescription)")
                    return
                }
                
                let uid = user?.uid
                let storageRef = FIRStorage.storage().reference(forURL: "gs://instagram-8903e.appspot.com").child("profile_image").child(uid!)
                if let profileImage = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
                    storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            print("Malki: Faild to upload the profile image")
                            return
                        }
                        
                        let profileImageUrl = metadata?.downloadURL()?.absoluteString
                        
                        self.setUserInformation(email: email, username: username, profileImageUrl: profileImageUrl!, uid: uid!)
                        
                        
                    })
                }
                
            })
        }
        
    }
    
    func setUserInformation(email: String, username: String, profileImageUrl: String, uid: String) {
        
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["username": username, "email": email, "profileImageUrl": profileImageUrl])
        
        self.performSegue(withIdentifier: "signInToTabBarVC", sender: nil)
        
    }
}

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.selectedImage = image
            profileImage.image = image
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
