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
	var currentValue: Int {
		get {
			return value
		}
		set(newValue) {
			if newValue >= maxValue {
				self.value = maxValue
			}
			else if newValue <= 0 {
				self.value = 0
			}
			else {
				self.value = newValue
			}
			update()
			setNeedsDisplay()
		}
	}
	var maxValue: Int = 20
	
	// Additional public properties
	
	var labelFontColor: UIColor = UIColor.whiteColor()
	var labelBackgroundColor: UIColor = UIColor.blackColor()
	var labelFont = UIFont(name: "Helvetica Neue", size: 12)
	var bgColor: UIColor = UIColor.whiteColor()
	var barColor: UIColor = UIColor.grayColor()
	var cornerRadius: CGFloat = 30.0
	
	// Private properties
	
	private var value: Int = 0
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
		
		bgColor.set()
		UIRectFill(rect)
		
		let context = UIGraphicsGetCurrentContext();
		barColor.set()
		
		let offset = (direction == .Horizontal ? size.height * 0.15 : size.width * 0.15)
		let doubleOffset = offset * 2
		
		CGContextBeginPath(context);
		if direction == .Horizontal {
			CGContextMoveToPoint(context, CGRectGetMaxX(rect) - doubleOffset, CGRectGetMinY(rect) + offset);
			CGContextAddLineToPoint(context, CGRectGetMinX(rect) + doubleOffset, CGRectGetMidY(rect));
			CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - doubleOffset, CGRectGetMaxY(rect) - offset);
		}
		else {
			CGContextMoveToPoint(context, CGRectGetMaxX(rect) - offset, CGRectGetMaxY(rect) - doubleOffset);
			CGContextAddLineToPoint(context, CGRectGetMidX(rect), CGRectGetMinY(rect) + doubleOffset);
			CGContextAddLineToPoint(context, CGRectGetMinX(rect) + offset, CGRectGetMaxY(rect) - doubleOffset);
		}
		CGContextClosePath(context);
		CGContextSetFillColor(context, CGColorGetComponents(barColor.CGColor));
		CGContextFillPath(context);
		CGContextStrokePath(context);
		
		var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
	
	// Updating
	
	func update() {
		
		let offset = (direction == .Horizontal ? self.frame.size.height : self.frame.size.width)
		let halfOffset = offset * 0.5
		var size = self.frame.size
		if direction == .Horizontal {
			size.width -= offset
		}
		else {
			size.height -= offset
		}
		
		currentSelectionX = ((CGFloat(value) * (size.width)) / CGFloat(maxValue)) + halfOffset
		currentSelectionY = ((CGFloat(value) * (size.height)) / CGFloat(maxValue)) + halfOffset
		
		image = generateHUEImage(self.frame.size)
	}
	
	// Drawing
	
	override func drawRect(rect: CGRect) {
		super.drawRect(rect)
		
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
		var imageRect = rect
		
		if image != nil {
			if direction == .Horizontal {
				imageRect.size.width -= radius
				imageRect.origin.x += halfRadius
			}
			else {
				imageRect.size.height -= radius
				imageRect.origin.y += halfRadius
			}
			image.drawInRect(imageRect)
		}
		
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
		
		let text: NSString = "\(value)"
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
		
		let offset = (direction == .Horizontal ? self.frame.size.height : self.frame.size.width)
		let halfOffset = offset * 0.5
		if currentSelectionX < halfOffset {
			currentSelectionX = halfOffset
		}
		else if currentSelectionX >= self.frame.size.width - halfOffset {
			currentSelectionX = self.frame.size.width - halfOffset
		}
		if currentSelectionY < halfOffset {
			currentSelectionY = halfOffset
		}
		else if currentSelectionY >= self.frame.size.height - halfOffset {
			currentSelectionY = self.frame.size.height - halfOffset
		}
		
		let percent = (direction == .Horizontal ? CGFloat((currentSelectionX - halfOffset) / (self.frame.size.width - offset))
			: CGFloat((currentSelectionY - halfOffset) / (self.frame.size.height - offset)))
		value = Int(percent * CGFloat(maxValue))
		
		if delegate != nil {
			delegate.valueChanged(value)
		}
		
		setNeedsDisplay()
	}
	
}
