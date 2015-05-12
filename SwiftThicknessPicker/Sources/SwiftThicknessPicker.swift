//
//  SwiftThicknessPicker.swift
//  SwiftThicknessPicker
//
//  Created by Maxim Bilan on 5/12/15.
//  Copyright (c) 2015 Maxim Bilan. All rights reserved.
//

import UIKit

protocol SwiftThicknessPickerDelegate {
	func valueChanged(value: Int)
}

class SwiftThicknessPicker: UIView {

	// Direction
	
	enum PickerDirection: Int {
		case Horizontal
		case Vertical
	}
	
	// Public properties
	
	var delegate: SwiftThicknessPickerDelegate!
	var direction: PickerDirection = .Horizontal
	
	// Additional public properties
	
	var cornerRadius: CGFloat = 10.0
	
	// Private properties
	
	private var image: UIImage!
	
	// Initialization
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.backgroundColor = UIColor.clearColor()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.clearColor()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		update()
	}
	
	// Prerendering
	
	func generateHUEImage(size: CGSize) -> UIImage {
		
		var rect = CGRectMake(0, 0, size.width, size.height)
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		
		UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
		
		let context = UIGraphicsGetCurrentContext();
		UIColor.yellowColor().set()
		
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
		CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
		CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
		CGContextClosePath(context);
		
		CGContextSetFillColor(context, CGColorGetComponents(UIColor.yellowColor().CGColor));
		CGContextFillPath(context);
		CGContextStrokePath(context);
		
		var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
	
	// Updating
	
	func update() {
		image = generateHUEImage(self.frame.size)
	}
	
	// Drawing
	
	override func drawRect(rect: CGRect) {
		super.drawRect(rect)
		
		if image != nil {
			image.drawInRect(rect)
		}
	}
	
}
