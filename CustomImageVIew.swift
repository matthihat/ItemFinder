//
//  CustomImageVIew.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-06-08.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var latestUrlUsedToLoadImage: String?
    
    func loadImage(with urlString: String) {
        
        self.image = nil
        
        latestUrlUsedToLoadImage = urlString
        
//        check if image already exists in cache and return
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
            

           let request = URLRequest(url: url)
           let task = URLSession.shared.dataTask(with: request) { (d, r, e) in
            
//            handle error
            if e != nil {
                print("DEBUG error loading image ", e?.localizedDescription)
                return
            }
            if self.latestUrlUsedToLoadImage != url.absoluteString {
                return
            }

            guard let data = d else { return }
                
            guard let image = UIImage(data: data) else { return }
                
//            set key and value for image cache
            
            
//            set image
            DispatchQueue.main.async {
                self.image = image
                imageCache[url.absoluteString] = image
            }
            
            }
            task.resume()
        }
        
    }
