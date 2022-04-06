//
//  MainTabBarController.swift
//  Instagram Clone
//
//  Created by benny mushiya on 12/02/2021.
//

import UIKit
import Firebase
import YPImagePicker

class MainTabBarController: UITabBarController {
    
    //MARK: - PROPERTIES
    
    var user: User? {
        didSet{
            
            guard let user = user else {return}
            configureViewControllers(user: user)
        }
        
    }
    
    //MARK: - LIFECYCLE
    
    /// viewdid load gets called one time and its called when the app is initialised/opened and everything inside is loaded too.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        fetchUser()
        
    }
    
    //MARK: - API
    
    /// checks if the user is logged in. if they are then we do nothing and let them stay in the maintabBar, but if there not we present the loginController through the main thread, because were updating UI, it needs to be done in the main thread.
    func checkIfUserIsLoggedIn() {
        
        if Auth.auth().currentUser == nil {
            
            presentLogInController()
        }
        
    }
    
    func fetchUser() {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        UserService.fetchUser(withUser: currentUser) { user in
            self.user = user
        }
        
    }
    
    //MARK: - HELPERS
      
    func configureViewControllers(user: User) {
        
        view.backgroundColor = .white
        
        // we set the delegate to self so we can access uitabBarControllerDelegate below.
        self.delegate = self
        
        // how to initialise a collectionView inside a tabBar 
        let layout = UICollectionViewFlowLayout()
        
        // embeds the feedController into a navigation controller, then at the bottom, we embed it into a tabBarController/
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController(collectionViewLayout: layout))
        
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController())
        
        let imageSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: ImageSelectorController())
        
        let notifcation = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationController())
        
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: ProfileController(user: user))
        
        
        // viewControllers is only accessbile inside the tabBar because it stores an array of rootViewControllers to display on the tabBar
        viewControllers = [feed, search, imageSelector, notifcation, profile]
        
        tabBar.tintColor = .black
        
    }
    
    /// contains input parameters that needs to be inputed whenever called. we insert the rootViewController, which will display whichever controller is pressed on, the selected and unselected images will show if a user presses a certain tabBar the image pressed becomes selected, if they pressed another one that same image becomes unselected.
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        
        return nav
    
    }
    
    /// if the picker did finishing choosing a photo then we dismiss the picker, whilst dismissing the picker we also get the chosen image. and we pass the chosen image to the selectedImage property inside uploadImage Controller, we also pass the current user the the user property.
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        
        
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: true) {
                
                guard let selectedImage = items.singlePhoto?.image else {return}
                let controller = UploadPostController()
                controller.selectedImage = selectedImage
                controller.delegate = self
                controller.currentUser = self.user
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false, completion: nil)
                
            }
        
        }
        
    }
    
    //MARK: - ACTION
    
    func presentLogInController() {
        
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            controller.delegate = self
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    
}

//MARK: - AuthenicationCompleteDelegate

extension MainTabBarController: AuthenicationCompleteDelegate {

    /// everytime a new user logs in or signs up, we will fetch that current user and populate their information from the tabBar, thus giving all the Controllers inside the tabBar access to that Users properties. also lets us use a dependency injection in the other Controllers to access the user.
    func AuthenicationDidComplete() {
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
    
}


//MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {

    /// helps us differentiate between each controller inside the tabController, by creating an index.
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        // finds a specific property inside a collection or array.
        let index = viewControllers?.firstIndex(of: viewController)

        // if that specific index is equal to number 2, then we configure the imagePicker
        if index == 2 {
            var configureImage = YPImagePickerConfiguration()
            configureImage.library.mediaType = .photo
            configureImage.shouldSaveNewPicturesToAlbum = false
            configureImage.startOnScreen = .library
            configureImage.screens = [.library]
            configureImage.hidesStatusBar = false
            configureImage.hidesBottomBar = false
            // allows users to posts multiple posts at a time or just one
            configureImage.library.maxNumberOfItems = 1

            let picker = YPImagePicker(configuration: configureImage)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            
            didFinishPickingMedia(picker)

        }

        return true
    }
    
}

//MARK: - UploadPostControllerDelegate


extension MainTabBarController: UploadPostControllerDelegate {
    
    /// after the post is uploaded we return the UI to the home controller through the selectedIndex value and we dismiss the controller.
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)
        
        // find the navigation that owns the feedController
        guard let feedNav = viewControllers?.first as? UINavigationController else {return}
        
        // we grab the first viewController from the navigation and cast it as a feedController.
        guard let feed = feedNav.viewControllers.first as? FeedController else {return}
        
        //then we call handle refresh.
        feed.hanldeRefresh()
    }
    
    
    
    
}
