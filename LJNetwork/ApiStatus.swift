//
//  ApiStatus.swift
//  LJNetwork
//
//  Created by manajay on 2018/3/8.
//  Copyright © 2018 manajay. All rights reserved.
//

import Foundation
import SwiftyJSON

let STATUS_KEY    = "status"
let MESSAGE_KEY   = "message"


struct ApiStatus {
    var message: String
    var code: Int
    
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
    init() {
        self.code = 500
        self.message = "服务器出问题了"
    }
}

extension ApiStatus: Decodable {
    static func parse(data: Data) -> ApiStatus? {
        var status = ApiStatus()
        do {
            let json = try JSON(data: data)
            let message = json[MESSAGE_KEY].stringValue
            let code = json[STATUS_KEY].intValue
            status.message = message
            status.code = code
        } catch let error {
            toLog("json parse error: \(error)")
        }
        return status
    }
}
