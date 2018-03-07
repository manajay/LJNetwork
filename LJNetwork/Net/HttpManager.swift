//
//  HttpManager.swift
//  HttpManager
//
//  Created by manajay on 2016/11/17.
//  Copyright © 2016年 manajay. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import ReachabilitySwift

enum NetworkStatus:Int {
    case  unknown = -1 ;case notReachable = 0; case wwan = 1; case wifi = 2
}

enum MimeType:String {
    case jpeg = "image/jpeg" ; case png = "image/png" ; case mp4 = "video/mp4"
}

// 网络
let SERVICE_EERROR = "服务器出现故障"
let URL_ERROR = "地址错误"
let NET_ERROR = "网络连接中断或出现错误"
let DATA_ERROR = "网络数据出错"


typealias JobRequest = DataRequest

private let WWANAuthoriedKey = "WWANAuthoriedKey"

private let netError = NSError(domain: NSCocoaErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey : "无网络连接"])

class HttpManager {
  
  private static let privateManager = HttpManager()
  
  class var share :HttpManager{
    return privateManager
  }
  
  private init() {
    setupReachability(nil, useClosures: true)
  }
  
  /***************************************************************/
  
  var isWWANAuthoried = false
  
  var debugStatus = false

  var netStatus:NetworkStatus = .wifi
  
  var dataRequests:[String: JobRequest] = [:]
  
  var reachability: Reachability?
  
}

// MARK: - 网络状态
extension HttpManager {

  fileprivate func setupReachability(_ hostName: String?, useClosures: Bool) {
    
    let reach = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
    reachability = reach
    
    if useClosures {
      reachability?.whenReachable = { reachability in
        DispatchQueue.main.async {
          self.updateLabelColourWhenReachable(reachability)
        }
      }
      reachability?.whenUnreachable = { reachability in
        DispatchQueue.main.async {
          self.updateLabelColourWhenNotReachable(reachability)
        }
      }
    } else {
      NotificationCenter.default.addObserver(self, selector: #selector(HttpManager.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
    }
  }
  
  func startNotifier() {
    do {
      try reachability?.startNotifier()
    } catch {
      return
    }
  }
  
  func stopNotifier() {
    reachability?.stopNotifier()
    NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
    reachability = nil
  }
  
  fileprivate func updateLabelColourWhenReachable(_ reachability: Reachability) {
    if reachability.isReachableViaWiFi {
      netStatus = .wifi
    } else {
      netStatus = .wwan
    }
    
  }
  
  fileprivate func updateLabelColourWhenNotReachable(_ reachability: Reachability) {
    netStatus = .notReachable
  }
  
  
  @objc fileprivate func reachabilityChanged(_ note: Notification) {
    
    let reachability = note.object as! Reachability
    if reachability.isReachable {
      updateLabelColourWhenReachable(reachability)
    } else {
      updateLabelColourWhenNotReachable(reachability)
    }
  }
    
    fileprivate func initWwanNotification()  {
        isWWANAuthoried = UserDefaults.standard.bool(forKey: WWANAuthoriedKey)
    }
    
    func resetWwanNotification(isAuthoried:Bool) {
        isWWANAuthoried = isAuthoried
        UserDefaults.standard.set(isAuthoried, forKey: WWANAuthoriedKey)
    }
    
    
}


// MARK: - session
extension HttpManager {
  
  fileprivate func setSessionManager () {
    
//    let configuration = URLSessionConfiguration.default
//    let sessionManager = Alamofire.SessionManager(configuration: configuration)

    /**
     var defaultHeaders = Alamofire.SessionManager.default.defaultHTTPHeaders
     defaultHeaders["DNT"] = "1 (Do Not Track Enabled)"
     
     let configuration = URLSessionConfiguration.default
     configuration.httpAdditionalHeaders = defaultHeaders
     
     let sessionManager = Alamofire.SessionManager(configuration: configuration)
     */
    
  
  }
}

extension HttpManager {
    
