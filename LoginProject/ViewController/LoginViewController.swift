//
//  LoginViewController.swift
//  LoginProject
//
//  Created by Gevorg Tarkhanyan on 11.03.22.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var facebookButton: FBLoginButton!
    
    var ref: DatabaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    private func setup() {
        let loginButton = FBLoginButton()
        loginButton.permissions = ["public_profile", "email"]
        loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)
        
    }
    
    private func presentUsersVC() {
        guard let VC = self.storyboard?.instantiateViewController(identifier: "UsersViewController") as? UsersViewController else { return }
        
        VC.fromLoginPage = true
        let navVC = UINavigationController(rootViewController: VC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: false, completion: nil)
    }
    
}

extension LoginViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token else { return }
        
        getFacebookData(token: token) {
            DispatchQueue.main.async {
                self.presentUsersVC()
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
}
extension LoginViewController {
    
    func getFacebookData(token: AccessToken, completion: @escaping (() -> Void)) {
        let token = token.tokenString
        
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name, picture"], tokenString: token, version: nil, httpMethod: .get)
        request.start { (_, result, _) in
            
            guard let data = result as? [String: Any],
                  let FBUser = User(data: data) else { return }
            
            self.moveFirebase(FBUser: FBUser)
            
            UserDefaults.standard.set(true, forKey: "logedIn")
            UserDefaults.standard.set(FBUser.id, forKey: "userId")
            
            self.logInFirebase(with: token)
            completion()
        }
    }
    
    private func logInFirebase(with token: String) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: nil)
    }
    
    private func moveFirebase(FBUser: User) {
        downloadUserFromFirebase(ref: ref) { [weak self] (dbUsers) in
            guard let self = self else { return }
            for user in dbUsers {
                FBUser.followerIds = user.id == FBUser.id ? user.followerIds : []
            }
            
            self.ref.child("users").child("\(FBUser.id)").setValue(FBUser.toAny())
        }
    }
    func downloadUserFromFirebase(ref: DatabaseReference, completion: @escaping ([User]) -> Void) {
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            guard let data = snapshot.value as? [String: Any] else { return }
            
            var FirebaseUsers = [User]()
            for (key, value) in data {
                print(key)
                guard let user = User(dictionary: value as! [String: Any]) else { return }
                
                FirebaseUsers.append(user)
            }
            completion(FirebaseUsers)
        })
    }
}
























