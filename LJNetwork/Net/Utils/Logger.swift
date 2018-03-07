//
//  Logger.swift
//  LJNetwork
//
//  Created by manajay on 2018/3/7.
//  Copyright © 2018 manajay. All rights reserved.
//

import Foundation

func toLog(_ items: Any...) {
    if HttpManager.share.debugStatus == false {
        return
    }
    
    print(items)
}
