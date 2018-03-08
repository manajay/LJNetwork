//
//  CommonClient.swift
//  LJNetwork
//
//  Created by manajay on 2017/2/17.
//  Copyright © 2017年 manajay. All rights reserved.
//

import UIKit

class Client: ClientType {
    private static let client = Client()
    class var share: Client {
        return client
    }
    
    private init() {
    }
}
