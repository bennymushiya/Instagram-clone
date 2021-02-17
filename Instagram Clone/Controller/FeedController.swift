//
//  FeedController.swift
//  Instagram Clone
//
//  Created by benny mushiya on 12/02/2021.
//

import UIKit
import Firebase

private let reuseIdentifier = "cell"

class FeedController: UICollectionViewController {
    
    //MARK: - PROPERTIES
    
    private var user: User?
    
    private var posts = [Posts]()
    
    
    //MARK: - LIFECYCLE
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUser()
        fetchPosts()
        
    }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "log out", style: .plain, target:self, action:  #selector(handleLogout))
        
        // creates an instance of refreshControl
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
        
    }
    
    
    /// we remove all posts when we refresh, then we fetch all the posts again
   @objc func handleRefresh() {
    posts.removeAll()
    fetchPosts()
        
    }
    
    //MARK: - API

    func fetchUser() {
        
        UserService.fetchUser { user in
            self.user = user
            
            print("the name of the user is \(user.name)")
            print("the user name is \(user.userName)")
        }
        
    }
    
    func  fetchPosts() {
        
        PostsService.fetchPosts { post in
            self.posts = post
            
            print("did fetch posts")
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
        
    }
    
    //MARK: - ACTION
    
    @objc func handleLogout() {
        do {
            
            try Auth.auth().signOut()
            
            presentLogInController()
            
        }catch {
            
            print("failed to sign out ")
        }
        
    }
    
    
    func presentLogInController() {
        
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            // we make the delegate property equal to our maintabBarController.
            controller.delegate = self.tabBarController as? MainTabBarController
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
}

//MARK: - DataSource

extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    /// we define the cell here and we reuse the same cell over and over when old cells gets scrolled off screen, doing it like this helps us save memory.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        
        // 8 pixels is for the spacing between profile image and post image, 40 pixels is the size of the profileImage and 8 pixels again for the spacing down below.
        var height = width + 8 + 40 + 8
        
        height += 50
        height += 60
        
        return CGSize(width: width, height: height)
    }
    
}
    
    
    

