//
//  Client.swift
//  LJNetwork
//
//  Created by manajay on 2016/12/20.
//  Copyright © 2016年 manajay. All rights reserved.
//

import UIKit
import Alamofire

enum NetworkMessage <T: RequestType>{
    case Sucess(response: T.Response?, status: T.Status?)
    case Failure(error: Error)
}

typealias Handler<T: RequestType> = (_ message: NetworkMessage<T>) -> Void

protocol ClientType {
    
    var manager: HttpManager? {get}
    
    //因为 Request 是含有关联类型的协议，所以它并不能作为独立的类型来使用，我们只能够将它作为类型约束，来限制输入参数 request
    @discardableResult
    func send<T: RequestType>(_  req: T, _ moreInfo:@escaping  ((_ message: NetworkMessage<T>) -> Void)) -> JobRequest?
    
    
    func upload<T: MultiUploadRequestType>(_  req: T, _  moreInfo: @escaping ((_ message: NetworkMessage<T>) -> Void))
    
}

extension ClientType {
    
    weak var manager: HttpManager? {return HttpManager.share}
    
    @discardableResult
    func send<T: RequestType>(_  req: T, _ moreInfo: @escaping ((_ message: NetworkMessage<T>) -> Void)) -> JobRequest?
    {
        
        return manager?.send(req, request: ParaURLEncoding(destination: req.encodingDestination).buildRequest(req), moreInfo)
    }
    
    
    func upload<T: MultiUploadRequestType>(_  req: T, _  moreInfo: @escaping ((_ message: NetworkMessage<T>) -> Void)) {
        
        manager?.upload(req, request: ParaURLEncoding(destination: req.encodingDestination).buildRequest(req), moreInfo)
    }
    
}
