//
//  SearchController.swift
//  Instagram Clone
//
//  Created by benny mushiya on 12/02/2021.
//

import UIKit

private let reuseIdentifier = "user cell"

class SearchController: UITableViewController {
    
    //MARK: - PROPERTIES
    
    private var users = [User]()
    private var filterUsers = [User]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    /// if the user has clicked inside the searchController, then SC is active comes back true, but we also want to make sure the text is not empty, so this computed property only returns true if the SC is clicked on and if the user writes something.
    private var inSearchMode: Bool {
        
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSeachController()
        configureUI()
        fetchUsers()
        
    }
    
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        view.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }
    
    func configureSeachController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "search"
        navigationItem.searchController = searchController
        definesPresentationContext = false
        
    }
    
    
    //MARK: - API
    
    func fetchUsers() {
        
        UserService.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
        
    }

    //MARK: - ACTION
    
    
    
}


//MARK: - UITableViewDataSource


extension SearchController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // if in searchMode is true we return the filteredUsers count, else we return users count
        return inSearchMode ? filterUsers.count : users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        
        // if were in searchMode we want to see filtered users else, we see normal users.
        let user = inSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        
        cell.viewModel = UserCellViewModel(user: user)
        
        return cell
        
    }
    
}

//MARK: - UITableViewDelegate

extension SearchController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = inSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        
        // goes to each users profile upon clicking on the user. because we initialsed the controller with a user.
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
}

//MARK: - UISearchResultsUpdating

extension SearchController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // gives us back everything we write in the search bar thats lowercassed.
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        
        // if the username or the name contains the searchText, then we populate the filterdUsers with all the users that meet that criteria. $0 represents each user one of the user were looking at inside the array.
        filterUsers = users.filter({$0.userName.contains(searchText) || $0.name.lowercased().contains(searchText)})
        
        self.tableView.reloadData()
    }
    
}
    
    


