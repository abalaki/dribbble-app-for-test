//
//  shotsTableView.swift
//  Dribbble
//
//  Created by аймак on 25.08.17.
//  Copyright © 2017 Kaplya LLC. All rights reserved.
//

import UIKit

class shotsTableView:UITableView, UITableViewDelegate, UITableViewDataSource {
    
    let imgLoader = loadImage(count: 1000, total: 100, name: "fetchList")
    var rootDelegate:PRrootContoroller!
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.separatorStyle = .none
        self.rowHeight = UIScreen.main.bounds.height / 2
        self.register(shotsTableCell.self, forCellReuseIdentifier: "shotsTableCell")
        self.backgroundColor = UIColor.lightGray
        self.contentInset = UIEdgeInsets(top: 64 - 5, left: 0, bottom: 0, right: 0)
        self.scrollIndicatorInsets = UIEdgeInsets(top: 64 - 5, left: 0, bottom: 0, right: 0)
        self.allowsSelection = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchShots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "shotsTableCell", for: indexPath) as! shotsTableCell
        cell.setupViews(shot: fetchShots[row])
        cell.url = fetchShots[row].image?.normal
        cell.urlTeser = fetchShots[row].image?.teaser
        if fetchShots[row].image == nil {
            imgLoader.localImage(id: fetchShots[row].id, complection: { (image) in
                DispatchQueue.main.async {
                    cell.shotImage.image = image
                }
            })
        } else {
            imgLoader.loadImage(url: fetchShots[row].image!.teaser, id: fetchShots[row].id) { (image, url) in
                if url == cell.urlTeser {
                    DispatchQueue.main.async {
                        cell.teaserImage.image = image
                    }
                    
                    self.imgLoader.loadImage(url: fetchShots[row].image!.normal, id: fetchShots[row].id) { (image, url) in
                        if url == cell.url {
                            DispatchQueue.main.async {
                                cell.shotImage.image = image
                            }
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if row == fetchShots.count - 6 {
            rootDelegate.pullDownToRefresh()
        }
    }
    
}
