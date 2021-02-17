//
//  ProfileController.swift
//  Instagram Clone
//
//  Created by benny mushiya on 12/02/2021.
//

import UIKit

private let cellIdenifier = "profileCell"
private let headerIdenifier = "profileHeader"

class ProfileController: UICollectionViewController {
    
    //MARK: - PROPERTIES
    
    // API calls take some time, but viewControllers get loaded instantly, thus we call reload data to give the API call time to fetch the user and set the properties of the user.
    private var user: User
    
    //MARK: - LIFECYCLE
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        checkIfUserIsFollowed()
        fetchUserStats()
        
    }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        collectionView.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdenifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdenifier)
        navigationItem.title = user.userName
        
    }
    
    //MARK: - API
   
    /// checks if the user is followed, and the isFollowed property represents the answer of if the snapshot exists or not, thus if the user is followed or not
    func checkIfUserIsFollowed() {
        
        // so if isFollowed is true, we assign it to user isFollow, then it will return true. and we can update the UI Accordingly.
        UserService.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
        
    }
    
    func fetchUserStats() {
        
        UserService.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
            
            print("stats is '\(stats)")
        }
        
    }
    
    //MARK: - ACTION
    
    
    
}


//MARK: - UICollectionViewDataSource

extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 9
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdenifier, for: indexPath) as! ProfileCell
        
        return cell
    }
    
    // we use this to create the profile header.
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdenifier, for: indexPath) as! ProfileHeader
            
     
        header.delegate = self
        header.viewModel = ProfileHeaderViewModel(user: user)
        
            
        return header
        
    }
    
}

//MARK: - UICollectionViewDelegate

extension ProfileController {
    
    
    
}


//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 2) / 3
        
        return CGSize(width: width, height: width)
    }
    
    // width and height for the header section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 240)
    }
    
}


//MARK: - ProfileHeaderDelegate


extension ProfileController: ProfileHeaderDelegate {
    
    func header(_ profileHeader: ProfileHeader, didTapActionButtonForUser user: User) {
       
        if user.isCurrentUser {
            
            print("show edit here")
        }else if user.isFollowed {
            
            UserService.unFollowUser(uid: user.uid) { error in
                self.user.isFollowed = false
                self.collectionView.reloadData()
            }
            
        }else {
            
            // after we follow the user we change our isFollowed object to true and we reload our data to re call all of our properties again, thus updating our UI, based on the dataBase info
            UserService.followUser(uid: user.uid) { error in
                self.user.isFollowed = true
                self.collectionView.reloadData()
            }
            
        }
        
    }
    
    
    
    
    
}
