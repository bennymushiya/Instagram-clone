//
//  ProfileHeader.swift
//  Instagram Clone
//
//  Created by benny mushiya on 13/02/2021.
//

import UIKit
import SDWebImage

// we introduce this protocol because we dont want to make API calls inside a view Class, we only make API calls inside a viewController. its best programming practice.
protocol ProfileHeaderDelegate: class  {
    
    // profile header wants to follow some user uid.
    func header(_ profileHeader: ProfileHeader, didTapActionButtonForUser user: User)
}


class ProfileHeader: UICollectionReusableView {
    
    //MARK: - PROPERTIES
    
    
    var viewModel: ProfileHeaderViewModel? {
        didSet {configureViewModel()}
        
        
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "venom-7")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "eddie brock"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 13)
        
        return label
    }()
    
    private lazy var editProfileButtton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.layer.cornerRadius = 3
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditButton), for: .touchUpInside)
        return button
    }()
    
    // they need to be lazy vars because were using a function inside it before the view is initialised.
    private lazy var postsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    private let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    private let bookMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    
    //MARK: - LIFECYCLE
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 80, width: 80)
        profileImageView.layer.cornerRadius = 20
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(editProfileButtton)
        editProfileButtton.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 24, paddingRight: 24)
        
        let stack = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        //stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.centerY(inView: profileImageView)
        stack.anchor(left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12, height: 50)
        
        let topDivider = UIView()
        topDivider.backgroundColor = .lightGray
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .lightGray
        
        let buttonStack = UIStackView(arrangedSubviews: [gridButton, listButton, bookMarkButton])
        buttonStack.distribution = .fillEqually
        
        addSubview(buttonStack)
        addSubview(topDivider)
        addSubview(bottomDivider)
        
        buttonStack.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        topDivider.anchor(top: buttonStack.topAnchor, left: leftAnchor, right: rightAnchor, height:  0.5)
        
        bottomDivider.anchor(top: buttonStack.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        
    }
    
    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        profileImageView.sd_setImage(with: viewModels.profileImage)
        nameLabel.text = viewModels.name
        
        editProfileButtton.setTitle(viewModels.followButtonText, for: .normal)
        editProfileButtton.setTitleColor(viewModels.followButtonTextColor, for: .normal)
        editProfileButtton.backgroundColor = viewModels.followButtonBackgroundColor
        
        postsLabel.attributedText = viewModels.numberOfPosts
        followersLabel.attributedText = viewModels.numberOfFollowers
        followingLabel.attributedText = viewModels.numberOfFollowing
        
    }
    
    //MARK: - ACTION
    
    @objc func handleEditButton() {
        
        guard let viewModels = viewModel else {return}
        
        delegate?.header(self, didTapActionButtonForUser: viewModels.user)
        
    }
    
 
    
    
}

