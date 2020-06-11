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
    var isForGiveAway: Bool
    var category: String?
//    var latitude: Double?
//    var longitude: Double?
//    var administrativeArea: String?
//    var city: String?
    
    init(_ title: String?, _ keywords: String?, _ description: String?, _ images: [UIImage]?, _ isForSale: Bool, _ isForGiveAway: Bool, _ category: String?) {
        self.title = title
        self.keywords = keywords
        self.description = description
        self.images = images
        self.isForSale = isForSale
        self.isForGiveAway = isForGiveAway
        self.category = category
    }
    
    func uploadItem(_ item: ItemForUpload, completion: @escaping(Result<Bool, Error>) -> ()) {
            
        guard let uid = Auth.auth().currentUser?.uid else { completion(.failure(ItemUploaderError.invalidValue)); return }
        
        let itemId = NSUUID.init().uuidString
        
        let group = DispatchGroup()
            
        var imageUrlString: String?
        
        Service.shared.uploadItemId(itemId) { (result) in
            
            switch result {
                
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
        
        Service.shared.uploadItemOwnerUid(itemId, uid) { (result) in
            
            switch result {
            case .success(_):
                Void()
            case .failure(let error):
                completion(.failure(error))
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
        
        Service.shared.uploadItemCategory(itemId, category: category) { (result) in
            
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
        
        Service.shared.uploadItemLocation(uid, itemId) { (result) in
            
            switch result {
            case .success(_):
                Void()
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        Service.shared.uploadItemLocationToLocationRef(uid, itemId, isForSale, isForGiveAway) { (result) in
            
            switch result {
            case .success(_):
                Void()
            case .failure(let error):
                completion(.failure(error))
            }
        }

        group.enter()
        DispatchQueue.main.async {
            Service.shared.uploadItemImage(itemId, item.images) { (result) in
                
                switch result {
                case .success(let urlString):
//                    assign local variable
                    imageUrlString = urlString
                    group.leave()
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        group.notify(queue: .main) {
            Service.shared.uploadItemImageUrl(uid, itemId, imageUrlString) { (result) in

                switch result {
                case .success(_):
//                    completion(.success(true))
                    Void()
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
