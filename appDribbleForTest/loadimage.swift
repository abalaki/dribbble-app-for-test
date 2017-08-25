//
//  loadImage.swift
//  Dribbble
//
//  Created by аймак on 25.08.17.
//  Copyright © 2017 Kaplya LLC. All rights reserved.
//

import UIKit

class loadImage {
    
    let imageCache = NSCache<NSURL, UIImage>()
    
    init(count:Int, total:Int, name:String) {
        
        imageCache.countLimit = count
        imageCache.totalCostLimit = total*1024*1024
        imageCache.name = name
        
    }
    
    func localImage(id:String, complection: @escaping(UIImage?) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            if let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
                let path = dir.appendingPathComponent(id)
                let data = try? Data(contentsOf: path)
                if data != nil {
                    let image = UIImage(data: data!)
                    if image != nil { complection(image!) }
                } else { complection(nil) }
            } else { complection(nil) }
        }
    }
    
    func loadImage(url:URL, id:String, complection: @escaping(UIImage?, URL) -> Void) {
        
        let fetch = request()
        
        if let image = imageCache.object(forKey: url as NSURL) {
            complection(image, url)
        } else {
            localImage(id: id, complection: { (image) in
                if image != nil {
                    self.imageCache.setObject(image!, forKey: url as NSURL)
                    complection(image, url)
                } else {
                    DispatchQueue.global(qos: .utility).async {
                        fetch.requestGetData(url: url, complection: { (imgdata) in
                            if imgdata != nil {
                                let img = UIImage(data: imgdata!)
                                if img != nil {
                                    self.imageCache.setObject(img!, forKey: url as NSURL)
                                    if let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
                                        let path = dir.appendingPathComponent(id)
                                        try? imgdata!.write(to: path, options: Data.WritingOptions.noFileProtection)
                                    }
                                    complection(img!, url)
                                }
                            }
                        })
                    }
                }
            })
        }
        
        
    }
    
}
