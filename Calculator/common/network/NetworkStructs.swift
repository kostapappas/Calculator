//
//  NetworkStructs.swift
//  Calculator
//
//  Created by LAMBROS KOSTAPAPPAS on 28/5/20.
//  Copyright © 2020 LAMBROS KOSTAPAPPAS. All rights reserved.
//

import Foundation

//Network
public struct ΝetworkAnswer<Τ: Codable>: Codable, BacisNetAnswer {
    let rates: Τ?
    public var success: Bool?
    public var timestamp: Double?
    public var base: String?
    public var date: String?
    public var error: NetError?
    
    func isSuccessfull() -> Bool {
        return self.success ?? false
    }
    
    func getCode() -> Int {
        return error?.code ?? -1000
    }
}

public protocol BacisNetAnswer {
    var success: Bool? { get set}
    var error: NetError? { get set}
}

public struct BaseAnswer: Codable, BacisNetAnswer {
    public var success: Bool?
    public var error: NetError?
}

public struct NetError: Codable {
    let code: Int
    let type: String
    let info: String
}

//networkManager Results
enum Result<Value: Codable> {
    case success(Value?)
    case failure(Error, Int)
}
