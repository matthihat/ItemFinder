//
//  Service.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-18.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import Foundation
import Firebase
import SVProgressHUD

class Service: NSObject {
    
    static let shared = Service()
    
    func createUserWithEmail(email: String, fullname: String, password: String, completion: @escaping(Result<String,Error>) -> ()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if let error = err {
                completion(.failure(error))
                return
            }
            
            guard let uid = result?.user.uid
                else {
                    print("DEBUG err found nil")
                    return
                }
            
            let userInfoUploadValues = ["fullname":fullname]
            
            USER_REF.child(uid).child("user_info").updateChildValues(userInfoUploadValues) { (err, ref) in
                
//                    handle error
                if let error = err {
                    completion(.failure(error))
                }
                
//                    completion
                completion(.success(uid))

            }
        }
    }
    
    func loginWithEmail(email: String, password: String, completion: @escaping(Result<Bool, Error>) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            
//            handle error
            if let error = err {
                completion(.failure(error))
            }
            
//            if successfull
            completion(.success(true))
        }
    }
    
//    upload title of item
    func uploadItemTitle(_ itemId: String, _ item: ItemForUpload, completion: @escaping(Result<Bool, Error>) ->()) {
        
        guard let title = item.title else { completion(.failure(CustomError.foundNil)); return}
        
        REF_ITEMS.child(itemId).child("description").updateChildValues(["title" : title]) { (err, ref) in
               
            if let error = err {
                   completion(.failure(error))
               }
            
            completion(.success(true))
        }
    }
    
//        upload optional description of item
    func uploadItemDescription(_ itemId: String, _ item: ItemForUpload, completion: @escaping(Result<Bool, Error>) ->()) {
        
        if let description = item.description {
            REF_ITEMS.child(itemId).child("description").updateChildValues(["description" : description]) { (err, ref) in
                
//                handle error
                if let error = err {
                    completion(.failure(error))
                }
                
                completion(.success(true))
            }
        }
    }
    
//    upload item id to user
    func uploadItemIdToUser(_ uid: String, _ itemId: String, completion: @escaping(Result<Bool, Error>) -> ()) {
        
        USER_REF.child(uid).child("item").updateChildValues([itemId : "1"]) { (err, ref) in
            
//            handle error
            if let error = err {
                completion(.failure(error))
            }
            
            completion(.success(true))
        }
    }
    
    func uploadItemImage(_ itemId: String, _ images: [UIImage]?, completion: @escaping(Result<[Dictionary<String,String>],Error>) -> ()) {
        
        var urlStringArray = [String]()
        var imageInfo = [Dictionary<String,String>]()
        var counter = 0
        let group = DispatchGroup()
        
        group.enter()
        
        if let imageArray = images {
            imageArray.forEach { (image) in
                
                
                
                guard let data = image.jpegData(compressionQuality: 0.3) else {
                    completion(.failure(CustomError.invalidData))
                    return
                }
                
                let imageID = NSUUID.init().uuidString
                
                STORAGE_IMAGE.child(itemId).child(imageID).putData(data, metadata: nil) { (metadata, err) in
                    
    //                handle error
                    if let error = err {
                        completion(.failure(error))
                    }
                    
    //                get image urlString
                    STORAGE_IMAGE.child(itemId).child(imageID).downloadURL { (url, err) in
                        
    //                    handle error
                        if let error = err {
                            completion(.failure(error))
                            return
                        }
                        
//                        get url
                        guard let urlString = url?.absoluteString else {
                            completion(.failure(CustomError.invalidData))
                            return
                        }
                        
                        let dict: Dictionary<String,String> = [imageID : urlString]
                        imageInfo.append(dict)

                        counter += 1
                        
                        if counter == imageArray.count {
                            group.leave()
                        }
                    }
                    
                }
            }
            
//            when all images are uploaded, exit with completion success
            group.notify(queue: .main) {

                completion(.success(imageInfo))
            }
        }
    }
    
//    upload item image url to user ref
    func uploadItemImageUrl(_ uid: String, _ itemId: String, _ imageInfo: [Dictionary<String,String>], completion: @escaping(Result<Bool, Error>) -> ()) {
        
        var counter = 0
        let group = DispatchGroup()
        
        group.enter()
        
        imageInfo.forEach { (dict) in
            
//            create key for path
            guard let key = dict.keys.first else {
                completion(.failure(CustomError.foundNil))
                return
            }
            
//            create url for value
            guard let urlString = dict.values.first else {
                completion(.failure(CustomError.foundNil))
                return
            }
            
            REF_ITEMS.child(itemId).child("image_url").updateChildValues([key: urlString]) { (err, ref) in

//                handle error
                if let error = err {
                    completion(.failure(error))
                    return
                }

//                when all urls are uploaded, exit group
                counter += 1
                if counter == imageInfo.count {
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(.success(true))
        }
    }
    
    func uploadKeywords(_ uid: String, _ itemId: String, _ item: ItemForUpload, completion: @escaping(Result<Bool,Error>) -> ()) {
        
        let group = DispatchGroup()
        var counter = 0
        
        if let keywords = item.keywords {
            
            group.enter()
            
            keywords.forEach { (keyword) in
                
                REF_KEYWORD.child(keyword).updateChildValues([itemId : 1]) { (err, ref) in
                    
                    counter += 1
                    
//                    handle error
                    if let error = err {
                        completion(.failure(error))
                        return
                    }
                    
//                    check that all elements have been handled
                    if counter == keywords.count {
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                
                var counter2 = 0
                
                keywords.forEach { (keyword) in
                    REF_ITEMS.child(itemId).child("keyword").updateChildValues([keyword : 1]) { (err, ref) in
                        
//                        handle error
                        if let error = err {
                            completion(.failure(error))
                            return
                        }
                        
//                    check that all elements have been handled
                        counter2 += 1
                        if counter2 == keywords.count {
                            completion(.success(true))
                        }
                        
                    }
                }
            }
        }
        
    }
}
