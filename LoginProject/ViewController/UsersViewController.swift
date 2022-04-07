//
//  UsersViewController.swift
//  LoginProject
//
//  Created by Gevorg Tarkhanyan on 12.03.22.
//

import UIKit
import FirebaseDatabase
import FBSDKLoginKit
import FirebaseAuth

class UsersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var fromLoginPage = false
    var users = [User]()
    var followerIds = [String]()
    
    var ref: DatabaseReference = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    private func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        loadUsers { [weak self] succes in
            if let self = self, succes {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func presentLoginVC() {
        guard let loginVC = storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController else { return }
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func logOutButton(_ sender: UIButton) {
        logOut { [weak self] (succes) in
            guard let self = self else { return }
            if succes {
                if self.fromLoginPage {
                    self.dismiss(animated: false, completion: nil)
                } else {
                    self.presentLoginVC()
                }
            } else {
                self.showAlert(title: "Error", message: "Can't Log Out")
            }
        }
    }
    
}
extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK:  Table view data source -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as? UserTableViewCell else { return UITableViewCell() }
        
        let user = users[indexPath.row]
        cell.setup(user: user)
        
        return cell
    }
    
    // MARK:  Table view delegate -
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let user = users[indexPath.row]
        let id = user.id
        let isFollow = followerIds.contains(id)
        let title = isFollow ? "Unfollow" : "Follow"
        let follow = UIContextualAction(style: .normal, title: title) { [weak self] (_, _, completionHandler) in
            if let self = self {
                self.followTapped(with: indexPath.row)
                completionHandler(true)
            }
        }
        
        follow.backgroundColor = isFollow ? .darkGray : .systemGray
        
        return UISwipeActionsConfiguration(actions: [follow])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
}

//MARK: - Page logic
extension UsersViewController {
    
    func loadUsers(completion: @escaping (Bool) -> Void) {
        guard let userId = UserDefaults.standard.object(forKey: "userId") as? String else { return }
        
        downloadUserFromFirebase(ref: ref) { (users) in
            for user in users {
                if user.id == userId {
                    self.followerIds = user.followerIds
                } else {
                    
                    self.users.append(user)
                    completion(true)
                }
            }
        }
    }
    
    func logOut(completion: @escaping (Bool) -> Void) {
        let loginManager = LoginManager()
        loginManager.logOut()
        UserDefaults.standard.set(false, forKey: "logedIn")
        
        do {
            try FirebaseAuth.Auth.auth().signOut()
            completion(true)
        }
        catch {
            completion(false)
        }
    }
    
    func followTapped(with index: Int) {
        let id = users[index].id
        
        if followerIds.contains(id) {
            guard let first = followerIds.firstIndex(of: id) else {
                return
            }
            followerIds.remove(at: first)
        } else {
            followerIds.append(id)
        }
        changeFirebaseFollow()
        
    }
    
    func changeFirebaseFollow (){
        guard let userId = UserDefaults.standard.object(forKey: "userId") as? String else { return }
        ref.child("users").child(userId).child("followerIds").setValue(followerIds)
    }
    
    func downloadUserFromFirebase(ref: DatabaseReference, completion: @escaping ([User]) -> Void) {
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let data = snapshot.value as? [String: Any] else { return }
            var dbUsers = [User]()
            for (key, value) in data {
                print(key)
                guard let user = User(dictionary: value as! [String: Any]) else { return }
                dbUsers.append(user)
            }
            completion(dbUsers)
        })
    }
}



