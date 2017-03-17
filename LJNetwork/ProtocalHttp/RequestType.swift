//
//  RequestType.swift
//  LiveShowSwift
//
//  Created by manajay on 2016/12/22.
//  Copyright © 2016年 manajay. All rights reserved.
//

import UIKit

public enum HttpMethod: String,CustomStringConvertible {
  
  case get     = "GET"
  case post    = "POST"
  case options = "OPTIONS"
  case head    = "HEAD"
  case put     = "PUT"
  case patch   = "PATCH"
  case delete  = "DELETE"
  case trace   = "TRACE"
  case connect = "CONNECT"
  
  public var description: String {
    return self.rawValue
  }
}

protocol RequestType {
  
  associatedtype Response: Decodable
  
  var path: String {get}
  
  // 组合request 的 路径
  var host :String {get}
  
  var method:HttpMethod {get}
  
  var parameters: [String: Any]? {get}
  
  var headers: [String: String]? {get}
  
  var commonHeaders: [String: String]? {get}
  
  var timeout: TimeInterval {get}
  
  // 定义task执行线程的 标签名称
  var queueIdentifier: String {get}
  
  //定义一个 确定 parameters 参数位置的 属性
  var encodingDestination: EncodingDestination {get}
  //    var encodesParametersInURL: Bool {get}
}

extension RequestType {
  
  var method: HttpMethod {return .get}
  
  var host :String {return Api.BASE_URL}
  
  var parameters: [String: Any]? {return nil}
  
  var headers: [String: String]? {return nil}
  
  var commonHeaders: [String: String]? {return nil}
  
  var timeout: TimeInterval {return 15}
  
  var queueIdentifier: String {return "com.manajay.globalQueue"}
  
  var encodingDestination: EncodingDestination {return .methodDependent}
  //    var encodesParametersInURL: Bool {
  //
  //        switch method {
  //        case .get, .head, .delete:
  //            return true
  //        default:
  //            return false
  //        }
  //    }
}
