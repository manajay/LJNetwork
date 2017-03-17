//
//  HttpResponseHandler.swift
//  LiveShowSwift
//
//  Created by ljduan on 2016/11/9.
//  Copyright © 2016年 manajay. All rights reserved.
//

import Foundation
import SwiftyJSON


let STATUS_CODE_SUCCESS = 200

let RESULT_KEY    = "result"
let STATUS_KEY    = "status"
let MESSAGE_KEY   = "message"


let listKey      = "list"


/// 处理结果的回调, 成功与否, 返回信息
typealias HandleResultTuples = (isSuccess:Bool, message:String)

typealias ResponseTuples = (isSuccess:Bool, result:[String: Any], message:String)
typealias JsonResponseTuples = (statusCode: Int, message: String ,result:JSON)

class ResponseHandler {
    
    class func handleResponse(response:([AnyHashable:Any])?) -> ResponseTuples{
        
        // 在 Swift 中任何 AnyObject 在使用前，必须转换类型 -> as ?/! 类型
        // 解析服务器数据
        guard let message = response?[MESSAGE_KEY] as? String ,
            let statusCode = response?[STATUS_KEY] as? Int
            else {
            return (false,[:],SERVICE_EERROR)
        }
        
        //失败状态码
        if statusCode != STATUS_CODE_SUCCESS {
            return (false,[:],message)
        }
        
        // 成功状态码的判断 有三种情况,
        
        // 1. 没有 result 字段
        
        let result = response?[RESULT_KEY]
        
        if result  == nil{
            return (true,[:],message)
        }
        
        // 1.2 有 result 字段, 值为 字典
        if let res = result as? [String:Any] {
            return (true,res,message)
        }
        
        if let r = result {
            return (true,[listKey:r],message)
        }
        
        return (false,[:],SERVICE_EERROR)
    }
    
}

extension ResponseHandler {

    class func parse(_ data: Data ) -> JsonResponseTuples{
          
      let json = JSON(data: data)
      
      let message = json[MESSAGE_KEY].stringValue
      let statusCode = json[STATUS_KEY].intValue
      let result = json[RESULT_KEY]
      
      return (statusCode, message, result)

    }
 
  
}
