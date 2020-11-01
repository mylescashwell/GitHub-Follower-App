//
//  FPRepoItemVC.swift
//  FirstProject
//
//  Created by Myles Cashwell on 10/27/20.
//  Copyright © 2020 Myles Cashwell. All rights reserved.
//

import UIKit

class FPRepoItemVC: FPItemInfoVC {
    // Child Class for FPItemInfoVC.swift
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoView1.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoView2.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
}
