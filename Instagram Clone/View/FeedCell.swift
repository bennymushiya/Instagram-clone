//
//  FeedCell.swift
//  Instagram Clone
//
//  Created by benny mushiya on 12/02/2021.
//

import UIKit
import SDWebImage



class FeedCell: UICollectionViewCell {
    
    //MARK: - PROPERTIES
    
    var viewModel: PostViewModel? {
        didSet{configureViewModel()}
        
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    // in order to set the target to this button we need to make a lazy var or else adding the target wont work. we will have to add it to the initialiser instead.
    private lazy var userNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleDidTapUserName), for: .touchUpInside)
        
        return button
    }()
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 13)
        
        return label
    }()
    
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private let postTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "2 days ago"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        
        return label
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
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        profileImageView.anchor(top: topAnchor, left: leftAnchor , paddingTop: 12, paddingLeft: 12)
        
        addSubview(userNameButton)
        userNameButton.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        addSubview(postImageView)
        postImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8)
        
        /// adds the image to against all four corners with the profile image on top
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        configureActionButtons()
        addSubview(likesLabel)
        likesLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, paddingTop:  -4, paddingLeft: 8)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likesLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
    }
    
    
    func configureActionButtons() {
        
        let stack = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.anchor(top: postImageView.bottomAnchor, width: 120, height: 50)
        
    }
    
    
    
    //MARK: - ACTION
    
    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        captionLabel.text = viewModels.caption
        postImageView.sd_setImage(with: viewModels.imageUrl)
        profileImageView.sd_setImage(with: viewModels.profileImage)
        userNameButton.setTitle(viewModels.userName, for: .normal)
        likesLabel.text = viewModels.likesLabelText
        
    }
    
    @objc func handleDidTapUserName() {
        
        
        print("did tap button")
        
        
    }
    
}
