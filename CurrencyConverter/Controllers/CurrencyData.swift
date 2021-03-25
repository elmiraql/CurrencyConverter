//
//  CurrencyData.swift
//  CurrencyConverter
//
//  Created by Elmira on 21.03.21.
//

import Foundation

struct CurrencyData: Decodable {
    let rates: [String: Double]
    //let symbols: [String: String]
}

