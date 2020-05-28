//
//  NetworkStructs.swift
//  Calculator
//
//  Created by LAMBROS KOSTAPAPPAS on 28/5/20.
//  Copyright © 2020 LAMBROS KOSTAPAPPAS. All rights reserved.
//
// swiftlint:disable cyclomatic_complexity

import UIKit
import Alamofire

private let noDataReturnError =
    NSError(domain: "", code: 0,
            userInfo: [NSLocalizedDescriptionKey: "Data was not retrieved from request"]) as Error
public let unknownError =
    NSError(domain: "", code: 9999999,
            userInfo: [NSLocalizedDescriptionKey: "Unknown error"]) as Error
public let serverError =
    NSError(domain: "", code: 9999999,
        userInfo: [NSLocalizedDescriptionKey: "Server error"]) as Error
public let universalErrorDontDoNothing =
    NSError(domain: "", code: 55555555,
            userInfo: [NSLocalizedDescriptionKey: "Universal error, dont do nothing, is handled from other thread"]) as Error
public let notInternet = NSError(domain: "",
                                 code: 4444,
                                 userInfo: [NSLocalizedDescriptionKey: ""]) as Error

protocol APIprotocol {
    func factoryRequest() -> URLRequest
    var getParametrs: [String: String] { get }
    var headers: [String: String] { get }
    var jsonParameters: [String: Any] { get } //json parameteres
}

class NetworkManager {
    static let shared = NetworkManager()
    
    enum StatusCode: Int {
        case success = 200
        case resourceDoesNotExist = 404
        case noAPIKeySpecified = 101
        case endpointDoesNotExist = 103
        case maximumAllowedAPIRequestsReached = 104
        case subscriptionNotSupportThisAPI = 105
        case noResultForThisRequest = 106
        case inactiveAPI = 102
        case invalidBaseCurrency = 201
        case invalidSymbolsSpecified = 202
        case noDateSpecified = 301
        case invalidDateSpecified = 302
        case invalidAmount = 403
        case invalidTimeFrame = 501
        case invalidStartDate = 502
        case invalidEnddate = 503
        case invalidTimeframe = 504
        case tooLongTimeFrame = 505
        
        func getDescription() -> String {
            switch self.rawValue {
            case 200: return "Succesfull request."
            case 404: return "The requested resource does not exist."
            case 101: return "No API Key was specified or an invalid API Key was specified."
            case 103: return "The requested API endpoint does not exist."
            case 104: return "The maximum allowed API amount of monthly API requests has been reached."
            case 105: return "The current subscription plan does not support this API endpoint."
            case 106: return "The current request did not return any results."
            case 102: return "The account this API request is coming from is inactive"
            case 201: return "An invalid base currency has been entered."
            case 202: return "One or more invalid symbols have been specified."
            case 301: return "No date has been specified. [historical]"
            case 302: return "An invalid date has been specified. [historical, convert]"
            case 403: return "No or an invalid amount has been specified. [convert]"
            case 501: return "No or an invalid timeframe has been specified. [timeseries]"
            case 502: return "No or an invalid start_date has been specified. [timeseries, fluctuation]"
            case 503: return "No or an invalid end_date has been specified. [timeseries, fluctuation]"
            case 504: return "An invalid timeframe has been specified. [timeseries, fluctuation]"
            case 505: return "The specified timeframe is too long, exceeding 365 days. [timeseries, fluctuation]"
            default: return ""
            }
        }
    }
    
    public var debug: Bool = false
    
    private var uploadRequest: Request?
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    private var expiredTokenTries = 0
    
