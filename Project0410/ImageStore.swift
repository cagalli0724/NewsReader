//
//  ImageFile.swift
//  Project0410
//
//  Created by yipei zhu on 4/25/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//
//

import UIKit

class ImageStore {
    var cache = NSCache<AnyObject, AnyObject>()
    
    //imageURLForKey returns the URL for an image for a given key
    //We will save every image to a separate file
    //func imageURLForKey(_ key: String) -> URL {
    //    let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    //    let documentDirectory = documentsDirectories.first!
    //    return documentDirectory.appendingPathComponent(key)
    //}
    
    //Add a key-image pair to the cache AND save it on the disk
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as AnyObject)
    }
    
    //Retrieve an image from the cache or disk for a given key.
    func imageForKey(_ key: String) -> UIImage? {
        if let imageFromCache = cache.object(forKey: key as AnyObject) as? UIImage {
            return imageFromCache
        }
        
        return nil
    }
    
    //Remove an image from the cache and the disk
    func removeImageForKey(_ key: String) {
        cache.removeObject(forKey: key as AnyObject)
        
    }
}






