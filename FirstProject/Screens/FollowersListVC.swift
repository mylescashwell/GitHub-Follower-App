//
//  FollowersListVC.swift
//  FirstProject
//
//  Created by Myles Cashwell on 10/12/20.
//  Copyright © 2020 Myles Cashwell. All rights reserved.
//

import UIKit

protocol followersListVCDelegate: class {
    func didRequestFollowers(for username: String)
}

class FollowersListVC: UIViewController {
    
    enum Section { case main }
    
    var username: String!
    var page = 1
    var hasMoreFollowers = true
    var Followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var isSearching = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
        
    }
 
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    func configureViewController() {
          view.backgroundColor = .systemBackground
          navigationController?.navigationBar.prefersLargeTitles = true
      }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.threeCollumnCollectionViewFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(followerCell.self, forCellWithReuseIdentifier: followerCell.reuseID)
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    func configureSearchController() {
        let searchController                                  = UISearchController()
        searchController.searchResultsUpdater                 = self
        searchController.searchBar.delegate                   = self
        searchController.searchBar.placeholder                = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController                       = searchController
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------

    func getFollowers(username: String, page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] Result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch Result {
            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false }
                self.Followers.append(contentsOf: followers)
                
                if self.Followers.isEmpty {
                    let message = "This user doesn't have any followers. Give them a follow! 😀"
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                }
                self.updateData(on: self.Followers)
                
            case .failure(let error):
                self.presentFPAlertOnMainThread(title: "Bad stuff happened.", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
 
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: followerCell.reuseID, for: indexPath) as! followerCell
            
            cell.set(follower: follower)
            
            return cell
        })
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        
        snapshot.appendSections([.main])
        
        snapshot.appendItems(followers)
       
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
   
        }
    }
}

//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------

extension FollowersListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // check function to know if more followers are to be loaded
        
        let screenLocation = scrollView.contentOffset.y
        let contentHeight  = scrollView.contentSize.height
        let height         = scrollView.frame.size.height
        
        print("Screen Location: \(screenLocation)")
        print("Content Height:  \(contentHeight)")
        print("Height:          \(height)")
       
        if screenLocation > contentHeight - height {
            // if math is true, check to see if user has more followers to load
            
            guard hasMoreFollowers else { return }
            // if followers.count < 100, return out of extension
            // if followers.count > 100, add page
            
            page += 1
            
            getFollowers(username: username, page: page)
            // getFollowers() with appended page
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let activeArray     = isSearching ? filteredFollowers : Followers
        let follower        = activeArray[indexPath.item]
        
        let destVC          = UserInfoVC()
        destVC.delegate     = self
        destVC.username     = follower.login
        let navController   = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

extension FollowersListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filteredFollowers = Followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: Followers)
    }
}

extension FollowersListVC: followersListVCDelegate  {
    func didRequestFollowers(for username: String) {
        self.username = username
        title         = username
        page          = 1
        Followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(username: username, page: page)
    }
}
