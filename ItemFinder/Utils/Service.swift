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
import CoreLocation

class Service: NSObject {
    
    static let shared = Service()
    
    func createUserWithEmail(email: String, fullname: String, password: String, latitude: Double?, longitude: Double?, completion: @escaping(Result<String,Error>) -> ()) {
        
        var userInfoUploadValues = [String:Any]()
        
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
            
            if let lat = latitude,
                let long = longitude {
                userInfoUploadValues = ["fullname":fullname,
                                        "latitude": lat,
                                        "longitude": long]
            } else {
                userInfoUploadValues = ["fullname":fullname]
                }
            
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
    
//    upload item id
    func uploadItemId(_ itemId: String, completion: @escaping(Result<Bool,Error>) -> ()) {
        REF_ITEMS.child(itemId).updateChildValues(["id" : itemId]) { (err, ref) in
            
//            handle error
            if let error = err {
                completion(.failure(error))
                return
            }
            
            completion(.success(true))
        }
    }
    
    func uploadItemOwnerUid(_ itemId: String, _ uid: String, completion: @escaping(Result<Bool, Error>) -> ()) {
        REF_ITEMS.child(itemId).updateChildValues(["owner_uid" : uid]) { (err, ref) in
            
//            handle error
            if let error = err {
                completion(.failure(error))
                return
            }
            
            completion(.success(true))
        }
    }
    
//    upload title of item
    func uploadItemTitle(_ itemId: String, _ item: ItemForUpload, completion: @escaping(Result<Bool, Error>) ->()) {
        
        guard let title = item.title else { completion(.failure(CustomError.foundNil)); return}
        
        REF_ITEMS.child(itemId).updateChildValues(["title" : title]) { (err, ref) in
               
            if let error = err {
                   completion(.failure(error))
               }
            
            completion(.success(true))
        }
    }
    
//        upload optional description of item
    func uploadItemDescription(_ itemId: String, _ item: ItemForUpload, completion: @escaping(Result<Bool, Error>) ->()) {
        
        if let description = item.description {
            REF_ITEMS.child(itemId).updateChildValues(["description" : description]) { (err, ref) in
                
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
        
        USER_REF.child(uid).child("items").updateChildValues([itemId : "1"]) { (err, ref) in
            
//            handle error
            if let error = err {
                completion(.failure(error))
            }
            
            completion(.success(true))
        }
    }
    
//    upload item category
    func uploadItemCategory(_ itemId: String, category: String?, completion: @escaping(Result<Bool, Error>) -> ()) {
        
//        skip upload if no value was provided, return from function
        guard let category = category else {
            completion(.success(true))
            return
        }
        
//        upload category to item ref
        REF_ITEMS.child(itemId).updateChildValues(["category" : category]) { (err, ref) in
            
//            handle error
            if let error = err {
                completion(.failure(error))
                return
            }
            
//            upload itemId to cetegory ref
            REF_CATEGORY_SPORT.child(category).updateChildValues([itemId : 1]) { (err, ref) in
                
//                handle error
                if let error = err {
                    completion(.failure(error))
                    return
                }
                
                completion(.success(true))
            }
        }
    }
    

    
    func uploadItemImage(_ itemId: String, _ images: [UIImage]?, completion: @escaping(Result<String,Error>) -> ()) {
        
//        var urlStringArray = [String]()
        var urlFullString = String()
//        var imageInfo = [Dictionary<String,String>]()
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
                        
                        urlFullString.append(urlString + " ")
                        
//                        let dict: Dictionary<String,String> = [imageID : urlString]
//                        imageInfo.append(dict)

                        counter += 1
                        
                        if counter == imageArray.count {
                            group.leave()
                        }
                    }
                    
                }
            }
            
//            when all images are uploaded, exit with completion success
            group.notify(queue: .main) {

                completion(.success(urlFullString))
            }
        }
    }
    
