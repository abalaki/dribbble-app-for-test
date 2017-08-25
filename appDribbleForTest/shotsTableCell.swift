//
//  shotsTableCell.swift
//  Dribbble
//
//  Created by аймак on 25.08.17.
//  Copyright © 2017 Kaplya LLC. All rights reserved.
//

import UIKit

class shotsTableCell:UITableViewCell {
    
    var url:URL?
    var urlTeser:URL?
    
    let shotTitle:UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightBold)
        lbl.textColor = UIColor.white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let shotDesc:UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = UIColor.white.withAlphaComponent(0.9)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 2
        return lbl
    }()
    
    let blackBox:UIView = {
        let vView = UIView()
        //vView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        vView.backgroundColor = UIColor(displayP3Red: 1/255, green: 63/255, blue: 114/255, alpha: 0.9)
        vView.translatesAutoresizingMaskIntoConstraints = false
        return vView
    }()
    
    let teaserImage:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let shotImage:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    override func prepareForReuse() {
        url = nil
        urlTeser = nil
        shotImage.image = nil
        teaserImage.image = nil
    }
    
    func setupViews(shot:shots) {
        self.backgroundColor = UIColor.clear
        
        contentView.addSubview(teaserImage)
        contentView.addSubview(shotImage)
        contentView.addSubview(blackBox)
        blackBox.addSubview(shotTitle)
        blackBox.addSubview(shotDesc)
        
        shotTitle.text = shot.title
        shotTitle.sizeToFit()
        
        let strWithoutHtml = shot.desc.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        shotDesc.text = strWithoutHtml
        shotDesc.sizeToFit()
        teaserImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        teaserImage.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        teaserImage.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        teaserImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        
        shotImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        shotImage.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        shotImage.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        shotImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        
        shotDesc.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        shotDesc.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        shotDesc.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        
        shotTitle.bottomAnchor.constraint(equalTo: shotDesc.topAnchor, constant: -10).isActive = true
        shotTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        shotTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        
        blackBox.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        blackBox.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        blackBox.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        blackBox.topAnchor.constraint(equalTo: shotTitle.topAnchor, constant: -15).isActive = true
    }
    
}
