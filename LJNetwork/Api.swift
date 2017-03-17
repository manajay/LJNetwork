//
//  Api.swift
//  LiveShowSwift
//
//  Created by manajay on 18/01/2017.
//  Copyright © 2017 manajay. All rights reserved.
//

import Foundation

struct Api {
  //版本
  static let kAppVersion = "1.8.1"
  
  // MARK: - 接口 API 相关
  // 接口 API 相关  ************************************************
  
//
    #if DEBUG
      static let BASE_URL          = "http://com.xxx/api/v\(kAppVersion)/"
    #else
      static let BASE_URL          = "https://test.xxx/api/v\(kAppVersion)/"
    #endif

  
  // 地图
  static let LOGIN         = "login.php"
  static let LOGOUT          = "logout.php"
 


  
  
}
