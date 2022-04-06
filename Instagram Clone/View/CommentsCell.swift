//
//  CommentsCell.swift
//  Instagram Clone
//
//  Created by benny mushiya on 17/02/2021.
//

import UIKit
import SDWebImage


class CommentsCell: UICollectionViewCell {
    
    //MARK: - PROPERTIES
    
    var viewModel: CommentsViewModel? {
        didSet{configureViewModel()}
    
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        
        let attributedString = NSMutableAttributedString(string: "hinata  ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedString.append(NSAttributedString(string: "best wing spiker ever", attributes: [.font: UIFont.systemFont(ofSize: 15)]))
        
        label.attributedText = attributedString
        
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
    
    //MARK: - ACTION

    func configureUI() {
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 20
        
        addSubview(commentLabel)
        commentLabel.numberOfLines = 0
        commentLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        commentLabel.anchor(right: rightAnchor, paddingRight: 8)
        
        
    }
    
    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        profileImageView.sd_setImage(with: viewModels.profileImage)
        commentLabel.text = viewModels.commentText
    }
    
    
    //MARK: - HELPERS

    
    
}
