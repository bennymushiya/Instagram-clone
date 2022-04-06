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
    
    // everytime something inside the post array gets modified, it gonna reload the collection view data for us.
    private var posts = [Posts]() {
        didSet{collectionView.reloadData() }
        
    }
    
     var post: Posts?
     let refresher = UIRefreshControl()
    
    
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
        
        // if post is nill then we show the logout button else we show back button.
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "log out", style: .plain, target:self, action:  #selector(handleLogout))
        }
        
        refresher.addTarget(self, action: #selector(hanldeRefresh), for: .valueChanged)
        
    }
    
    
    /// we remove all posts when we refresh, then we fetch all the posts again
   @objc func hanldeRefresh() {
    
     posts.removeAll()
     fetchPosts()
        
  }
    
    //MARK: - API

    func fetchUser() {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        UserService.fetchUser(withUser: currentUser) { user in
            self.user = user

            print("the name of the user is \(user.name)")
            print("the user name is \(user.userName)")
        }
        
    }
    
    /// its only gonna execute the API call if post is equal to nill.
    func fetchPosts() {
        
        // the point of a guard statement is to check a condition, if its met then it goes on to complete the required action, if not met then it return out of the function
        guard post == nil else {return}
        
        PostsService.fetchPosts { post in
            self.posts = post
            self.collectionView.refreshControl?.endRefreshing()
            self.checkIfUserLikedPost()
        }
    }
    
    /// we call this after the fetch post has been fetched to ensure the post array will be populated. thus we loop through this post array and check to see if each post has been liked by the user. if the post has been liked it will be true, if not it will be false.
    func checkIfUserLikedPost() {
        self.posts.forEach { post in
            PostsService.checkIfUserLikedPost(post: post) { didLike in
               
                // we go through posts and we ask it to loop through all the posts again and return to us the posts that contains the same postIDs as the liked postIDs
                if let index = self.posts.firstIndex(where: {$0.postId == post.postId}) {
                    
                    // for each post that meets the above predicate, we set didLike to it. because we get back true or false from the API calls.
                    self.posts[index].didLike = didLike
                }
                
            }
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
        
        // if post is nil is true, then we return the array of posts count, if false we return 1
        return post == nil ? posts.count : 1

    }
    
    /// we define the cell here and we reuse the same cell over and over when old cells gets scrolled off screen, doing it like this helps us save memory.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        
        // we find our whether our post property contains a value, because its optional. if it does contain a value we make that value available through this let constant.
        if let post = post {
            
            // if it does contain a value we initialise it our cell with that single value.
            cell.viewModel = PostViewModel(post: post)
            
        }else {
            
            // else we initialise the array of posts.
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
            
        }
        
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

//MARK: - FeedCellDelegate

extension FeedController: FeedCellDelegate {
    
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String) {
        
        UserService.fetchUser(withUser: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    
    func cell(_ cell: FeedCell, wantsToShowCommentsFor Post: Posts) {
        
        let controller = CommentsController(posts: Post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeedCell, didLike post: Posts) {
        
        // gains access to the tabBar and all its properties.
        guard let tab = self.tabBarController as? MainTabBarController else {return}
        guard let user = tab.user else {return}
        
        cell.viewModel?.posts.didLike.toggle()
        
        if post.didLike {
            
            PostsService.unlikePost(post: post) { error in
                if let error = error {
                    print("failed to delete \(error.localizedDescription)")
                    return
                }
                
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.posts.likes = post.likes - 1
            }
            
        }else {
            
            PostsService.likePost(post: post) { error in
                if let error = error {
                    print("failed to like post \(error.localizedDescription)")
                    return
                }
                
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.posts.likes = post.likes + 1
                
                NotificationsServices.uploadNotification(toUid: post.ownerUid, fromUser: user, type: .like, post: post)
            }
        }

        
    }
    
    
    
    
}
    
    

