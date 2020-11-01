//
//  FPAvatarImageView.swift
//  FirstProject
//
//  Created by Myles Cashwell on 10/16/20.
//  Copyright © 2020 Myles Cashwell. All rights reserved.
//

import UIKit

class FPAvatarImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    let cache            = NetworkManager.shared.cache
    let placeholderImage = UIImage(named: "avatar-placeholder")
    
//---------------------------------------------------------------------------------------------------------------------------------------------
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//---------------------------------------------------------------------------------------------------------------------------------------------
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
//---------------------------------------------------------------------------------------------------------------------------------------------
    
    func downloadImage(from urlString: String) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            self.image = image
            return
            // downloadImage is going to check cache for object
            // object being urlString
            // cache needs to pull an NSString, so we set our Swift String as an NSString
        }
        
        
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil { return }
            guard let repsonse = response as? HTTPURLResponse, repsonse.statusCode == 200 else { return }
            guard let data = data else { return }
            // these three checks will return out of the function, leaving no image downloaded, AND no errors for not downloading images
            // this will leave the avatar set to it's placeholderImage
                        
            guard let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}
