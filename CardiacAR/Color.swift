//
//  Color.swift
//  CardiacAR
//
//  Created by Alex Yang on 11/19/21.
//

import Foundation
import SwiftUI

// Hex color support
extension Color {
	init(hex: String) {
		   let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		   var int: UInt64 = 0
		   Scanner(string: hex).scanHexInt64(&int)
		   let a, r, g, b: UInt64
		   switch hex.count {
		   case 3: // RGB (12-bit)
			   (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		   case 6: // RGB (24-bit)
			   (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
		   case 8: // ARGB (32-bit)
			   (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		   default:
			   (a, r, g, b) = (1, 1, 1, 0)
		   }

		   self.init(
			   .sRGB,
			   red: Double(r) / 255,
			   green: Double(g) / 255,
			   blue:  Double(b) / 255,
			   opacity: Double(a) / 255
		   )
	   }
	
	// Custom color
	static let CardiacARBackgroundBlue = Color(hex: "024380")
	static let navyBlue = Color(red:2/255, green:67/255, blue:128/255)
	static let limeGreen = Color(red: 0.243, green: 0.835, blue: 0.596)
	static let pastelRed = Color(red: 1, green: 0.337, blue: 0.369)
	static let ochreYellow = Color(red: 0.925, green: 0.663, blue: 0.154)
	
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
	   assert(red >= 0 && red <= 255, "Invalid red component")
	   assert(green >= 0 && green <= 255, "Invalid green component")
	   assert(blue >= 0 && blue <= 255, "Invalid blue component")

	   self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
	   self.init(
		   red: (rgb >> 16) & 0xFF,
		   green: (rgb >> 8) & 0xFF,
		   blue: rgb & 0xFF
	   )
   }
}

