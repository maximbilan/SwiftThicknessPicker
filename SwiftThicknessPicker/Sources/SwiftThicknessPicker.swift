//
//  SwiftThicknessPicker.swift
//  SwiftThicknessPicker
//
//  Created by Maxim Bilan on 5/12/15.
//  Copyright (c) 2015 Maxim Bilan. All rights reserved.
//

import UIKit

public protocol SwiftThicknessPickerDelegate : class {
	 func valueChanged(value: Int)
}

public class SwiftThicknessPicker: UIView {

	// MARK: - Direction
	
	public enum PickerDirection: Int {
		case Horizontal
		case Vertical
	}
	
	// MARK: - Public properties
	
	public weak var delegate: SwiftThicknessPickerDelegate!
	public var direction: PickerDirection = .Horizontal
	public var currentValue: Int {
		get {
			return value
		}
		set(newValue) {
			if newValue >= maxValue {
				self.value = maxValue
			}
			else if newValue <= minValue {
				self.value = minValue
			}
			else {
				self.value = newValue
			}
			update()
			setNeedsDisplay()
		}
	}
	public var minValue: Int = 0
	public var maxValue: Int = 20
	
	// MARK: - Additional public properties
	
	public var labelFontColor: UIColor = UIColor.white
	public var labelBackgroundColor: UIColor = UIColor.black
	public var labelFont = UIFont(name: "Helvetica Neue", size: 12)
	public var bgColor: UIColor = UIColor.white
	public var bgCornerRadius: CGFloat = 30
	public var barColor: UIColor = UIColor.gray
	
	// MARK: - Private properties
	
	private var value: Int = 0
	private var image: UIImage!
	private var currentSelectionY: CGFloat = 0.0
	private var currentSelectionX: CGFloat = 0.0
	
	// MARK: - Initialization
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.backgroundColor = UIColor.clear
		value = minValue
	}
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = UIColor.clear
		value = minValue
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		
		update()
	}
	
	// MARK: - Prerendering
	
	func generateHUEImage(size: CGSize) -> UIImage {
		
		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		
		UIBezierPath(roundedRect: rect, cornerRadius: bgCornerRadius).addClip()
		
		bgColor.set()
		UIRectFill(rect)
		
		let context = UIGraphicsGetCurrentContext();
		barColor.set()
		
		let offset = (direction == .Horizontal ? size.height * 0.25 : size.width * 0.25)
		let doubleOffset = offset * 2
		
		context!.beginPath()
		if direction == .Horizontal {
			context!.moveTo(x: rect.maxX - doubleOffset, y: rect.minY + offset);
			context!.addLineTo(x: rect.minX + doubleOffset, y: rect.midY);
			context!.addLineTo(x: rect.maxX - doubleOffset, y: rect.maxY - offset);
			context!.addArc(centerX: rect.maxX - doubleOffset, y: rect.midY, radius: size.height * 0.25, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: 1)
		}
		else {
			context!.moveTo(x: rect.maxX - offset, y: rect.maxY - doubleOffset);
			context!.addLineTo(x: rect.midX, y: rect.minY + doubleOffset);
			context!.addLineTo(x: rect.minX + offset, y: rect.maxY - doubleOffset);
			context!.addArc(centerX: rect.midX, y: rect.maxY - doubleOffset, radius: size.width * 0.25, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI + M_PI_2), clockwise: 1)
		}
		context!.closePath()
		context!.setFillColor(barColor.cgColor)
		context!.fillPath();
		context!.strokePath();
		
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return image
	}
	
	// MARK: - Updating
	
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
		
		currentSelectionX = ((CGFloat(value - minValue) * (size.width)) / CGFloat(maxValue - minValue)) + halfOffset
		currentSelectionY = ((CGFloat(value - minValue) * (size.height)) / CGFloat(maxValue - minValue)) + halfOffset
		
		image = generateHUEImage(size: self.frame.size)
	}
	
	// MARK: - Drawing
	
	override public func draw(_ rect: CGRect) {
		super.draw(rect)
		
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
		
		let circleRect = (direction == .Horizontal ? CGRect(x: circleX, y: 0, width: radius, height: radius) : CGRect(x: 0, y: circleY, width: radius, height: radius))
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
			image.draw(in: imageRect)
		}
		
		let context = UIGraphicsGetCurrentContext();
		circleColor.set()
		context!.addEllipse(inRect: circleRect);
		context!.setFillColor(circleColor.cgColor)
		context!.fillPath();
		context!.strokePath();
		
		let textParagraphStyle = NSMutableParagraphStyle()
		textParagraphStyle.alignment = .center
		
		let attributes: NSDictionary = [NSForegroundColorAttributeName: labelFontColor,
			NSParagraphStyleAttributeName: textParagraphStyle,
			NSFontAttributeName: labelFont!]
		
		let text: NSString = "\(value)"
		var textRect = circleRect
		textRect.origin.y += (textRect.size.height - (labelFont?.lineHeight)!) * 0.5
		text.draw(in: textRect, withAttributes: attributes as? [String : AnyObject])
	}
	
	// MARK: - Touch events
	
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch: AnyObject? = touches.first
		if let point = touch?.location(in: self) {
			handleTouch(touchPoint: point)
		}
	}
	
	public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch: AnyObject? = touches.first
		if let point = touch?.location(in: self) {
			handleTouch(touchPoint: point)
		}
	}
	
	public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch: AnyObject? = touches.first
		if let point = touch?.location(in: self) {
			handleTouch(touchPoint: point)
		}
	}
	
	public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
	}
	
	// MARK: - Touch handling
	
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
		value = minValue + Int(percent * CGFloat(maxValue - minValue))
		
		if delegate != nil {
			delegate.valueChanged(value: value)
		}
		
		setNeedsDisplay()
	}
	
}