//    MARK: TODO remove unnecessary info in imageInfo, image id is never used
//    upload item image url to user ref
    func uploadItemImageUrl(_ uid: String, _ itemId: String, _ imageUrlString: String?, completion: @escaping(Result<Bool, Error>) -> ()) {
        
//        var counter = 0
//        let group = DispatchGroup()
//        var values = [Dictionary<String,String>]()

//        group.enter()
        
        guard let urlString = imageUrlString else {
            completion(.success(true))
            return
        }
        
//        var urlArray = [String]()
        
//        var urlFullString: String?
            
//        imageInfo.forEach { (dict) in

//            create key for path
//            guard let key = dict.keys.first else {
//                completion(.failure(CustomError.foundNil))
//                return
//            }
            
//            create url for value
//            guard let urlString = dict.values.first else {
//                completion(.failure(CustomError.foundNil))
//                return
//            }
            
//            urlArray.append(urlString)
            
//            urlFullString?.append(urlString)
            
//            let dict = ["image_url" : urlString]
//            values.append(dict)
//            let dict2 = []
            
//            REF_ITEMS.child(itemId).child("image_url").updateChildValues([key: urlString]) { (err, ref) in

//                handle error
//                if let error = err {
//                    completion(.failure(error))
//                    return
//                }
        
//                when all urls are uploaded, exit group
//                counter += 1
//                if counter == imageInfo.count {
//                    group.leave()
//                }
//            }
//        }
        
        REF_ITEMS.child(itemId).updateChildValues(["image_url" : urlString]) { (err, ref) in
            
//            handle error
            if let error = err {
                completion(.failure(error))
                return
            }
            completion(.success(true))
//            group.leave()
        }
        
//        group.notify(queue: .main) {
//
////            let urlDict = []
////            let uploadValues = ["image_url" : values]
//
//
////            upload values
//            REF_ITEMS.child(itemId).updateChildValues(uploadValues) { (err, ref) in
//
////                handle error
//                if let error = err {
//                    completion(.failure(error))
//                    return
//                }
//
//                completion(.success(true))
//            }
//        }
    }
    
    func uploadKeywords(_ uid: String, _ itemId: String, _ item: ItemForUpload, completion: @escaping(Result<Bool,Error>) -> ()) {
        
        let group = DispatchGroup()
        var counter = 0
        
        guard let keywordsstring = item.keywords else {
            completion(.success(true))
            return
        }
        
        guard let keywords = item.keywords?.components(separatedBy: " ") else {
            completion(.success(true))
            return
        }
        
        guard keywords.isEmpty == false else  {
            completion(.success(true))
            return
        }
        
        guard keywords.first != "" else {
            completion(.success(true))
            return
        }
        
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
            
            REF_ITEMS.child(itemId).updateChildValues(["keywords" : keywordsstring]) { (err, ref) in
                
//                    handle error
                if let error = err {
                    completion(.failure(error))
                    return
                }
                
                completion(.success(true))
            }
        }
    }
    
    func uploadIsItemForSale(_ uid: String, _ itemId: String, _ item: ItemForUpload, completion: @escaping(Result<Bool, Error>) -> ()) {
        
        if item.isForSale {
            
//            upload true to item ref
            REF_ITEMS.child(itemId).updateChildValues(["is_for_sale" : true]) { (err, ref) in
                
//                handle error
                if let error = err {
                    completion(.failure(error))
                    return
                }
                
//                upload info to item for sale ref
//                let values = [
//                    "item_id" : itemId,
//                    "user_uid" : uid
//                ]
                
                REF_ITEM_FOR_SALE.updateChildValues([itemId: 1]) { (err, ref) in
                    
//                    handle error
                    if let error = err {
                        completion(.failure(error))
                        return
                    }
                    
//                    completion(.success(true))
                }
            }
            
        } else {
            
//            upload false to item ref
            REF_ITEMS.child(itemId).updateChildValues(["is_for_sale" : false]) { (err, ref) in

//                handle error
                if let error = err {
                    completion(.failure(error))
                    return
                }
//                completion(.success(true))
            }
        }
        
        if item.isForGiveAway {
            
//            upload true to item ref
            REF_ITEMS.child(itemId).updateChildValues(["is_for_give_away" : true]) { (err, ref) in
                
//                handle error
                if let error = err {
                    completion(.failure(error))
                    return
                }
                
                REF_ITEM_FOR_GIVE_AWAY.updateChildValues([itemId: 1]) { (err, ref) in
                                
//                    handle error
                    if let error = err {
                        completion(.failure(error))
                        return
                    }
                    
//                    completion(.success(true))
                }
            }
        } else {
//            upload false to item ref
            REF_ITEMS.child(itemId).updateChildValues(["is_for_give_away" : false]) { (err, ref) in

//                handle error
                if let error = err {
                    completion(.failure(error))
                    return
                }
                completion(.success(true))
            }
        }
    }
    
    func uploadItemLocation(_ uid: String, _ itemId: String, completion: @escaping(Result<Bool,Error>) -> Void) {
        
        var latitude: Double?
        var longitude: Double?
        let group = DispatchGroup()
        
        group.enter()

//        fetch user location coordinates
        USER_REF.child(uid).child("user_info").observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dict = snapshot.value as? Dictionary<String,Any> else { return }
            guard let lat = dict["latitude"] as? Double else { return }
            guard let long = dict["longitude"] as? Double else { return }
            
            latitude = lat
            longitude = long
            
            group.leave()
        }
        
