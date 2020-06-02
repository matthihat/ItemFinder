//
//  SelectedImages.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-25.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit
import Firebase

struct ItemForUpload {
    
    let title: String?
    let keywords: String?
    let description: String?
    let images: [UIImage]?
    var isForSale: Bool
    var category: String?
    
    init(_ title: String?, _ keywords: String?, _ description: String?, _ images: [UIImage]?, _ isForSale: Bool, _ category: String?) {
        self.title = title
        self.keywords = keywords
        self.description = description
        self.images = images
        self.isForSale = isForSale
        self.category = category
    }
    
    func uploadItem(_ item: ItemForUpload, completion: @escaping(Result<Bool, Error>) -> ()) {
            
        guard let uid = Auth.auth().currentUser?.uid else { completion(.failure(ItemUploaderError.invalidValue)); return }
        
        let itemId = NSUUID.init().uuidString
        
        let group = DispatchGroup()
            
        var imageInfo: [Dictionary<String,String>]?
        
        Service.shared.uploadItemId(itemId) { (result) in
            
            switch result {
                
            case .success(_):
                Void()
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
            
        Service.shared.uploadItemTitle(itemId, item) { (result) in
        
            switch result {
            case .success(_):
                Void()
            case .failure(let error):
                completion(.failure(error))
            }
        }

        Service.shared.uploadItemDescription(itemId, item) { (result) in
            
            switch result {
            case .success(_):
                Void()
            case .failure(let error):
                completion(.failure(error))
            }
        }
    
        Service.shared.uploadItemIdToUser(uid, itemId) { (result) in
            
            switch result {
            case .success(_):
                Void()
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        Service.shared.uploadKeywords(uid, itemId, item) { (result) in

            switch result {
            case .success(_):
                Void()
            case .failure(let error):
                completion(.failure(error))
            }
        }
    
        Service.shared.uploadIsItemForSale(uid, itemId, item) { (result) in

            switch result {
            case .success(_):
                print("DEBUG success")
            case .failure(let error):
                completion(.failure(error))
            }
        }

        group.enter()
        DispatchQueue.main.async {
            Service.shared.uploadItemImage(itemId, item.images) { (result) in
                
                switch result {
                case .success(let array):
//                    assign local variable
                    imageInfo = array
                    group.leave()
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        group.notify(queue: .main) {
            Service.shared.uploadItemImageUrl(uid, itemId, imageInfo) { (result) in

                switch result {
                case .success(_):
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

    }
        
        enum ItemUploaderError: LocalizedError {
            case invalidValue
            case userIsNotLoggedIn
            case uploadFailure
            
            var errorDescription: String? {
                switch self {
                case .invalidValue:
                    return "Found nil."
                case .userIsNotLoggedIn:
                    return "User is not logged in."
                case .uploadFailure:
                    return "Failed to upload item."
                }
            }
        }
}