    public func getJson<T: Codable> (from api: FixerAPI, completion: ((Result<T>) -> Void)?) {
        guard Connectivity.isConnectedToInternet else {
            completion?(.failure(notInternet, 4444))
            print("***** user dont have internet connection \n\(api.factoryRequest()) getparams"
            + "\(api.getParametrs) \nheaders \(api.headers)\n params \(api.jsonParameters)")
            return
        }
        print("***** call \n\(api.factoryRequest()) getparams"
            + "\(api.getParametrs) \nheaders \(api.headers)\n params \(api.jsonParameters)")

        let lastSearchTask = AF.request(api.factoryRequest())
        
        lastSearchTask.responseData { [weak self] (response) in
            let responseDataN = response.data
            let responseN = response.response
            let errorN = response.error
            
            self?.debugNetworkCall(data: responseDataN, response: responseN, error: errorN)
            
            guard errorN == nil else {
                completion?(.failure(errorN!, 4444))
                return
            }

            guard let jsonData = responseDataN else {
                completion?(.failure(noDataReturnError, 0))
                return
            }
            
            //try to selialize Data
            do {
                let decoder = JSONDecoder()
                
                //check for errors
                let netAnswer = try decoder.decode(BaseAnswer.self,
                                                   from: jsonData)
                
                if let netError = netAnswer.error {
                    guard !(self?.doActionsFor(errorCode: netError.code) ?? true)  else {
                        completion?(.failure(universalErrorDontDoNothing, 55555555))
                        return
                    }
                    let errorText = netError.info
                    let error  = self?.customError(description: errorText) ?? unknownError
                    completion?(.failure(error, netError.code))
                    return
                }
                
                let responseCode = response.response?.code ?? 9999
                if  (responseCode) != 200 {
                    let errorText = StatusCode(rawValue: responseCode)?.getDescription() ?? ""
                    let serverError =
                        NSError(domain: errorText,
                                code: responseCode,
                        userInfo: [NSLocalizedDescriptionKey: errorText]) as Error
                    completion?(.failure((serverError), responseCode))
                    return
                }
                //check for data
                let tOBject = try decoder.decode(T.self,
                                                   from: jsonData)
                completion?(.success(tOBject))
                return
            } catch let error {
                let bodyerror = String(data: jsonData, encoding: String.Encoding.utf8) ??  ""
                print("serialization error\(bodyerror)-  \(error)")
                let error  = NSError(domain: "",
                                     code: 4444,
                                     userInfo: [NSLocalizedDescriptionKey: " ** error\n \(bodyerror)"]) as Error
                completion?(.failure(error, 9999999))
            }
        }
    }
    
    func customError(description: String) -> Error {
        return NSError(domain: "Custom Error",
                code: 99999,
                userInfo: [NSLocalizedDescriptionKey: description]) as Error
    }
    
    func doActionsFor(errorCode: Int) -> Bool {
        switch errorCode {
        case ApiError.expiredToken.rawValue,
             ApiError.invalidToken.rawValue,
             ApiError.unAuthorizedToken.rawValue:
            return true
        default:
            return false
        }
    }
    
    func checkAnswerStatus(statusCode: Int, reason: String) {
        //
    }
    
    /*onCompletion (progress percent, error string) */
    
    func cancelUpload() {
        self.uploadRequest?.cancel()
    }
    
   /*onCompletion (progress percent, error string) */
    final func debugNetworkCall(data: Data?, response: URLResponse?, error: Error?) {
        let code = response?.code ?? 9999
        let urlStr = response?.urlStr ?? ""
        let errorStr = error?.str ?? ""
        var body = ""
        if let myData = data {
            body = String(data: myData, encoding: String.Encoding.utf8) ?? ""
        }
        if code >= 400 {
            self.log(str: "ERROR - \(code) \(urlStr)\n\(errorStr)\n\(body)")
        } else {
            self.log(str: "\(code) \(urlStr)\n\(errorStr)\n\(body)")
        }
    }
}

extension NetworkManager {
    func log(str: String) {
        print("*** \(str)")
    }
}

extension URLResponse {
    var code: Int {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return 9999
    }
    
    var urlStr: String {
        return self.url?.debugDescription ?? ""
    }
    
}

fileprivate extension Error {
    var str: String {
        return self.localizedDescription
    }
}

enum ApiError: Int {
    case invalidToken = 403001
    case expiredToken = 403002
    case unAuthorizedToken = 403003
}
