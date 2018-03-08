//
//  CommonClient.swift
//  LJNetwork
//
//  Created by manajay on 2017/2/17.
//  Copyright © 2017年 manajay. All rights reserved.
//

import UIKit

class Client: ClientType {
    private var client: Client = new Client()
    static func share(){
        return client
    }
}
