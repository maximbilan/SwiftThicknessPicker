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
	
	// Private properties
	
	var delegate: SwiftThicknessPickerDelegate!
	var direction: PickerDirection = .Horizontal
	
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
	}
	
	// Drawing
	
	override func drawRect(rect: CGRect) {
		super.drawRect(rect)
		
		let radius = (direction == .Horizontal ? self.frame.size.height : self.frame.size.width)
		let circleRect = (direction == .Horizontal ? CGRectMake(0, 0, radius, radius) : CGRectMake(0, 0, radius, radius))
		
		let context = UIGraphicsGetCurrentContext();
		UIColor.yellowColor().set()
		//CGContextAddEllipseInRect(context, circleRect);
		
		CGContextBeginPath(context);
		CGContextMoveToPoint   (context, CGRectGetMaxX(rect), CGRectGetMinY(rect));  // top left
		CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));  // mid right
		CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));  // bottom left
		CGContextClosePath(context);
		
		CGContextSetFillColor(context, CGColorGetComponents(UIColor.yellowColor().CGColor));
		CGContextFillPath(context);
		CGContextStrokePath(context);
		
	}
	
}
