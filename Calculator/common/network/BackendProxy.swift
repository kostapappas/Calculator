//
//  BackendProxy.swift
//  Calculator
//
//  Created by LAMBROS KOSTAPAPPAS on 28/5/20.
//  Copyright © 2020 LAMBROS KOSTAPAPPAS. All rights reserved.
//

import UIKit
import Alamofire

public class FixedProxyAPI {
    
    private var networkManager: NetworkManager {
        let netManag = NetworkManager.shared
        netManag.debug = true
        return netManag
    }
    
    func getLatest(baseTxt: String,
                   completion: @escaping (ΝetworkAnswer<[String: Double]>?, String, Int?) -> Void) {
        let api = FixerAPI.latest(base: baseTxt)
        let handleNetworkCompletion = self.factoryTheHandleCompletion(completion: completion)
        networkManager.getJson(from: api,
                               completion: handleNetworkCompletion)
    }
    
}

extension FixedProxyAPI {
    fileprivate func factoryTheHandleCompletion <T: Codable> (
        completion: @escaping (T?, String, Int?) -> Void) -> (Result<T>) -> Void {
        let handleCompletion: (Result<T>) -> Void = { (netResponse) in
            switch netResponse {
            case .failure(let error, let errorCode):
                self.log("------------ Calculator Log ERROR (code:\(errorCode) ------------\n\(error)\n---------------------------------------")
                completion(nil, error.localizedDescription, errorCode)
            case .success(let decodedAnswer):
                completion(decodedAnswer, "", nil)
            }
        }
        return handleCompletion
    }
    
    func log(_ str: String) {
        print("------------ Calculator Log ------------\n\(str)\n---------------------------------------")
    }
}
