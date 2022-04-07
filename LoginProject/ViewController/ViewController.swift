//
//  ViewController.swift
//  LoginProject
//
//  Created by Gevorg Tarkhanyan on 11.03.22.
//

import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5){
            if UserDefaults.standard.bool(forKey: "logedIn") {
                let vc = self.storyboard?.instantiateViewController(identifier: "UsersViewController")
                vc?.modalPresentationStyle = .overFullScreen
                self.present(vc!, animated: false)
            }else {
                let vc = self.storyboard?.instantiateViewController(identifier: "LoginViewController")
                vc?.modalPresentationStyle = .overFullScreen
                self.present(vc!, animated: false)
            }
            
            
        }
        
    }
}







