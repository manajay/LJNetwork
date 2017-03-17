//
//  MultiUploadRequestType.swift
//  LiveShowSwift
//
//  Created by manajay on 2016/12/30.
//  Copyright © 2016年 manajay. All rights reserved.
//

import UIKit
import Alamofire

// MARK: - 协议
protocol MultiUploadRequestType: RequestType {
  
  var multipartFormDataBlock: ((MultipartFormData) -> Void) {get}
  var datas: [FileData] {get}
}

extension MultiUploadRequestType {
  
  var method: HttpMethod {return .post}
  
  var multipartFormDataBlock: ((MultipartFormData) -> Void) {
    let block: ((MultipartFormData) -> Void) = {
      multipartFormData in
      
      for file in self.datas {
        multipartFormData.append(file.data, withName: file.name,fileName: file.filename, mimeType: file.mimeType.rawValue)
      }
      
      // 参数的拼接
      guard let parameters = self.parameters else { return }
      for (key,value) in parameters {
        if let data = "\(value)".data(using: .utf8) {
          multipartFormData.append(data, withName: key)
        }
      }
      
    }
    return block
  }
  
  var timeout: TimeInterval {return 60}

  
}

struct FileData {
  
  let data: Data
  let name: String
  let filename: String
  let mimeType: MimeType
  
  init(
   data: Data,
   name: String,
   filename: String,
   mimeType: MimeType) {
    self.data = data
    self.name = name
    self.filename = filename
    self.mimeType = mimeType
  }
}
