//
//  ApiRouter.swift
//  LJNetwork
//
//  Created by manajay on 2016/12/21.
//  Copyright © 2016年 manajay. All rights reserved.
//

import UIKit
import Alamofire

enum Router: URLRequestConvertible {
    
    static let baseURLString = "https://api.500px.com/v1"
    static let consumerKey = "HVhSQ8stAClpTASwePsvjFurYn1P3wo7XMPLyWPt"
    
    case popularPhotos(Int)
    case photoInfo(Int, ImageSize)
    case comments(Int, Int)
    
    var method: HTTPMethod {
        switch self {
        case .popularPhotos:
            return .post
        case .photoInfo:
            return .get
        case .comments:
            return .put
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case .popularPhotos(let page):
                let params = ["consumer_key": Router.consumerKey, "page": "\(page)", "feature": "popular", "rpp": "50",  "include_store": "store_download", "include_states": "votes"]
                return ("/photos", params)
            case .photoInfo(let photoID, let imageSize):
                let params = ["consumer_key": Router.consumerKey, "image_size": "\(imageSize.rawValue)"]
                return ("/photos/\(photoID)", params)
            case .comments(let photoID, let commentsPage):
                let params = ["consumer_key": Router.consumerKey, "comments": "1", "comments_page": "\(commentsPage)"]
                return ("/photos/\(photoID)/comments", params)
            }
        }()
        
        let url = try Router.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        urlRequest.httpMethod = method.rawValue
        
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
}

enum ImageSize: Int {
    case tiny = 1
    case small = 2
    case medium = 3
    case large = 4
    case xLarge = 5
}
