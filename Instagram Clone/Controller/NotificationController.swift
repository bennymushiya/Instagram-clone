//
//  NotificationController.swift
//  Instagram Clone
//
//  Created by benny mushiya on 12/02/2021.
//

import UIKit

private let reuseIdentifier = "notifcation cell"


class NotificationController: UITableViewController {
    
    //MARK: - PROPERTIES
    
    private var notifications = [Notification]() {
        didSet{tableView.reloadData()}
        
    }
    
    
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        fetchNotifications()
    }
    
    //MARK: - HELPERS
    
    func configureTableView() {
        
        view.backgroundColor = .white
        navigationItem.title = "Notification"
        tableView.rowHeight = 80
        //tableView.separatorStyle = .none
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        
    }
    
    //MARK: - API
    
    func fetchNotifications() {
        
        NotificationsServices.fetchNotification { notification in
            self.notifications = notification
            self.checkIfUserIsFollowed()
            
        }
    }
    
    func checkIfUserIsFollowed() {
        
        notifications.forEach { notification in
            
            guard notification.type == .follow else {return}
            
            UserService.checkIfUserIsFollowed(uid: notification.uid) { isFollowed in
                if let index = self.notifications.firstIndex(where: {$0.id == notification.id}) {
                    
                    self.notifications[index].userIsFollowed = isFollowed
                }
                
            }
        }
    }

    
    //MARK: - ACTION
    
    
    
}


//MARK: - UITableViewDataSource


extension NotificationController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        cell.delegate = self
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NotificationController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("taoooed")
        
    }
    
    
}

//MARK: - UITableViewDelegate

extension NotificationController: NotificationCellDelegate {
    
    func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
        
        print("wants to follow ")
    }
    
    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String) {
        print("wants to unfollow ")

    }
    
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String) {

        PostsService.fetchPost(withPostId: postId) { post in
            let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.post = post
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    
    
    
}