//        upload user coordinates to item ref
        group.notify(queue: .main) {
            
            if let latitude = latitude,
                let longitude = longitude {
                
                let uploadValues = [
                                    "latitude":latitude,
                                    "longitude":longitude
                                    ]
                
                REF_ITEMS.child(itemId).updateChildValues(uploadValues) { (err, ref) in
                    
//                    handle error
                    if let error = err {
                        completion(.failure(error))
                        return
                    }
                    
                    completion(.success(true))
                }
            }
        }
    }
    
    func uploadItemLocationToLocationRef(_ uid: String, _ itemId: String, _ isForSale: Bool, _ isForGiveAway: Bool, completion: @escaping(Result<Bool,LocationError>) -> Void)  {
        
//        fetch current users home location
        USER_REF.child(uid).child("user_info").observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dict = snapshot.value as? Dictionary<String,Any> else {completion(.success(true)); return }
            
            guard let lat = dict["latitude"] as? Double,
                let long = dict["longitude"] as? Double
                else { completion(.failure(.couldNotRetreiveCoordinates)); return }
            
            guard let latitude = CLLocationDegrees(exactly: lat),
                let longitude = CLLocationDegrees(exactly: long)
                else { completion(.failure(.couldNotRetreiveCoordinates)); return }
            
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location) { (placemarks, err) in
                
//                    handle error
                if err != nil {
                    completion(.failure(.couldNotRetreivePlacemarks))
                    return
                }
                
//                get placemarks
                guard let placemark = placemarks?[0] else {
                    completion(.failure(.couldNotRetreiveLocation))
                    return
                }
                
                guard let country = placemark.country else {
                    completion(.failure(.couldNotRetreiveLocation))
                    return
                }
                
                guard let administrativeArea = placemark.administrativeArea,
                    let city = placemark.locality
                    else {completion(.failure(.couldNotRetreivePlacemarks)); return }
                
                if isForSale {
                    REF_LOCATIONS_ADMINISTRATIVE_AREA.child(country).child(administrativeArea).child("is_for_sale").updateChildValues([itemId : 1]) { (err, ref) in
                                        
    //                    handle error
                        if err != nil {
                            completion(.failure(.couldNotUploadUserLocation))
                            return
                        }
                        
                        REF_LOCATIONS_LOCALITY.child(country).child(city).child("is_for_sale").updateChildValues([itemId : 1]) { (err, ref) in
                            
    //                        handle error
                            if err != nil {
                                completion(.failure(.couldNotUploadUserLocation))
                                return
                            }
                            completion(.success(true))
                        }
                    }
                }
                
                if isForGiveAway {
                    REF_LOCATIONS_ADMINISTRATIVE_AREA.child(country).child(administrativeArea).child("is_for_give_away").updateChildValues([itemId : 1]) { (err, ref) in
                                        
    //                    handle error
                        if err != nil {
                            completion(.failure(.couldNotUploadUserLocation))
                            return
                        }
                        
                        REF_LOCATIONS_LOCALITY.child(country).child(city).child("is_for_give_away").updateChildValues([itemId : 1]) { (err, ref) in
                            
    //                        handle error
                            if err != nil {
                                completion(.failure(.couldNotUploadUserLocation))
                                return
                            }
                            completion(.success(true))
                        }
                    }
                }
                
            }
        }
    }
    
//    func fetchItem() {
//        guard let url = URL(string: "https://itemfinder-c0570.firebaseio.com/items.json")
//            else {
//                print("DEBUG error creating url")
//            return }
//
//        URLSession.shared.dataTask(with: url) { (data, resp, err) in
//
////            handle error
//            if let error = err {
//                print("DEBUG error fetiching JSON from database", error.localizedDescription)
//                return
//            }
//
//            guard let data = data else { print("DEBUG error creating data"); return }
//
//            guard let dataString = String(data: data, encoding: .utf8) else { return }
//
//            print("DEBUG", dataString)
//
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let items = try decoder.decode([String : Item].self, from: data)
//                print("DEBUG skapade item med id", items.first?.key)
//                let key = items.first?.key
//                items.forEach { (dict) in
//                    print("DEBUG ", dict.value.title)
//                    let item: Item?
//                    item = dict.value
//                    print("DEBUG kat", item?.category)
////                    print("DEBUG titel", item?.image_url?[0].image_url)
//            }
//
////                let items = try JSONDecoder().decode([String : Item], from: data)
////                print("DEBUG Item", items.description?.title)
//
//            } catch let error {
//                print("DEBUG failed to create Item", error)
//            }
//
//        }.resume()
//    }
    
    func fetcCurrentUserItems(_ uid: String, completion: @escaping(Result<Item,Error>) -> Void) {
        
//        grab item id from user ref
        USER_REF.child(uid).child("items").observeSingleEvent(of: .value) { (snapshot) in
            
            guard let allChildren = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allChildren.forEach { (snap) in
                
                let itemId = snap.key
                
                REF_ITEMS.child(itemId).observeSingleEvent(of: .value) { (itemSnap) in
                    
                    guard let dict = itemSnap.value as? [String:Any] else { return }
                    
                    let item = Item(id: itemId, dict: dict)
                    completion(.success(item))
                }
            }
        }
    }
    
    func searchItemsForSaleInCurrentCity(_ country: String, _ locality: String) {
        
        REF_LOCATIONS_LOCALITY.child(country).child(locality).child("is_for_sale").observeSingleEvent(of: .value) { (snapshot) in
            
            guard let allItemIds = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allItemIds.forEach { (dict) in
                
                let itemId = dict.key
                
                REF_ITEMS.child(itemId).observeSingleEvent(of: .value) { (snapshot) in
                    
                    guard let dict = snapshot.value as? Dictionary<String,AnyObject> else { return }
                    
                    let item = DownloadedItem(dict)
                    print("DEBUG item", item.title)
                    
                }
                
                
            }
        }
    }
}
