//
//  ManagerViewController.swift
//  CurrencyConverter
//
//  Created by Elmira on 21.03.21.
// api-key: 521106e350f34133b6977f5404b1805d


import Foundation
import UIKit

protocol ManagerViewControllerDelegate {
    func didUpdateCurrency(_ managerViewController: ManagerViewController, collection: [String])
}


class ManagerViewController: UIViewController {
    
    var delegate: ManagerViewControllerDelegate?
    var countries: [String] = []
    
    let currencyCountriesUrl = "http://data.fixer.io/api/symbols?access_key=521106e350f34133b6977f5404b1805d"
    
    func fetchCurrency () {
        performRequest()
    }
    
    func performRequest(){
        if  let url = URL(string: currencyCountriesUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                if let safeData = data {
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: safeData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        if let results = myJson["symbols"] as? NSDictionary {
                            for (_, value) in results {
                                if let resultValue = value as? String {
                                    self.countries.append(resultValue)
                                }
                            }
                            self.delegate?.didUpdateCurrency(self, collection: self.countries)
                        }
                    } catch {
                        print("FAILED \(error)!!!")
                    }
                }
            }
            task.resume()
            
        }
        
    }
    
}
