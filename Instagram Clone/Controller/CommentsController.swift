//
//  CommentsController.swift
//  Instagram Clone
//
//  Created by benny mushiya on 17/02/2021.
//

import UIKit

private let reuseIdentifier = "cell"

class CommentsController: UICollectionViewController {
    
    //MARK: - PROPERTIES
    
    private let posts: Posts
    
    private var comments = [Comments]()
    
    // the reason we make it a lazy var is because we are accessing cgrect properites outside an initiailiser.
    private lazy var commentInputView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccessoryView(frame: frame)
        cv.delegate = self
        return cv
    }()
    
    //MARK: - LIFECYCLE
    
    init(posts: Posts) {
        self.posts = posts
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchComments()
    }
    
    /// declares the commentInputView created above, as this Views input accessory view.
    override var inputAccessoryView: UIView? {
        
        get { return commentInputView }
    }
    
    /// gives the input view the functionality of hiding and showing the keyboard.
    override var canBecomeFirstResponder: Bool {
        
        return true
    }
    
    // gets called everytime the view is about to appear on screen, unlike viewController that only gets called once.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    // gets called everytime the view is about to disapear.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - HELPERS

    func configureUI() {
        
        collectionView.backgroundColor = .white
        navigationItem.title = "Comments"
        collectionView.register(CommentsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // makes the collectionView always movable even of we have 1 comments. thus we can dismiss the keyboard upon interaction.
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
        
    }
    
    
    //MARK: - API
    
    func fetchComments() {
        
        CommentService.fetchComments(forPost: posts.postId) { comments in
            self.comments = comments
            self.collectionView.reloadData()
        }
        
    }

}


//MARK: - UICollectionViewDataSource


extension CommentsController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentsCell
        
        cell.viewModel = CommentsViewModel(comments: comments[indexPath.row])
        
        return cell
    }
    
}


//MARK: - UICollectionViewDelgate

extension CommentsController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let uid = comments[indexPath.row].uid
        
        UserService.fetchUser(withUser: uid) { user in
            
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CommentsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewModel = CommentsViewModel(comments: comments[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height + 32
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    
    
}

//MARK: - CommentInputAccessoryViewDelegate

extension CommentsController: CommentInputAccessoryViewDelegate {
    
    func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String) {
        
        inputView.clearCommentTextView()
        
        // gains access to the tabBar and all its properties.
        guard let tab = self.tabBarController as? MainTabBarController else {return}
        guard let currentUser = tab.user else {return}
        
        showLoader(true)
        
        CommentService.uploadComment(comment: comment, postID: posts.postId, user: currentUser) { error in
            
            self.showLoader(false)
            if let error = error {
                print("failed to upload \(error.localizedDescription)")
                return
            }
            
            print("successfully loaded the comment")
            
            NotificationsServices.uploadNotification(toUid: self.posts.ownerUid, fromUser: currentUser, type: .comment, post: self.posts)
        }
        
    }
    
    
    
    
    
}

