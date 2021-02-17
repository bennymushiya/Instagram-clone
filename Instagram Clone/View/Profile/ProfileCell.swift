//
//  ProfileCell.swift
//  Instagram Clone
//
//  Created by benny mushiya on 13/02/2021.
//

import UIKit



class ProfileCell: UICollectionViewCell {
    
    //MARK: - PROPERTIES
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "venom-7")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
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
        
        backgroundColor = .red
        addSubview(postImageView)
        postImageView.fillSuperview()
        
        
    }
    
  
    
    
    //MARK: - ACTION
    
    
    
}

