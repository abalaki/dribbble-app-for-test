//
//  request.swift
//  Dribbble
//
//  Created by аймак on 25.08.17.
//  Copyright © 2017 Kaplya LLC. All rights reserved.
//

import UIKit

struct STreponseShots {
    var isSuccess:Bool = true
    var shots:[shots] = []
}

class request {
    
    let apiUrl = "https://api.dribbble.com/v1/"
    
    func fetch(method:String, parameters:String?, complection:@escaping(STreponseShots) -> Void) {
        var defaultSTresponseShots = STreponseShots(isSuccess: false, shots: [])
        var getParameters = method + "?access_token=\(accessToken)"
        if parameters != nil { getParameters = getParameters + "&" + parameters! }
        let url = URL(string: apiUrl + getParameters)!
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        DispatchQueue.global(qos: .utility).async {
            URLSession.shared.dataTask(with: req) { (data, resp, _) in
                if resp == nil || data == nil { complection(defaultSTresponseShots) }
                else {
                    let respStatus = (resp as! HTTPURLResponse).statusCode
                    if respStatus != 200 { complection(defaultSTresponseShots) }
                    else {
                        let shotsArray = self.makeJsonFromData(data: data!)
                        if shotsArray == nil { complection(defaultSTresponseShots) }
                        else {
                            self.deleteCacheFile()
                            defaultSTresponseShots.isSuccess = true
                            defaultSTresponseShots.shots = shotsArray!
                            complection(defaultSTresponseShots)
                            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                                let path = dir.appendingPathComponent("fetch").appendingPathExtension("txt")
                                try? data!.write(to: path)
                            }
                        }
                    }
                }
                }.resume()
        }
    }
    
    func fetchLocal(complection:@escaping(STreponseShots) -> Void) {
        var defaultSTresponseShots = STreponseShots(isSuccess: false, shots: [])
        DispatchQueue.global(qos: .utility).async {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let path = dir.appendingPathComponent("fetch").appendingPathExtension("txt")
                let jsonData = try? Data(contentsOf: path)
                if jsonData != nil {
                    let shotsArray = self.makeJsonFromData(data: jsonData!)
                    if shotsArray != nil {
                        defaultSTresponseShots.isSuccess = true
                        defaultSTresponseShots.shots = shotsArray!
                        complection(defaultSTresponseShots)
                    }
                }
            }
        }
    }
    
    func makeJsonFromData(data:Data) -> [shots]? {
        var shotsArray:[shots] = []
        let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [[String:Any]]
        if jsonData == nil { return nil }
        else {
            for json in jsonData! {
                let title = json["title"] as? String ?? nil
                let desc = json["description"] as? String ?? nil
                let images = json["images"] as? [String:Any] ?? nil
                let id = json["id"] as? Int ?? nil
                if title != nil && desc != nil && images != nil && id != nil {
                    let teaser = images!["teaser"] as? String ?? nil
                    let hidpi = images!["hidpi"] as? String ?? nil
                    let normal = images!["normal"] as? String ?? nil
                    if normal != nil && teaser != nil {
                        var urlNormal = URL(string: normal!)
                        let urlTeaser = URL(string: teaser!)
                        if urlNormal != nil && urlTeaser != nil {
                            var urlHidpi:URL?
                            if hidpi != nil {
                                urlHidpi = URL(string: hidpi!)
                                if urlHidpi != nil {urlNormal = urlHidpi! }
                            }
                            let newShot = shots(title: title!, desc: desc!, image: (normal: urlNormal!, teaser: urlTeaser!), id: "\(id!)")
                            shotsArray.append(newShot)
                        }
                    }
                }
            }
            
        }
        
        return shotsArray
    }
    
    func requestGetData(url:URL, complection: @escaping(Data?) -> Void) {
        
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: req) { (data, response, error) in
            
            if data != nil && error == nil {
                complection(data!)
            } else {
                complection(nil)
            }
            
            }.resume()
        
    }
    
    func deleteCacheFile() {
        if let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let files = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            if files != nil {
                for file in files! {
                    try? FileManager.default.removeItem(at: file)
                }
            }
        }
    }
    
}
