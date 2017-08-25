//
//  struct.swift
//  Dribbble
//
//  Created by аймак on 25.08.17.
//  Copyright © 2017 Kaplya LLC. All rights reserved.
//

import Foundation

let accessToken:String = "156c8a7d4b6f145e820265cf89886c6f1b11659ff67909371c43830a1953914e"

struct shots {
    var title:String
    var desc:String
    var image:(normal:URL, teaser:URL)?
    var id:String
}

var fetchShots:[shots] = []
