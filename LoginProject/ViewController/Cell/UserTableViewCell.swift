//
//  UserTableViewCell.swift
//  LoginProject
//
//  Created by Gevorg Tarkhanyan on 12.03.22.
//

import UIKit
import SDWebImage

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            contentView.backgroundColor = .brown
        } else {
            contentView.backgroundColor = .clear
        }
    }
    
    func setup(user: User) {
        userNameLabel.text = user.name
        userImageView.sd_setImage(with: URL(string: user.imageUrl ), completed: nil)
    }
}
