//
//  ApiDemoRequest.swift
//  LJNetwork
//
//  Created by manajay on 2018/3/7.
//  Copyright © 2018 manajay. All rights reserved.
//

import Foundation

class ApiDemoRequest {
    
    var type: Kuaidi
    var postid: String
    
    init(type: Kuaidi, postid: String) {
        self.type = type
        self.postid = postid
    }
}

enum Kuaidi: String {
    case shentong = "shentong"
    case ems = "ems"
    case shunfeng = "shunfeng"
    case yuantong = "yuantong"
    case zhongtong = "zhongtong"
    case yunda = "yunda"
    case tiantian = "tiantian"
    case huitongkuaidi = "huitongkuaidi"
    case quanfengkuaidi = "quanfengkuaidi"
    case debangwuliu = "debangwuliu"
    case zhaijisong = "zhaijisong"
}

extension ApiDemoRequest: RequestType {
    
    typealias Response = Express
    typealias Status = ApiStatus
    
    var host: String { return "http://www.kuaidi100.com/" }
    var path: String {return "query?type=\(type.rawValue)&postid=\(postid)"}
}
