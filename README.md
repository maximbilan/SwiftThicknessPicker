<h4>Swift Thickness Picker</h4>

[![Version](https://img.shields.io/cocoapods/v/SwiftThicknessPicker.svg?style=flat)](http://cocoadocs.org/docsets/SwiftThicknessPicker)
[![License](https://img.shields.io/cocoapods/l/SwiftThicknessPicker.svg?style=flat)](http://cocoadocs.org/docsets/SwiftThicknessPicker)
[![Platform](https://img.shields.io/cocoapods/p/SwiftThicknessPicker.svg?style=flat)](http://cocoadocs.org/docsets/SwiftThicknessPicker)

Simple iOS thickness picker. Supports two modes: vertical and horizontal. 

![alt tag](https://raw.github.com/maximbilan/SwiftThicknessPicker/master/img/img1.png)

<b>Manual installation:</b>
<pre>
Copy SwiftThicknessPicker.swift to your project.
</pre>

<b>Cocoapods:</b>
<pre>
pod 'SwiftThicknessPicker'
</pre>

<b>How to use:</b>

You can create from <i>Storyboard</i> or <i>XIB</i>. Or create manually:
<pre>
let picker = SwiftThicknessPicker()
</pre>
For handling changing of values you should implement protocol <i>SwiftThicknessPickerDelegate</i>:
<pre>
picker.delegate = self

func valueChanged(value: Int)
}
</pre>

Direction:
<pre>
picker.direction = SwiftThicknessPicker.PickerDirection.Vertical // Vertical, Horizontal
</pre>

Also you can change current value, maximum value or minimum value, for example:
<pre>
picker.currentValue = 0
picker.maxValue = 30
picker.minValue = 1
</pre>
And other settings:
<pre>
labelFontColor // Font color of the moving label
labelBackgroundColor // Background color of the moving label
labelFont // Font of the moving label
</pre>


