//
//  ErrorHandler.swift
//  LJNetwork
//
//  Created by manajay on 2016/11/9.
//  Copyright © 2016年 manajay. All rights reserved.
//

class ErrorHandler{
    
    class func errorHandle(error:Error?) -> Bool{
        guard let err = error else {
            return false
        }
        toLog( "网络访问错误日志:\(err)")
        return true
    }
}
