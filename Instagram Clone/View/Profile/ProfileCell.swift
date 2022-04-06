//
//  ProfileCell.swift
//  Instagram Clone
//
//  Created by benny mushiya on 13/02/2021.
//

import UIKit
import SDWebImage



class ProfileCell: UICollectionViewCell {
    
    //MARK: - PROPERTIES
    
    var viewModel: ProfileCellViewModel? {
        didSet{configureViewModel()}
        
    }
    
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
        
        backgroundColor = .lightGray
        addSubview(postImageView)
        postImageView.fillSuperview()
        
        
    }
    
    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        postImageView.sd_setImage(with: viewModels.profileImage)
        
        print("didset worked")
        
        
    }
  
    
    
    //MARK: - ACTION
    
    
    
}

