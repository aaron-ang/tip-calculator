//
//  ViewController.swift
//  tip-calculator
//
//  Created by Aaron Ang on 22/8/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var totalLabel: UILabel!
    
    let currencyFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure currencyFormatter
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        // Do any additional setup after loading the view.
        self.title = "Tip Calculator"
        // Add listener to bill TextField to update total on edit
        billAmountTextField.addTarget(self, action: #selector(calculateTip(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Retrieve and populate UserDefaults stored values
        let lastDatetime: NSDate? = UserDefaults.standard.object(forKey: "datetime") as? NSDate
        if (lastDatetime != nil) && lastDatetime!.timeIntervalSinceNow >= -600 {
            billAmountTextField.text = UserDefaults.standard.string(forKey: "billAmt")
            tipControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "segmentIndex")
        }
        calculateTip(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        billAmountTextField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        billAmountTextField.resignFirstResponder()
    }

    @IBAction func calculateTip(_ sender: Any) {
        let bill = Double(billAmountTextField.text!) ?? 0
        let tipPercentages = [0.15, 0.18, 0.2]
        let segmentIndex = tipControl.selectedSegmentIndex
        let tip: Double = bill * tipPercentages[segmentIndex]
        let total: Double = bill + tip
        
        UserDefaults.standard.set(billAmountTextField.text, forKey: "billAmt")
        UserDefaults.standard.set(segmentIndex, forKey: "segmentIndex")
        UserDefaults.standard.set(NSDate(), forKey: "datetime")
        
        tipAmountLabel.text = currencyFormatter.string(from: tip as NSNumber)
        totalLabel.text = currencyFormatter.string(from: total as NSNumber)
    }
    
}

