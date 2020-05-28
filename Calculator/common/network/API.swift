//
//  API.swift
//  Calculator
//
//  Created by LAMBROS KOSTAPAPPAS on 28/5/20.
//  Copyright © 2020 LAMBROS KOSTAPAPPAS. All rights reserved.
//

import UIKit

//url handling
private protocol Url {
    var url: URL { get }
}

private protocol Method {
    var method: String { get }
}

let baseURL =  "data.fixer.io"
let apiAccessKey =  "f3bc4b269910a2292a6d67a46d5a476b"

enum FixerAPI {
    case latest
   
    func factoryRequest() -> URLRequest {
        var request = URLRequest(url: self.url)
        request.httpMethod = self.method
        if !self.jsonParameters.isEmpty {
            request.httpBody = try? JSONSerialization.data(withJSONObject: self.jsonParameters)
        }
        request.allHTTPHeaderFields = self.headers
        return request
    }
}

extension FixerAPI: Method {
    var method: String {
        switch self {
        default : return "GET"
        }
    }
}

extension FixerAPI: Url, APIprotocol {
    var url: URL {
        switch self {
        case .latest:
            return createUrl(for: "/api/latest")
        }
    }
    
    var getParametrs: [String: String] {
        switch self {
        case .latest:
            return ["access_key": apiAccessKey]
        //default: return [:]
        }
    }
    
    private func createUrl(for text: String) -> URL {
        return self.factoryUrl(action: text,
                               postParameters: self.getParametrs)
    }
    
    //json body Parameters
    var jsonParameters: [String: Any] {
        switch self {
        /*case .getUserFiles(_, let pageSize, let page):
            return ["page_size": "\(pageSize)",
                "page": "\(page)",
                "order_by":"",
                "order_method": "",
                "token": token]
        */
        default: return [:]
        }
    }
    
    var headers: [String: String] {
        let lang = UIApplication.selectedLangStr
        let userAgent = UIApplication.getUserAgent
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""
        let buildVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? ""
        
        var contentType = ""
        switch self {
        /*case .somethingElseForUpload :
            contentType = "multipart/form-data"*/
        default:
            contentType = "application/json"
        }
        return ["Content-Type": contentType,
                "platform": "ios",
                "version": "\(appVersion) (\(buildVersion))",
                "Accept-Language": lang,
                "User-Agent": userAgent
                /*"authorization": "Token token=\()"*/]
    }
    
    fileprivate func factoryUrl (action: String,
                                 postParameters: [String: String],
                                 postParametersNotUnique: [(String, String)] = []) -> URL {
        let urlComponents = factoryDefaultURlComponent(action: action,
                                                       parameters: postParameters,
                                                       postParametersNotUnique: postParametersNotUnique)
        
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        return url
    }
    
    fileprivate func factoryDefaultURlComponent(action: String,
                                                parameters: [String: String],
                                                postParametersNotUnique: [(String, String)] = []) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http    "
        urlComponents.host = baseURL
        urlComponents.path = "\(action)"
        urlComponents.queryItems = []
        for parameter in parameters {
            let param = URLQueryItem(name: parameter.key,
                                     value: parameter.value)
            urlComponents.queryItems?.append(param)
        }
        for parameterNotUnique in postParametersNotUnique {
            let param = URLQueryItem(name: parameterNotUnique.0,
                                     value: parameterNotUnique.1)
            urlComponents.queryItems?.append(param)
        }
        
        return urlComponents
    }
}
