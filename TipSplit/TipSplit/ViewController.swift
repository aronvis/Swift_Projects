//
//  ViewController.swift
//  TipSplit
//
//  Created by Aron Vischjager on 2/16/20.
//  Copyright © 2020 App Factory. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    // Properties Top View
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var taxSegmentControl: UISegmentedControl!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var roundSwitch: UISwitch!
    @IBOutlet weak var splitLabel: UILabel!
    @IBOutlet weak var splitStepper: UIStepper!
    
    // Properties Bottom View
    @IBOutlet weak var taxAmountLabel: UILabel!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var tipSplitAmountLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var totalSplitAmountLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    // Other Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearAllButton: UIButton!
    
    // Properties needed for computation
    var totalAmount: Double = 0.0
    var tax: Double = 8.0
    var tip: Double = 15.0
    var roundTotal: Bool = true
    var splitCount: Int = 1
    var taxAmount:Double = 0.0
    var tipAmount:Double = 0.0
    var tipSplit:Double = 0.0
    var totalBill:Double = 0.0
    var totalSplit:Double = 0.0
    
    // Other Methods
    
    // Sets all fields to their initial state
    func setDefaultValues()
    {
        totalAmount = 0.0
        billTextField.text = nil
        tax = 8.0
        taxSegmentControl.selectedSegmentIndex = 0
        tip = 15.0
        tipLabel.text = String("\(Int(tip))%")
        tipSlider.setValue(15.0, animated: true)
        roundTotal = true
        roundSwitch.setOn(true, animated: true)
        splitCount = 1
        splitLabel.text = "Split \(splitCount)"
        splitStepper.value = Double(splitCount)
        taxAmount = 0.0
        tipAmount = 0.0
        tipSplit = 0.0
        totalBill = 0.0
        totalSplit = 0.0
    }
    
    func connectOutlets()
    {
        billLabel.accessibilityIdentifier = TipSplitAccessibilityIdentifiers.billLabel
        billTextField.accessibilityIdentifier = TipSplitAccessibilityIdentifiers.billTextField
        taxLabel.accessibilityIdentifier = TipSplitAccessibilityIdentifiers.taxPercentSegmentedLabel
        taxSegmentControl.accessibilityIdentifier = TipSplitAccessibilityIdentifiers.taxPercentSegmentedControl
        tipLabel.accessibilityIdentifier = TipSplitAccessibilityIdentifiers.tipPercentSliderAmountLabel
        tipSlider.accessibilityIdentifier = TipSplitAccessibilityIdentifiers.tipPercentSlider
        roundLabel.accessibilityIdentifier = TipSplitAccessibilityIdentifiers.roundUpLabel
        roundSwitch.accessibilityIdentifier = TipSplitAccessibilityIdentifiers.roundUpSwitch
        splitLabel.accessibilityIdentifier = TipSplitAccessibilityIdentifiers.splitStepperAmountLabel
        splitStepper.accessibilityIdentifier = TipSplitAccessibilityIdentifiers.splitStepper
        taxAmountLabel.accessibilityIdentifier = TipSplitAccessibilityIdentifiers.taxAmountLabel
        tipAmountLabel.accessibilityIdentifier = TipSplitAccessibilityIdentifiers.tipAmountLabel
        tipSplitAmountLabel.accessibilityIdentifier = TipSplitAccessibilityIdentifiers.tipSplitAmountLabel
        totalAmountLabel.accessibilityIdentifier = TipSplitAccessibilityIdentifiers.totalAmountLabel
        totalSplitAmountLabel.accessibilityIdentifier = TipSplitAccessibilityIdentifiers.totalSplitAmountLabel
        titleLabel.accessibilityIdentifier = TipSplitAccessibilityIdentifiers.tipCalculaterLabel
        clearAllButton.accessibilityIdentifier = TipSplitAccessibilityIdentifiers.resetButton
        bottomView.accessibilityIdentifier = TipSplitAccessibilityIdentifiers.view
    }
    
    @IBAction func clearAllTouched(_ sender: Any)
    {
        displayActionSheet()
    }
    
    func displayActionSheet()
    {
        let alertController = UIAlertController(title: "Clear All Values", message: "Are you sure you want to clear all values?",preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let clearAllAction = UIAlertAction(title: "Clear All", style: .destructive, handler:
        { action in
            self.setDefaultValues()
            self.updateUI()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(clearAllAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if billTextField.isFirstResponder && touch?.view != billTextField
        {
            billTextField.resignFirstResponder()
        }
        super.touchesBegan(touches, with: event)
    }
    
    func round2(_ value: Double) -> Double
    {
        return (value * 100).rounded() / 100
    }
    
    // Methods Top View
    @IBAction func textFieldChanged(_ sender: Any)
    {
        totalAmount = Double(billTextField.text ?? "0.0") ?? 0.0
        updateUI()
    }
    
    @IBAction func segmentControlTouched(_ sender: Any)
    {
        tax = Double(taxSegmentControl.titleForSegment(at: taxSegmentControl.selectedSegmentIndex) ?? "8.0") ?? 8.0
        updateUI()
    }
    
    @IBAction func sliderTouched(_ sender: Any)
    {
        tip = Double(Int(round(tipSlider.value)))
        tipLabel.text = String("\(Int(tip))%")
        updateUI()
    }
    
    @IBAction func switchTouched(_ sender: Any)
    {
        if(roundSwitch.isOn)
        {
            roundTotal = true
        }
        else
        {
            roundTotal = false
        }
        updateUI()
    }
    
    @IBAction func stepperTouched(_ sender: Any)
    {
        splitCount = Int(splitStepper.value)
        splitLabel.text = "Split \(splitCount)"
        updateUI()
    }
    
    // Method Bottom view
    func updateUI()
    {
        taxAmount = round2((tax/100.0) * totalAmount)
        tipAmount = round2((tip/100.0) * totalAmount)
        totalBill = round2(taxAmount + tipAmount + totalAmount)
        if(roundTotal)
        {
            let roundingCost:Double = abs(ceil(totalBill) - totalBill)
            tipAmount = round2(tipAmount + roundingCost)
        }
        tipSplit = round2(tipAmount/Double(splitCount))
        totalBill = round2(taxAmount + tipAmount + totalAmount)
        totalSplit = round2(totalBill/Double(splitCount))
        taxAmountLabel.text = String(format: "Tax $%.2f", taxAmount)
        tipAmountLabel.text = String(format: "Tip $%.2f", tipAmount)
        tipSplitAmountLabel.text = String(format: "Tip split $%.2f", tipSplit)
        totalAmountLabel.text = String(format: "Total $%.2f", totalBill)
        totalSplitAmountLabel.text =  String(format: "Total split $%.2f", totalSplit)
    }
    
    // Gets called when the view gets loaded
    override func viewDidLoad()
    {
        super.viewDidLoad()
        billTextField.becomeFirstResponder()
        connectOutlets()
        setDefaultValues()
    }
}

