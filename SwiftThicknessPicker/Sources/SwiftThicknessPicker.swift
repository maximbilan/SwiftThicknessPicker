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
	
	var labelFontColor: UIColor = UIColor.whiteColor()
	var labelBackgroundColor: UIColor = UIColor.blackColor()
	var labelFont = UIFont(name: "Helvetica Neue", size: 12)
	var cornerRadius: CGFloat = 20.0
	
	// Private properties
	
	private var image: UIImage!
	private var currentSelectionY: CGFloat = 0.0
	private var currentSelectionX: CGFloat = 0.0
	
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
		UIColor.grayColor().set()
		
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
		CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
		CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
		CGContextClosePath(context);
		
		CGContextSetFillColor(context, CGColorGetComponents(UIColor.grayColor().CGColor));
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
		
		let radius = (direction == .Horizontal ? self.frame.size.height : self.frame.size.width)
		let halfRadius = radius * 0.5
		var circleX = currentSelectionX - halfRadius
		var circleY = currentSelectionY - halfRadius
		if circleX >= rect.size.width - radius {
			circleX = rect.size.width - radius
		}
		else if circleX < 0 {
			circleX = 0
		}
		if circleY >= rect.size.height - radius {
			circleY = rect.size.height - radius
		}
		else if circleY < 0 {
			circleY = 0
		}
		
		let circleRect = (direction == .Horizontal ? CGRectMake(circleX, 0, radius, radius) : CGRectMake(0, circleY, radius, radius))
		let circleColor = labelBackgroundColor
		
		let context = UIGraphicsGetCurrentContext();
		circleColor.set()
		CGContextAddEllipseInRect(context, circleRect);
		CGContextSetFillColor(context, CGColorGetComponents(circleColor.CGColor));
		CGContextFillPath(context);
		CGContextStrokePath(context);
		
		var textParagraphStyle = NSMutableParagraphStyle()
		textParagraphStyle.alignment = .Center
		
		var attributes: NSDictionary = [NSForegroundColorAttributeName: labelFontColor,
			NSParagraphStyleAttributeName: textParagraphStyle,
			NSFontAttributeName: labelFont!]
		
		let textValue: Int = Int(20)
		let text: NSString = "\(textValue)"
		var textRect = circleRect
		textRect.origin.y += (textRect.size.height - (labelFont?.lineHeight)!) * 0.5
		text.drawInRect(textRect, withAttributes: attributes as [NSObject : AnyObject])
	}
	
	// Touch events
	
	override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
		let touch: AnyObject? = touches.first
		let point = touch!.locationInView(self)
		handleTouch(point)
	}
	
	override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
		let touch: AnyObject? = touches.first
		let point = touch!.locationInView(self)
		handleTouch(point)
	}
	
	override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
		let touch: AnyObject? = touches.first
		let point = touch!.locationInView(self)
		handleTouch(point)
	}
	
	override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
		
	}
	
	// Touch handling
	
	func handleTouch(touchPoint: CGPoint) {
		currentSelectionX = touchPoint.x
		currentSelectionY = touchPoint.y
		
		if delegate != nil {
			// to do
			delegate.valueChanged(0)
		}
		setNeedsDisplay()
	}
	
}
