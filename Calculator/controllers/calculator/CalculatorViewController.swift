//
//  ViewController.swift
//  Calculator
//
//  Created by LAMBROS KOSTAPAPPAS on 25/5/20.
//  Copyright © 2020 LAMBROS KOSTAPAPPAS. All rights reserved.
//

import UIKit
import SwiftyPickerPopover

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
    fileprivate var selectedToBase = "EUR" {
        didSet {
            toExchRateBtn.setTitle(selectedToBase, for: .normal)
        }
    }
    
    fileprivate var selectedFromBase = "EUR" {
        didSet {
            fromExchRateBtn.setTitle(selectedFromBase, for: .normal)
        }
    }
    
    fileprivate var exchangeRatesArray: [String] {
        return Array(exchangeRates?.keys.map({ (key) -> String in
            return key
            }) ?? []).sorted()
    }
    fileprivate var activeRate: Double = 1.0 {
        didSet {
            self.fromExchValue = (Double(calculatorScreen.text ?? "0.0") ?? 0.0) * activeRate
        }
    }
    
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
        let alert = UIAlertController(title: "Restrictions", message: "Api free plan, doesn't support all Base Currencies", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    @IBAction func toExtRateBtnPressed(_ sender: Any) {
        if (exchangeRates ?? [:]).isEmpty {
            self.getLatestFromBackend { [weak self](results) in
                if let hasRates = results, !hasRates.isEmpty {
                    self?.showToButtonPopUp()
                }
            }
        } else {
            self.showToButtonPopUp()
        }
    }
    
    fileprivate func showFromButtonPopUp() {
       
    }
    
    fileprivate func showToButtonPopUp() {
        StringPickerPopover(title: "", choices: exchangeRatesArray)
        .setSelectedRow(0)
            .setValueChange(action: { (_, _, _) in
                //print("current  \(itemType)")
            })
        .setDoneButton(color: .white,
                       action: { (_, _, selectedString) in
            //print("done row \(selectedRow) \(selectedString)")
            if let exchangeRatio = self.exchangeRates?[selectedString] {
                self.selectedToBase = selectedString
                self.activeRate = exchangeRatio
            }
        })
        .setCancelButton(color: .white,
                         action: { (_, _, _) in print("cancel")}
        )
        .appear(originView: toExchRateBtn, baseViewController: self)
    }
    
    fileprivate func recalculateRatio() {
        //we have new base
        self.getLatestFromBackend { [weak self](results) in
            if let hasRates = results, !hasRates.isEmpty {
                guard let toTxt = self?.toExchRateBtn.titleLabel?.text,
                    let newRatio =  (self?.exchangeRates ?? [:])[toTxt] else {
                    return
                }
                self?.activeRate = newRatio
            }
        }
    }
    
    fileprivate func getLatestFromBackend(completion: @escaping ([String: Double]?) -> Void) {
        guard let baseTxt = fromExchRateBtn.titleLabel?.text else {
            completion(nil)
            return
        }
        guard !isLoading else { return }
        isLoading = true
        backendAPI.getLatest(baseTxt: baseTxt) { [weak self] (netAnswer, error, _) in
            self?.isLoading = false
            if !error.isEmpty {
               print("***API Error -> \(error)")
            } else {
                if let results = netAnswer?.rates {
                    self?.exchangeRates = results
                    completion(results)
                    return
                }
            }
            completion(nil)
        }
    }
}

extension CalculatorViewController: CalculatorActionDelegate {
    func screenUpdated(with text: String) {
        guard let newValue = Double(text) else { return }
        fromExchValue = newValue * activeRate
        
    }
}

extension CalculatorViewController: CalculatorViewActionsDelegate {
    func buttonPressed(text: String) {
        guard let screenText = calculatorBrain.input(text: text) else { return }
        //update screen
        calculatorScreen.text = screenText
    }
}
