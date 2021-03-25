//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Elmira on 20.03.21.
//

import UIKit

class CurrencyViewController: UIViewController {
    
    @IBOutlet weak var firstCurrencyLabel: UILabel!
    @IBOutlet weak var secondCurrencyLabel: UILabel!
    
    @IBOutlet weak var firstCurrencyButton: UIButton!
    @IBOutlet weak var secondCurrencyButton: UIButton!
    
    var digitTyped: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(named: "DarkGreen")
    }
    
    @IBAction func currencyButtonPressed(_ sender: UIButton) {
        if firstCurrencyLabel.text != "" {
            
        guard let vc = storyboard?.instantiateViewController(identifier: "table") as? CurrencyTableViewController else {
            return
        }
        vc.completion = { value, label in
            self.navigationController?.popToRootViewController(animated: true)
            guard let firstNumber = self.firstCurrencyLabel.text else {
                return
            }
            let newValue = (Double(firstNumber) ?? 0) * value
            self.secondCurrencyLabel.text = String(format: "%.2f", newValue)
            self.secondCurrencyButton.setTitle(label, for: .normal)
        }
        navigationController?.pushViewController(vc, animated: true)
        } else {
            return
        }
    }
    
    
    @IBAction func changeCurrenciesButtonPressed(_ sender: UIButton) {
        
    }
    
    
    @IBAction func digitButton(_ sender: UIButton) {
        if let numValue = sender.currentTitle {
            if firstCurrencyLabel.text == "" {
                firstCurrencyLabel.text = numValue
                //digitTyped = false
            } else {
                
                if numValue == "." {
                    guard let number = Double(firstCurrencyLabel.text!)  else {
                        return
                    }
                    let isInt = floor(Double(number)) == Double(number)
                    if !isInt {
                        return
                    }
                }
               
                firstCurrencyLabel.text = firstCurrencyLabel.text! + numValue
            }
        }
    }
    
    
    @IBAction func clearButton(_ sender: UIButton) {
        firstCurrencyLabel.text = ""
        secondCurrencyLabel.text = ""
    }
    
    
}


