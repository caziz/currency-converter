//
//  ViewController.swift
//  CurrCov
//
//  Created by Christopher Aziz on 6/21/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // holds currencies and associated values in USD
    var currencies: [String] = []
    var currenciesInUSD: [Double] = []
    
    // holds selected rows in pickers
    var inputRow = 0
    var outputRow = 0
    
    // app converts inputText of currency inputPicker to outputText of currency outputPicker
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var outputText: UITextField!
    @IBOutlet weak var inputPicker: UIPickerView!
    @IBOutlet weak var outputPicker: UIPickerView!
    
    // swaps all input and outputs so that the values are still equal
    @IBAction func swapInputOutput(_ sender: Any) {
        inputPicker.selectRow(outputRow, inComponent: 0, animated: true)
        outputPicker.selectRow(inputRow, inComponent: 0, animated: true)
        let tempInputRow = inputRow
        inputRow = outputRow
        outputRow = tempInputRow
        inputText.text = outputText.text
        printOutput()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate pickers
        self.inputPicker.delegate = self
        self.inputPicker.dataSource = self
        self.outputPicker.delegate = self
        self.outputPicker.dataSource = self
        
        // call textFieldDidChange when inputText is edited
        inputText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.inputText.delegate = self
        
        // focus inputText
        inputText.becomeFirstResponder()
        
        //initialize supported currencies and associated value in USD
        currencies = ["USD", "EUR", "CAD", "GBP", "AUD", "INR", "RMB", "JPY", "CHF"]
        currenciesInUSD = [1.0, 1.12, 0.75, 1.27, 0.76, 0.016, 0.15, 0.009, 1.03]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // converts value from fromCurrency to USD
    func convertToUSD(_ value: Double, fromCurrency: String) -> Double {
        if let indexOfCurrency = currencies.index(of: fromCurrency) {
            return value * currenciesInUSD[indexOfCurrency]
        }
        return -1.0
    }
    
    // converts value from USD to toCurrency
    func convertFromUSD(_ value: Double, toCurrency: String) -> Double {
        return value * (1.0 / convertToUSD(1, fromCurrency: toCurrency))
    }
    
    // prints output value when inputText changes
    func textFieldDidChange(_ textField: UITextField) {
        printOutput()
    }
    
    // always 1 component in currency converter
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // rows represented by items in currecies array
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }

    // updates rows and prints output when pickers are changed
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == inputPicker) { inputRow = row }
        if(pickerView == outputPicker) { outputRow = row }
        printOutput()
    }
    
    
    // updates outputText of currency outputPicker to be equal to inputText of currency inputPicker
    func printOutput()
    {
        let inputValue = convertToUSD(Double(inputText.text!) ?? 0, fromCurrency: currencies[inputRow])
        let outputValue = convertFromUSD(inputValue, toCurrency: currencies[outputRow])
        outputText.text = String(format: "%.2f", outputValue)
    }
    
    
    /* aesthetic modifications */
    
    // modify font and alignment of pickers
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.white
        pickerLabel.text = currencies[row]
        pickerLabel.font = UIFont(name: "Helvetica Neue", size: 40)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    // adjusts picker row size to fit picker font
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    // make status bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
