//
//  FPItemInfoVC.swift
//  FirstProject
//
//  Created by Myles Cashwell on 10/27/20.
//  Copyright © 2020 Myles Cashwell. All rights reserved.
//

import UIKit


class FPItemInfoVC: UIViewController {
    //Superclass
    
    let stackView     = UIStackView()
    let itemInfoView1 = FPItemInfoView()
    let itemInfoView2 = FPItemInfoView()
    let actionButton  = FPButton()
    
    var user: User!
    weak var delegate: userInfoVCDelegate!
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActionButton()
        configureBackgroudView()
        layoutUI()
        configureStackView()
    }
    
    private func configureBackgroudView() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(itemInfoView1)
        stackView.addArrangedSubview(itemInfoView2)
    }
    
    private func configureActionButton() {
         actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
     }
    
    @objc func actionButtonTapped() {
        print("action button tapped")
    }
        
    private func layoutUI() {
        view.addSubview(stackView)
        view.addSubview(actionButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let padding:CGFloat = 20
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
}
