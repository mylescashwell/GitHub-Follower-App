//
//  FPFollowerItemVC.swift
//  FirstProject
//
//  Created by Myles Cashwell on 10/27/20.
//  Copyright © 2020 Myles Cashwell. All rights reserved.
//

import UIKit

class FPFollowerItemVC: FPItemInfoVC {
    // Child Class for FPItemInfoVC.swift

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoView1.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoView2.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
}
