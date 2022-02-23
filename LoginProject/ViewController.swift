//
//  ViewController.swift
//  LoginProject
//
//  Created by Gevorg Tarkhanyan on 21.02.22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
            
            let storybard = UIStoryboard(name: "Main", bundle: nil)
            let vc = self.storyboard?.instantiateViewController(identifier: "LoginViewController")
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: false)
            
        }
        
            }
        }
            
        
    

    


