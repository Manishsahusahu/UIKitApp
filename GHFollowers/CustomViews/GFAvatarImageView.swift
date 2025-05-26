//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Manish sahu on 25/05/25.
//

import UIKit

class GFAvatarImageView: UIImageView {
    let placeholderImage = UIImage(named: "logo")
    let cache = NetworkManager.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(urlString: String) {
        let nsstring = NSString(string: urlString)
        if let image = cache.object(forKey: nsstring) {
            self.image = image
            return
        }
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }
            if let _ = error { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data else { return }
            
            guard let image = UIImage(data: data) else { return }
            cache.setObject(image, forKey: nsstring)
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
