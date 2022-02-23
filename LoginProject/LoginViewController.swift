//
//  LoginViewController.swift
//  LoginProject
//
//  Created by Gevorg Tarkhanyan on 21.02.22.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    @IBOutlet weak var ErorrLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkUserInfo()
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        validateFields()
    }
   
    @IBAction func SignUpButton(_ sender: Any) {
        let storybard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard?.instantiateViewController(identifier: "RegistrationViewController")
        vc?.modalPresentationStyle = .overFullScreen
        present(vc!, animated: false)
    }
    func validateFields(){
        if  EmailTextField.text?.isEmpty == true {
            print("No email text")
            return
        }
        if PasswordTextField.text?.isEmpty == true{
            print("No password ")
            return
}
login()
 
    }
    func login() {
        Auth.auth().signIn(withEmail: EmailTextField.text!, password: PasswordTextField.text!) {[weak self] authResult, err in
            guard let strongSelf = self else {return}
            if let err = err {
                print(err.localizedDescription)
            }
            self!.checkUserInfo()
        }
        
    }
        func checkUserInfo() {
            if Auth.auth().currentUser  != nil {
                print(Auth.auth().currentUser?.uid)
                let storybard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard?.instantiateViewController(identifier: "SuccesViewController")
                vc?.modalPresentationStyle = .overFullScreen
                present(vc!, animated: false)
            }
        }
}

      
