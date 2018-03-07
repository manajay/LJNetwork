//
//  ApiDemoRequest.swift
//  LJNetwork
//
//  Created by manajay on 2018/3/7.
//  Copyright © 2018 manajay. All rights reserved.
//

import Foundation

class ApiDemoRequest: RequestType {
    
    typealias Response = ApiDemo
    
    var host: String { return "https://suggest.taobao.com/sug?code=utf-8&q=%E5%8D%AB%E8%A1%A3" }
}
