//
//  ExpressNode.swift
//  LJNetwork
//
//  Created by manajay on 2018/3/8.
//  Copyright © 2018 manajay. All rights reserved.
//

import Foundation

struct ExpressNode {

    var time: String
    var ftime: String
    var context: String
    var location: String
    
    init( time: String = ""
    , ftime: String = ""
    , context: String = ""
    , location: String = "") {
        self.time = time
        self.ftime = ftime
        self.context = context
        self.location = location
    }
}
