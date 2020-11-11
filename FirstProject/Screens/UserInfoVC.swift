//
//  UserInfoVC.swift
//  FirstProject
//
//  Created by Myles Cashwell on 10/26/20.
//  Copyright © 2020 Myles Cashwell. All rights reserved.
//

import UIKit

protocol userInfoVCDelegate: class {
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class UserInfoVC: UIViewController {
    
    let headerView  = UIView()
    let itemView1   = UIView()
    let itemView2   = UIView()
    let dateLabel   = FPBodyLabel(textAlignment: .center)
    // dateLabel configuration found in Date+/String+ Extensions
    
    var username: String!
    var itemViews: [UIView] = []
    
    weak var delegate: followersListVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureViewController()
        getUserInfo()
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async { self.configureUIElements(with: user) }
                
            case .failure(let Error):
                self.presentFPAlertOnMainThread(title: "Something went wrong", message: Error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureUIElements(with user: User) {
        
        let repoItemVC          = FPRepoItemVC(user: user)
        repoItemVC.delegate     = self
        
        let followerItemVC      = FPFollowerItemVC(user: user)
        followerItemVC.delegate = self
        
        self.add(childVC: repoItemVC, to: self.itemView1)
        self.add(childVC: followerItemVC, to: self.itemView2)
        self.add(childVC: FPUserInfoHeaderVC(user: user), to: self.headerView)
        self.dateLabel.text = "GitHub user since \(user.createdAt.convertToDisplayFormat())"
        
    }
        
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    func layoutUI() {
        itemViews = [headerView, itemView1, itemView2, dateLabel]
        // refactoring
        
        let padding: CGFloat    = 20
        let itemHeight: CGFloat = 140
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemView1.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemView1.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemView2.topAnchor.constraint(equalTo: itemView1.bottomAnchor, constant: padding),
            itemView2.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemView2.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}

//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------

extension UserInfoVC: userInfoVCDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentFPAlertOnMainThread(title: "Invalid URL", message: "The URL attached to this profile is invalid.", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }

    
}
