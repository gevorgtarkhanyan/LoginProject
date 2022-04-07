//
//  User.swift
//  LoginProject
//
//  Created by Gevorg Tarkhanyan on 11.03.22.
//

import Foundation
class User {
    
    let id: String
    let name: String
    let email: String
    let imageUrl: String
    var followerIds: [String]

    init?(data: [String: Any]) {
        guard let id = data["id"] as? String,
              let name = data["name"] as? String,
              let email = data["email"] as? String,
              let image = data["picture"] as? [String: Any],
              let imageData = image["data"] as? [String: Any],
              let imageStrUrl = imageData["url"] as? String else { return nil }
        
        self.id = id
        self.name = name
        self.email = email
        self.imageUrl = imageStrUrl
        self.followerIds = []
    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let name = dictionary["name"] as? String,
              let email = dictionary["email"] as? String,
              let imageUrlStr = dictionary["imageUrl"] as? String else { return nil }
        
        var newFollowersId = [String]()

        if let followerIds = dictionary["followerIds"] as? [String] {
            for value in followerIds {
                newFollowersId.append(value)
            }
        }

        self.id = id
        self.name = name
        self.email = email
        self.imageUrl = imageUrlStr
        self.followerIds = newFollowersId
    }

    func toAny() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "email": email,
            "imageUrl": imageUrl,
            "followerIds": followerIds
        ]
    }
}

