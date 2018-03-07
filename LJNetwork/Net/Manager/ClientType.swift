//
//  Client.swift
//  LJNetwork
//
//  Created by manajay on 2016/12/20.
//  Copyright © 2016年 manajay. All rights reserved.
//

import UIKit
import Alamofire

typealias ResponseSuccess<T: RequestType> = (_ success: T.Response?, _ statusCode: Int, _ message: String , _ result: Any) -> Void
typealias ResponseFailure = (_ error: Error) -> Void

protocol ClientType {
    
    var manager: HttpManager? {get}
    
    //因为 Request 是含有关联类型的协议，所以它并不能作为独立的类型来使用，我们只能够将它作为类型约束，来限制输入参数 request
    //    func send<T: RequestType>(_ r: T, success: @escaping ResponseSuccess<T> , failure: @escaping ResponseFailure )
    @discardableResult
    func send<T: RequestType>(_  req: T, _  success: @escaping ResponseSuccess<T> , failure: @escaping ResponseFailure ) -> JobRequest?
    
    
    func upload<T: MultiUploadRequestType>(_  req: T, _  success: @escaping ResponseSuccess<T> , failure: @escaping ResponseFailure )
    
}

extension ClientType {
    
    weak var manager: HttpManager? {return HttpManager.share}
    
    @discardableResult
    func send<T: RequestType>(_  req: T, _ success: @escaping ResponseSuccess<T> , failure: @escaping ResponseFailure ) -> JobRequest?
    {
        
        return manager?.send(req, request: ParaURLEncoding(destination: req.encodingDestination).buildRequest(req), success: success, failure: failure)
    }
    
    
    func upload<T: MultiUploadRequestType>(_  req: T, _  success: @escaping ResponseSuccess<T> , failure: @escaping ResponseFailure ) {
        
        manager?.upload(req, request: ParaURLEncoding(destination: req.encodingDestination).buildRequest(req), success: success, failure: failure)
    }
    
}
