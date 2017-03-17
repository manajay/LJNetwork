//
//  RequestBehavior.swift
//  LJNetwork
//
//  Created by manajay on 06/03/2017.
//  Copyright © 2017 manajay. All rights reserved.
//

import UIKit

// 解耦不同的网络行为
protocol RequestBehavior {
  
  var additionalHeaders: [String: String] { get }
  
  func beforeSend()
  
  func afterSuccess(result: Any)
  
  func afterFailure(error: Error)
  
}

extension RequestBehavior {
  
  var additionalHeaders: [String: String] {
    return [:]
  }
  
  func beforeSend() {
    
  }
  
  func afterSuccess(result: Any) {
    
  }
  
  func afterFailure(error: Error) {
    
  }
  
}

/**
 http://swift.gg/2017/02/16/request-behaviors/#more
 基本思想是每个行为在特定的网络事件发生时获得回调函数，并且可以执行回调中的代码。当我们开发这个功能时，定义两个辅助对象：一个“空”的请求行为，不做任何事情，一个组合了许多请求行为的请求行为。“空”行为继承了协议扩展中的所有实现，“组合”行为存储一个行为数组，并对每个行为调用相关的方法：
 */

struct EmptyRequestBehavior: RequestBehavior { }

struct CombinedRequestBehavior: RequestBehavior {
  
  let behaviors: [RequestBehavior]
  
  var additionalHeaders: [String : String] {
    
    return behaviors.reduce([String: String](), { sum, behavior in
      return sum.merged(with: behavior.additionalHeaders) // 合并字典
    })
  }
  
  func beforeSend() {
    behaviors.forEach({ $0.beforeSend() })
  }
  
  func afterSuccess(result: Any) {
    behaviors.forEach({ $0.afterSuccess(result: result) })
  }
  
  func afterFailure(error: Error) {
    behaviors.forEach({ $0.afterFailure(error: error) })
  }
}


extension Dictionary {
  
  mutating func merge(with dictionary: Dictionary) {
    dictionary.forEach { updateValue($1, forKey: $0) }
  }
  
  func merged(with dictionary: Dictionary) -> Dictionary {
    var dict = self
    dict.merge(with: dictionary)
    return dict
  }
}



