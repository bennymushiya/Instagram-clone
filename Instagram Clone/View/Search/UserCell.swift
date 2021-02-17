//
//  UserCell.swift
//  Instagram Clone
//
//  Created by benny mushiya on 14/02/2021.
//

import UIKit
import SDWebImage


class UserCell: UITableViewCell {
    
    //MARK: - PROPERTIES
    
    var viewModel: UserCellViewModel? {
        didSet {configureViewModel()}
    }
    
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 10
        iv.image = #imageLiteral(resourceName: "venom-7")
        
        return iv
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "sasuke"
        
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "rinnegan eyses"
        label.textColor = .lightGray
        
        return label
    }()
    
    //MARK: - LIFECYCLE

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - HELPERS

    func configureUI() {
        
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 60, width: 60)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [userNameLabel, nameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
    }
    
    
    //MARK: - ACTION

    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        nameLabel.text = viewModels.fullName
        userNameLabel.text = viewModels.userName
        profileImageView.sd_setImage(with: viewModels.profileImage)
        
    }
    
    
}