    @discardableResult
    func send<T: RequestType >(_ req: T ,request: URLRequest ,success: @escaping ResponseSuccess<T> , failure: @escaping ResponseFailure ) -> JobRequest?{
      
      guard netStatus != .notReachable else {
        DispatchQueue.main.async {
          failure(netError)
        }
        return nil
      }
      
        // 管理请求
        let identifier = request.hashValue
        
        toLog("paras :\(req.parameters ?? ["": ""]) URI: \(req.host) path: \(req.path) ")

      
        /**
         ## DispatchQueue.AutoreleaseFrequency
         - inherit：不确定，之前默认的行为也是现在的默认值
         - workItem：为每个执行的项目创建和排除自动释放池,项目完成时清理临时对象
         - never：GCD不为您管理自动释放池
         
         */
        
        let label = req.queueIdentifier + "\(identifier)"
        
        let queue = DispatchQueue(label: label, qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        let handler: ((Alamofire.DataResponse<Any>) -> Void) = {
            response in

            guard let data = response.data else {
                let error = response.result.error!
                toLog(error)
                DispatchQueue.main.async {
                    failure(error)
                }
                return
            }
          
          //WARNING:   4G的时候 异步主线程回调 失败 , 直接略过了 黑人问号?
          DispatchQueue.main.async(execute: { 
            let (statusCode, message, json) = ResponseHandler.parse(data)
            toLog("网络解析json数据 :\(json) -- statusCode: \(statusCode) -- message: \(message) ")
            if message.isEmpty || statusCode == 0 {
              success(T.Response.parse(data: data), statusCode, DATA_ERROR, json)
            } else {
              success(T.Response.parse(data: data), statusCode, message, json)
            }
          })

          
        }
        
      
        let dataReq = Alamofire.request(request).responseJSON(queue: queue, options: JSONSerialization.ReadingOptions.allowFragments, completionHandler: handler)
        
        return dataReq
    }
  
  func upload<T: MultiUploadRequestType >(_ req: T ,request: URLRequest ,success: @escaping ResponseSuccess<T> , failure: @escaping ResponseFailure )  {
    
    guard netStatus != .notReachable else {
      DispatchQueue.main.async {
        failure(netError)
      }
      return
    }

    toLog("paras :\(req.parameters ?? ["": ""]) URI: \(req.host) path: \(req.path) ")

    
    let handler: ((Alamofire.DataResponse<Any>) -> Void) = {
      response in
      
      guard let data = response.data else {
        let error = response.result.error!
        DispatchQueue.main.async {
          failure(error)
        }
        return
      }
      
      DispatchQueue.main.async {
        
        let (statusCode, message, json) = ResponseHandler.parse(data)
        
        toLog("网络解析json数据 :\(json) -- statusCode: \(statusCode) -- message: \(message) ")
        if message.isEmpty || statusCode == 0 {
          success(T.Response.parse(data: data), statusCode, DATA_ERROR, json)
        } else {
          success(T.Response.parse(data: data), statusCode, message, json)
        }
        
      }
    }
    
    let encodingCompletion: (((Alamofire.SessionManager.MultipartFormDataEncodingResult) -> Void)?) = {
      encodingResult in
      switch encodingResult {
      case .success(let upload,  _, _):
        
        upload.uploadProgress(closure: { (progress) in
          toLog("上传的进度: \(Double(progress.completedUnitCount) / Double(progress.totalUnitCount))")
        }).responseJSON(completionHandler: handler)
        
      case .failure(let error):
        toLog(error)
      }
    }
    
    Alamofire.upload(multipartFormData: req.multipartFormDataBlock, with: request, encodingCompletion: encodingCompletion)
    
  }
  
    func cancelReq<T: RequestType>(with req: T)  {
        
        
        // key 
        var keyString = req.host + req.path
        
        if let parameters = req.parameters
        {
            
            for (key,value) in parameters
            {
                keyString = keyString + key + "\(value)"
            }
        }
        
        //
        for (key , dataReq) in dataRequests {
            if keyString == key {
                dataReq.cancel()
                dataRequests.removeValue(forKey: keyString)
                break
            }
        }
    
    }
    
}

