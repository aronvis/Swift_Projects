//
//  TipSplitSanityTest.swift
//  TipSplitUITests
//
//  Created by Aron Vischjager on 2/16/20.
//  Copyright © 2020 App Factory. All rights reserved.
//

import XCTest

class HW4SanityTest: XCTestCase {
    
    private let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        XCUIApplication().launch()
        
    }
    
    func testBasicUIElements() {
        
        // test ui components that you can interact with
        let billTextField = app.textFields[TipSplitAccessibilityIdentifiers.billTextField]
        let taxPercentSegmentedControl = app.segmentedControls[TipSplitAccessibilityIdentifiers.taxPercentSegmentedControl]
        let tipPercentSlider = app.sliders[TipSplitAccessibilityIdentifiers.tipPercentSlider]
        let roundUpSwitch = app.switches[TipSplitAccessibilityIdentifiers.roundUpSwitch]
        let splitStepper = app.steppers[TipSplitAccessibilityIdentifiers.splitStepper]
        let resetButton = app.buttons[TipSplitAccessibilityIdentifiers.resetButton]
        
        // all the dyamic labels that will change based on userinput
        let tipPercentSliderAmountLabel = app.staticTexts[TipSplitAccessibilityIdentifiers.tipPercentSliderAmountLabel]
        let splitStepperAmountLabel = app.staticTexts[TipSplitAccessibilityIdentifiers.splitStepperAmountLabel]
        let taxAmountLabel = app.staticTexts[TipSplitAccessibilityIdentifiers.taxAmountLabel]
        let tipAmountLabel = app.staticTexts[TipSplitAccessibilityIdentifiers.tipAmountLabel]
        let tipSplitAmountLabel = app.staticTexts[TipSplitAccessibilityIdentifiers.tipSplitAmountLabel]
        let totalAmountLabel = app.staticTexts[TipSplitAccessibilityIdentifiers.totalAmountLabel]
        let totalSplitAmountLabel = app.staticTexts[TipSplitAccessibilityIdentifiers.totalAmountLabel]
        
        //static labels that dont change - title labels
        let tipCalculaterLabel = app.staticTexts[TipSplitAccessibilityIdentifiers.tipCalculaterLabel]
        let billLabel = app.staticTexts[TipSplitAccessibilityIdentifiers.billLabel]
        let taxPercentSegmentedLabel = app.staticTexts[TipSplitAccessibilityIdentifiers.taxPercentSegmentedLabel]
        let roundUpLabel = app.staticTexts[TipSplitAccessibilityIdentifiers.roundUpLabel]
        
        //connecting at least one view
        let calcView = app.otherElements[TipSplitAccessibilityIdentifiers.view]
        
        //verify that the components exist on the screen
        XCTAssert(billTextField.exists)
        XCTAssert(taxPercentSegmentedControl.exists)
        XCTAssert(tipPercentSlider.exists)
        XCTAssert(roundUpSwitch.exists)
        XCTAssert(splitStepper.exists)
        XCTAssert(resetButton.exists)
        XCTAssert(tipPercentSliderAmountLabel.exists)
        XCTAssert(splitStepperAmountLabel.exists)
        XCTAssert(taxAmountLabel.exists)
        XCTAssert(tipAmountLabel.exists)
        XCTAssert(tipSplitAmountLabel.exists)
        XCTAssert(totalAmountLabel.exists)
        XCTAssert(totalSplitAmountLabel.exists)
        XCTAssert(billLabel.exists)
        XCTAssert(tipCalculaterLabel.exists)
        XCTAssert(billLabel.exists)
        XCTAssert(taxPercentSegmentedLabel.exists)
        XCTAssert(roundUpLabel.exists)
        
        //seeing if the user has at least 1 view
        XCTAssert(calcView.exists)
        
        //checks to see if there is a placeholder
        XCTAssertNotEqual(billTextField.placeholderValue, "")
    }
    
    /// simulates a real life scenario to test your app
    func testCase1() {
        let billTextField = app.textFields["billTextField"]
        //added for students who are making keyboard come up on runtime
        if (app.keyboards.count != 0)
        {
            billTextField.typeText("\n")
        }
        
        //type 100$ into the textfield
        billTextField.tap()
        billTextField.typeText("100")
        
        //simulate background press
        let tipCalcLabel = app.staticTexts["tipCalculaterLabel"]
        tipCalcLabel.tap()
        
        //grab all the necessary labels
        let taxAmountLabel = app.staticTexts["taxAmountLabel"]
        let tipAmountLabel = app.staticTexts["tipAmountLabel"]
        let tipSplitAmountLabel = app.staticTexts["tipSplitAmountLabel"]
        let totalAmountLabel = app.staticTexts["totalAmountLabel"]
        let totalSplitAmountLabel = app.staticTexts["totalSplitAmountLabel"]
        
        let tipPercentSliderAmountLabel = app.staticTexts["tipPercentSliderAmountLabel"]

        // split 1 case: works when the tip is .1 of your slider and the split is 1
        let roundUpSwitch = app.switches["roundUpSwitch"]
        roundUpSwitch.tap()
        let isOn = roundUpSwitch.value as! String
        if (isOn == "0")
        {
            // want to make sure this is enable, so tap again
            roundUpSwitch.tap()
        }
        
        //set tax to .1 of slider
        let slider = app.sliders["tipPercentSlider"]
        slider.adjust(toNormalizedSliderPosition: 0.10)
        let sliderval = Double((slider.value as! String).components(separatedBy: "%").first!)
        
        //set segmented control to 9
        let segmented = app.segmentedControls["taxPercentSegmentedControl"]
        segmented.tap()
        
        // calculations
        let tip = 100.00 * ((sliderval!) / 100.00)
        let tipString = String(format: "Tip $%.02f", tip).lowercased()
        let tipSplit = tip / 1
        let tipSplitString = String(format: "Tip split $%.02f", tipSplit).lowercased()
        let total = tip + 109.00
        let totalString = String(format: "Total $%.02f", total).lowercased()
        let totalSplit = total / 1
        let totalSplitString = String(format: "Total split $%.02f", totalSplit).lowercased()

        ////VERIFICATION
        //verify Tax
        let taxString = "Tax $9.00".lowercased()
        XCTAssertEqual(taxAmountLabel.label.lowercased(), taxString)
        
        //verify tip
        let tipplusone = Double(tip + 0.005)
        let tipplusonestring = String(format: "Tip $%.02f", tipplusone).lowercased()
        let tipminusone = Double(tip - 0.005)
        let tipminusonestring = String(format: "Tip $%.02f", tipminusone).lowercased()
    
        XCTAssert([tipplusonestring, tipminusonestring, tipString].contains(tipAmountLabel.label.lowercased()))
        
        //verify tip split
        let tipsplitplusone = Double(tipSplit + 0.005)
        let tipsplitplusonestring = String(format: "Tip split $%.02f", tipsplitplusone).lowercased()
        let tipsplitminusone = Double(tip - 0.005)
        let tipsplitminusonestring = String(format: "Tip split $%.02f", tipsplitminusone).lowercased()
        
        XCTAssert([tipsplitplusonestring, tipsplitminusonestring, tipSplitString].contains(tipSplitAmountLabel.label.lowercased()))
        
        //verify total
        let totalplusone = Double(total + 0.005)
        let totalplusonestring = String(format: "Total $%.02f", totalplusone).lowercased()
        let totalminusone = Double(total - 0.005)
        let totalMinusonestring = String(format: "Total $%.02f", totalminusone).lowercased()
        
        XCTAssert([totalplusonestring, totalMinusonestring, totalString].contains(totalAmountLabel.label.lowercased()))
        
        //verify total split
        let totalsplitplusone = Double(totalSplit + 0.005)
        let totalsplitplusonestring = String(format: "Total split $%.02f", totalsplitplusone).lowercased()
        let totalsplitminusone = Double(total - 0.005)
        let totalsplitminusonestring = String(format: "Total split $%.02f", totalsplitminusone).lowercased()
        
        XCTAssert([totalsplitplusonestring, totalsplitminusonestring, totalSplitString].contains(totalSplitAmountLabel.label.lowercased()))

        //verify the tip slider based on display
        let sliderplusone = Int((slider.value as! String).components(separatedBy: "%").first!)! + 1
        let sliderminusone = Int((slider.value as! String).components(separatedBy: "%").first!)! - 1
        let sliderplusonestring = "\(sliderplusone)%"
        let sliderminusonestring = "\(sliderminusone)%"
        
        XCTAssert([sliderplusonestring, sliderminusonestring, slider.value as! String].contains(tipPercentSliderAmountLabel.label))
    }
}
