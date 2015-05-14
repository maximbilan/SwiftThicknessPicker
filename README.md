<h4>Swift Thickness Picker</h4>

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

You can create from Storyboard or XIB. Or create manually:
<pre>
let picker = SwiftThicknessPicker()
</pre>
For handling changing of values you should implement protocol SwiftThicknessPickerDelegate:
<pre>
picker.delegate = self

func valueChanged(value: Int)
}
</pre>

Direction:
<pre>
picker.direction = SwiftThicknessPicker.PickerDirection.Vertical // Vertical, Horizontal
</pre>

