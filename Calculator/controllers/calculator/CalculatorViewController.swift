//
//  ViewController.swift
//  Calculator
//
//  Created by LAMBROS KOSTAPAPPAS on 25/5/20.
//  Copyright © 2020 LAMBROS KOSTAPAPPAS. All rights reserved.
//

import UIKit

final class CalculatorViewController: UIViewController {

    @IBOutlet weak var calculatorScreen: UILabel!
    @IBOutlet weak var calculatorView: CalculatorView!
    @IBOutlet weak var fromExchRateBtn: RoundButton!
    @IBOutlet weak var toExchRateBtn: RoundButton!
    @IBOutlet weak var exchangeContainer: UIView!
    @IBOutlet weak var exchAmountLabel: UILabel!
    
    fileprivate var isLoading = false
    fileprivate let backendAPI = FixedProxyAPI()
    fileprivate var calculatorBrain: Calculator =  SimpleCalculator()
    fileprivate var exchangeRates: [String: Double]?
    fileprivate var activeRate: Double = 1.0
    fileprivate var fromExchValue: Double = 0.0 {
        didSet {
            self.updateExchangeUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calculatorView.actionDelegate = self
        calculatorBrain.actionDelegate = self
        exchAmountLabel.text = "0.00"
    }
    
    func updateExchangeUI() {
        DispatchQueue.main.async {
            self.exchAmountLabel.text = "\(self.fromExchValue.strWithoutZeroesAtEnd())"
        }
    }
    
    @IBAction func fromExtRateBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func toExtRateBtnPressed(_ sender: Any) {
        guard let fromTxt = fromExchRateBtn.titleLabel?.text else { return }
        guard !isLoading else { return }
        isLoading = true
        backendAPI.getLatest(baseTxt: fromTxt) { [weak self] (netAnswer, error, _) in
            self?.isLoading = false
            if !error.isEmpty {
               print("***API Error -> \(error)")
            } else {
                if let results = netAnswer?.data {
                    self?.exchangeRates = results
                }
            }
        }
    }
}

extension CalculatorViewController: CalculatorActionDelegate {
    func screenUpdated(with text: String) {
        guard let newValue = Double(text) else { return }
        fromExchValue = newValue
        
    }
}

extension CalculatorViewController: CalculatorViewActionsDelegate {
    func buttonPressed(text: String) {
        guard let screenText = calculatorBrain.input(text: text) else { return }
        //update screen
        calculatorScreen.text = screenText
    }
}
