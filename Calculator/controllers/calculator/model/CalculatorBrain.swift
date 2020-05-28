//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by LAMBROS KOSTAPAPPAS on 28/5/20.
//  Copyright © 2020 LAMBROS KOSTAPAPPAS. All rights reserved.
//

import Foundation

protocol CalculatorActionDelegate: class {
    func screenUpdated(with text: String)
}

protocol Calculator: class {
    func input(text: String) -> String?
    var actionDelegate: CalculatorActionDelegate? { get set }
}

class SimpleCalculator: Calculator {
    
    enum CalcAction {
        case comma
        case addition
        case subtraction
        case multiplication
        case division
        //case Exponentiation
        
        static func factory(from: String) -> CalcAction? {
            switch from {
            case "+": return .addition
            case "-": return .subtraction
            case "/": return .division
            case "*": return .multiplication
            default : return nil
            }
        }
        
        func isComma() -> Bool {
            return self == .comma
        }
    }
    
    weak var actionDelegate: CalculatorActionDelegate?
    
    private var maxNumCharInput = 10
    private var outPutText =  "" {
        didSet {
            guard !outPutText.isEmpty else { return }
            actionDelegate?.screenUpdated(with: outPutText)
        }
    }
    private var previousInput = ""
    private var previousAction: CalcAction?
    private var currentAction: CalcAction? {
        didSet {
            guard let oldVal = oldValue else { return }
            if let newVal = currentAction, newVal.isComma() {
                previousAction = oldVal
            }
            
            if currentAction == nil && oldVal.isComma() {
                currentAction = previousAction
                previousAction = nil
            }
            
        }
    }
    private var lasActionWasCalculation = false
    private var isAddingNewNumber = false
    
    func input(text: String) -> String? {
        if text.isSingleNumber() {
            //handle single number
            if isAddingNewNumber {
                isAddingNewNumber = false
                //save number to second  variable
                previousInput = outPutText
                outPutText = ""
            }
            return handleInput(number: text)
        } else  if text == "," {
            //hanlde comma
            handleInput(coma: text) //todo improve for localization
        } else if  text == "=" {
            //calculate
            return calculateNow()
        } else {
            //action
            return handleInput(action: text)
        }
        return nil
    }
    
    private func handleInput(number: String) -> String? {
        //number
        //avoid to long input
        if lasActionWasCalculation {
            lasActionWasCalculation = false
            if currentAction == nil {
                previousInput = ""
            }
            outPutText = ""
        }
        guard outPutText.count <= maxNumCharInput else { return nil}
        //avoid zero entry
        if outPutText == "0" && number != "0" {
            outPutText = ""
        }
        //handle , if previous pressed
        var newOutputText = "\(outPutText)\(number)"
        if let action = currentAction, action == .comma {
            newOutputText = "\(outPutText).\(number)"
            currentAction =  nil
        }
        if newOutputText.hasMoreThanOneZeroAtBeggining() {
            newOutputText = "0"
        }
        outPutText = newOutputText
        return outPutText
    }
    
    private func handleInput(coma: String) {
        if !outPutText.hasAllreadyOneComma() {
            currentAction = .comma
        }
    }
    
    private func handleInput(action: String) -> String? {
        guard let action = CalcAction.factory(from: action) else { return nil}
        if lasActionWasCalculation {
            lasActionWasCalculation = false
            previousInput = ""
        }
        if let currentActn = currentAction, currentActn.isComma() {
            currentAction = nil
        }
        if currentAction != nil {
            return  calculateNow(keepThatAction: action)
        } else {
            currentAction = action
            return calculateNow()
        }
        
    }
    
    private func calculateNow(keepThatAction: CalcAction? = nil) -> String? {
        
        guard let action = currentAction else { return nil }
        guard !outPutText.isEmpty && !previousInput.isEmpty else {
            isAddingNewNumber = true
            return nil
        }
        guard
            let variableA = Double(previousInput),
            let variableB = Double(outPutText) else { return nil}
        
        var result = 0.0
        
        switch action {
        case .addition:
            result = variableA + variableB
        case .subtraction:
            result = variableA - variableB
        case .division:
            result = variableA / variableB
        case .multiplication:
            result = variableA * variableB
        case .comma:
            break
        }
        
        //reset
        currentAction = keepThatAction
        outPutText = result.strWithoutZeroesAtEnd()
        previousInput = outPutText
        lasActionWasCalculation = true
        return outPutText
    }
}
