//
//  NotificationCell.swift
//  Instagram Clone
//
//  Created by benny mushiya on 18/02/2021.
//

import UIKit
import SDWebImage

protocol NotificationCellDelegate: class {
    
    func cell(_ cell: NotificationCell, wantsToFollow uid: String)
    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String)
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String)


}


class NotificationCell: UITableViewCell {
    
    //MARK: - PROPERTIES
    
    
    weak var delegate: NotificationCellDelegate?
    
    var viewModel: NotificationViewModel? {
        didSet{configureViewModel()}
        
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
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        addGestureRecognizer(tap)
        
        return iv
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 3
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        
        return button
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
        
        backgroundColor = .clear
        
        // by putting contentView we put it on top of didselect cell, so we can tapp it
        contentView.addSubview(profileImageView)
        profileImageView.setDimensions(height: 60, width: 60)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        contentView.addSubview(infoLabel)
        infoLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
       // infoLabel.anchor(right: followButton.leftAnchor, paddingLeft: 4)
        
        contentView.addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right: rightAnchor, paddingRight: 12, width: 88, height: 32)
        
        contentView.addSubview(postImageView)
        postImageView.centerY(inView: self)
        postImageView.anchor(right: rightAnchor, paddingRight: 12, width: 40, height: 40)
        
        
        followButton.isHidden = true
        
    }
    
    
    //MARK: - ACTION
    
    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        profileImageView.sd_setImage(with: viewModels.profileImageURL)
        postImageView.sd_setImage(with: viewModels.postImageUrl)
        
        infoLabel.attributedText = viewModels.notificationMessage
        
        followButton.isHidden = !viewModels.shouldHidePostImage
        postImageView.isHidden = viewModels.shouldHidePostImage
        followButton.setTitle(viewModels.followButtonText, for: .normal)
        followButton.backgroundColor = viewModels.followButtonBackgroundColor
        followButton.setTitleColor(viewModels.followButtonTextColor, for: .normal)
        
    }
    
    
    @objc func handlePostTapped() {
        
        guard let postId = viewModel?.notification.postId else {return}

        delegate?.cell(self, wantsToViewPost: postId)
    }
    
    
    @objc func handleFollowTapped() {
    
        guard let viewModels = viewModel else {return}
        
       
    }
    
    
    
}

