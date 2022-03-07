//
//  FacebookLoginViewController.swift
//  LoginProject
//
//  Created by Gevorg Tarkhanyan on 07.03.22.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookCore
import FacebookLogin
import FBSDKLoginKit

class FacebookLoginViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = UIButton(type: .custom)
                
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)

        view.addSubview(loginButton)
        
        _ = FBLoginButton.self
        
        
        
        NotificationCenter.default.addObserver(
            forName: .AccessTokenDidChange,
            object: nil,
            queue: .main
        ) { notification in
            if notification.userInfo?[AccessTokenDidChangeUserIDKey] != nil {
                // Handle user change
                
                Profile.loadCurrentProfile { profile, error in
                    if let firstName = profile?.firstName {
                        print("Hello, \(firstName)")
                        
                        Profile.enableUpdatesOnAccessTokenChange(true)
                        NotificationCenter.default.addObserver(
                            forName: .ProfileDidChange,
                            object: nil,
                            queue: .main
                        ) { notification in
                            if let currentProfile = Profile.current {
                                // Update for new user profile
                                
                                let profilePictureView = FBProfilePictureView()
                                profilePictureView.frame = CGRect(x: 0, y: 0, width: 137, height: 100)
                                profilePictureView.profileID = AccessToken.current!.userID
                                self.view.addSubview(profilePictureView)
                                
                                let loginButton = FBLoginButton()

                                
                                
                                    
                            }
                        }
                    }
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    @objc func loginButtonClicked() {
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["public_profile"], from: self) { result, error in
                if let error = error {
                    print("Encountered Erorr: \(error)")
                } else if let result = result, result.isCancelled {
                    print("Cancelled")
                } else {
                    print("Logged In")
                }
            }
        }
    
    }
    
    
    


