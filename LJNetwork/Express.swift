//
//  Express.swift
//  LJNetwork
//
//  Created by manajay on 2018/3/7.
//  Copyright © 2018 manajay. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Express {
    let com: String
    let state: Int
    let data: Array<ExpressNode>
}

extension Express: Decodable{
    static func parse(data: Data) -> Express? {
        
        do {
            let rawdata = try JSON(data: data)
            let arr = rawdata["data"].arrayValue
            var data = Array<ExpressNode>()

            for node in arr {
                let expressNode =  ExpressNode(time: node["time"].stringValue, ftime: node["ftime"].stringValue, context: node["context"].stringValue, location: node["location"].stringValue)
                data.append(expressNode)
            }
            
            return Express(com: rawdata["com"].stringValue, state: rawdata["state"].intValue, data: data)
        } catch let error {
            toLog("error: \(error)")
        }
        return nil
    }
}

extension Express: CustomDebugStringConvertible {
    var debugDescription: String {
        return "公司: \(com), 状态: \(state), 物流详情: \(data)"
    }
}
