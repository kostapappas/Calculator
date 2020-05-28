//
//  BackendProxy.swift
//  Calculator
//
//  Created by LAMBROS KOSTAPAPPAS on 28/5/20.
//  Copyright © 2020 LAMBROS KOSTAPAPPAS. All rights reserved.
//

import UIKit
import Alamofire

public class Backend {
    
    private var networkManager: NetworkManager {
        let netManag = NetworkManager.shared
        netManag.debug = true
        return netManag
    }
    
    func getSettings(completion: @escaping (ΝetworkAnswer<[String: Double]>?, String, Int?) -> Void) {
        let api = FixerAPI.latest
        let handleNetworkCompletion = self.factoryTheHandleCompletion(completion: completion)
        networkManager.getJson(from: api,
                               completion: handleNetworkCompletion)
    }
    
}

extension Backend {
    fileprivate func factoryTheHandleCompletion <T: Codable> (
        completion: @escaping (T?, String, Int?) -> Void) -> (Result<T>) -> Void {
        let handleCompletion: (Result<T>) -> Void = { (netResponse) in
            switch netResponse {
            case .failure(let error, let errorCode):
                self.log("------------ KRSAPI Log ERROR (code:\(errorCode) ------------\n\(error)\n---------------------------------------")
                completion(nil, error.localizedDescription, errorCode)
            case .success(let decodedAnswer):
                completion(decodedAnswer, "", nil)
            }
        }
        return handleCompletion
    }
    
    func log(_ str: String) {
        print("------------ KRSAPI Log ------------\n\(str)\n---------------------------------------")
    }
}
