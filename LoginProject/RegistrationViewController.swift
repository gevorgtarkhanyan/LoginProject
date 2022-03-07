//
//  RegistrationViewController.swift
//  LoginProject
//
//  Created by Gevorg Tarkhanyan on 21.02.22.
//

import UIKit
import FirebaseAuth
import Firebase

class RegistrationViewController: UIViewController {

    
    
    
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    
    @IBOutlet weak var SignupButton: UIButton!
    
    @IBOutlet weak var Error: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func SignUpButton(_ sender: Any) {
        if EmailTextField.text?.isEmpty == true {
            print("No text in email field")
            return
        }
        if PasswordTextField.text?.isEmpty == true {
            print("No text in password field")
            return
        }
        
        signUP()
    }
    
    @IBAction func AlreadeHaveButton(_ sender: Any) {
        let storybard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard?.instantiateViewController(identifier: "LoginViewController")
        vc?.modalPresentationStyle = .overFullScreen
        present(vc!, animated: false)
    }
    
    func signUP() {
        Auth.auth().createUser(withEmail: EmailTextField.text!, password: PasswordTextField.text!) { (authResult, error) in
            guard let user = authResult?.user, error == nil else {
                print("Error \(error?.localizedDescription)")
                return
            }
            let storybard = UIStoryboard(name: "Main", bundle: nil)
            let vc = self.storyboard?.instantiateViewController(identifier: "SuccesViewController")
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: false)
            
        }
    }

}
