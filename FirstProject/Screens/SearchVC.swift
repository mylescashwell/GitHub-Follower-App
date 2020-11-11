//
//  SearchVC.swift
//  FirstProject
//
//  Created by Myles Cashwell on 10/10/20.
//  Copyright © 2020 Myles Cashwell. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureFPTextField()
        configureCallToAction()
        createDissmissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    let logoImageView = UIImageView()
    let usernameTextField = FPTextField()
    let callToActionButton = FPButton(backgroundColor: .systemGreen, title: "Github Followers")
    
    var isUsernameEntered: Bool { return !usernameTextField.text!.isEmpty }
    
//---------------------------------------------------------------------------------------------------------------------------------------------
    
    func createDissmissKeyboardTapGesture() {
           let tap = UITapGestureRecognizer(target: view.self, action: #selector(UIView.endEditing(_:)))
           view.addGestureRecognizer(tap)
       }
    
    @objc func pushFollowerListVC() {
        guard isUsernameEntered else {
            presentFPAlertOnMainThread(title: "Empty Username", message: "Please enter a valid Username. We need to know who to look for! 😁", buttonTitle: "Ok")
            return
        }
        
        let followerListVC = FollowersListVC()
        followerListVC.username = usernameTextField.text
        followerListVC.title = usernameTextField.text
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
//---------------------------------------------------------------------------------------------------------------------------------------------

    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")!
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureFPTextField() {
        view.addSubview(usernameTextField)
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCallToAction() {
        view.addSubview(callToActionButton)
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

//---------------------------------------------------------------------------------------------------------------------------------------------

extension SearchVC: UITextFieldDelegate {
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           pushFollowerListVC()
           return true
        // ensures that the Return key on the keyboard also calls the pushFollowerListVC()
       }
   }
