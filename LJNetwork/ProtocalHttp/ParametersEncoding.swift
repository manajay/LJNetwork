//
//  ParametersEncoding.swift
//  LiveShowSwift
//
//  Created by manajay on 2016/12/26.
//  Copyright © 2016年 manajay. All rights reserved.
//

import Foundation
import Alamofire

protocol ParametersEncoding {
  func buildRequest<T: RequestType>(_ req: T) -> URLRequest
}

// MARK: Helper Types

/// Defines whether the url-encoded query string is applied to the existing query string or HTTP body of the
/// resulting URL request.
///
/// - methodDependent: Applies encoded query string result to existing query string for `GET`, `HEAD` and `DELETE`
///                    requests and sets as the HTTP body for requests with any other HTTP method.
/// - queryString:     Sets or appends encoded query string result to existing query string.
/// - httpBody:        Sets encoded query string result as the HTTP body of the URL request.
enum EncodingDestination {
  case methodDependent, queryString, httpBody
}

struct ParaURLEncoding:ParametersEncoding {
  
  
  
  
  // MARK: Properties
  
  /// Returns a default `URLEncoding` instance.
  public static var `default`: ParaURLEncoding { return ParaURLEncoding() }
  
  /// Returns a `URLEncoding` instance with a `.methodDependent` destination.
  public static var methodDependent: ParaURLEncoding { return ParaURLEncoding() }
  
  /// Returns a `URLEncoding` instance with a `.queryString` destination.
  public static var queryString: ParaURLEncoding { return ParaURLEncoding(destination: .queryString) }
  
  /// Returns a `URLEncoding` instance with an `.httpBody` destination.
  public static var httpBody: ParaURLEncoding { return ParaURLEncoding(destination: .httpBody) }
  
  /// The destination defining where the encoded query string is to be applied to the URL request.
  public let destination: EncodingDestination
  
  // MARK: Initialization
  
  /// Creates a `URLEncoding` instance using the specified destination.
  ///
  /// - parameter destination: The destination defining where the encoded query string is to be applied.
  ///
  /// - returns: The new `URLEncoding` instance.
  public init(destination: EncodingDestination = .methodDependent) {
    self.destination = destination
  }
 
  
}

extension ParaURLEncoding {
  
  // 创建request
  func buildRequest<T: RequestType>(_  req: T) -> URLRequest
  {
    
    let urlString =  req.host + req.path
    guard let url = URL(string: urlString) else { fatalError("无效的URL") }
    
    var request = URLRequest(url: url, timeoutInterval: req.timeout)  //, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData
    request.httpMethod = req.method.rawValue
    
    // 请求头
    if let headers = req.headers {
      for (headerField, headerValue) in headers {
        request.setValue(headerValue, forHTTPHeaderField: headerField)
      }
    }
    
    var urlEncoding = URLEncoding.default
    switch req.encodingDestination {
    case .httpBody:
      urlEncoding = .httpBody
    case .queryString:
      urlEncoding = .queryString
    default:
      urlEncoding = .methodDependent
    }
    
    return try! urlEncoding.encode(request, with: req.parameters)
  }

}
