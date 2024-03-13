//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var coinManager = CoinManager()
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
    
}


extension ViewController : CoinManagerDelegate {
    func didExchangeRate(_ currency: String, _ exchangeRate: String) {
        DispatchQueue.main.async {
            self.currencyLabel.text = currency
            self.bitcoinLabel.text = exchangeRate
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    
}

//MARK: - UIPickerViewDelegate

// Next, let’s update the PickerView with some titles and detect when it is interacted with. To do this we have set up the PickerView’s delegate methods.
//Add the protocol UIPickerViewDelegate to the class declaration and set the ViewController class as the delegate of the currencyPicker.

extension ViewController : UIPickerViewDelegate {
    
//  2.This method expects a String as an output. The String is the title for a given row. When the PickerView is loading up, it will ask its delegate for a row title and call the above method once for every row. So when it is trying to get the title for the first row, it will pass in a row value of 0 and a component (column) value of 0.
    
//  So inside the method, we can use the row Int to pick the title from our currencyArray.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
  
//    2.This will get called every time when the user scrolls the picker. When that happens it will record the row number that was selected.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(coinManager.currencyArray[row])
        let selectedCurrecny = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrecny)
    }
}

//MARK: - UIPickerViewDataSource
extension ViewController : UIPickerViewDataSource {
//    Now let’s actually provide the data and add the implementation
//    1. For the first method numberOfComponents(in:) to determine how many columns we want in our picker.
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
//    Next, we need to tell Xcode how many rows this picker should have
//    2.using the pickerView:numberOfRowsInComponent: method.
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}
