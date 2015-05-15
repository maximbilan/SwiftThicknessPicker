//
//  ViewController.swift
//  SwiftThicknessPicker
//
//  Created by Maxim Bilan on 5/12/15.
//  Copyright (c) 2015 Maxim Bilan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SwiftThicknessPickerDelegate {

	@IBOutlet weak var horizontalThicknessPicker: SwiftThicknessPicker!
	@IBOutlet weak var verticalThicknessPicker: SwiftThicknessPicker!
	@IBOutlet weak var testLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		horizontalThicknessPicker.delegate = self
		horizontalThicknessPicker.direction = SwiftThicknessPicker.PickerDirection.Horizontal
		
		verticalThicknessPicker.delegate = self
		verticalThicknessPicker.direction = SwiftThicknessPicker.PickerDirection.Vertical
	}

	// SwiftThicknessPickerDelegate
	
	func valueChanged(value: Int) {
		testLabel.text = "\(value)"
	}

	// Actions
	
	@IBAction func testButtonAction(sender: UIButton) {
		horizontalThicknessPicker.currentValue = 11
		verticalThicknessPicker.currentValue = 20
	}
	
}

