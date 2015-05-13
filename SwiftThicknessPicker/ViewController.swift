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
		// Do any additional setup after loading the view, typically from a nib.
		
		horizontalThicknessPicker.delegate = self
		verticalThicknessPicker.delegate = self
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func valueChanged(value: Int) {
		testLabel.text = "\(value)"
	}

}

