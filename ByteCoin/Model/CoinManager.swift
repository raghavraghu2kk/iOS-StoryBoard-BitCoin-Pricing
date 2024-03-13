//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
// API - Key - CA33F1A1-C197-4E47-BAAA-2B5482D1CE3A
// https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=CA33F1A1-C197-4E47-BAAA-2B5482D1CE3A

import Foundation

protocol CoinManagerDelegate {
    func didExchangeRate(_ currency : String , _ exchangeRate : String)
    func didFailWithError(_ error: Error)
}

struct CoinManager  {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "CA33F1A1-C197-4E47-BAAA-2B5482D1CE3A"
    
    var delegate : CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var setCurrency : String?

    mutating func getCoinPrice(for currency : String) {
        setCurrency = currency
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString : String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let exchangeCurrency = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", exchangeCurrency)
                        print(priceString)
                        delegate?.didExchangeRate(setCurrency ?? "USD", priceString)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data : Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let exchangeRate = decodedData.rate
            return exchangeRate
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
    
}

struct CoinData : Codable {
    let rate : Double
}
