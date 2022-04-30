//
//  Font.swift
//  CardiacAR
//
//  Created by Alex Yang on 11/19/21.
//

import Foundation
import SwiftUI

extension Font {
	static var customStyle: Font {
		return Font.system(size: 25*screenSize.height*0.001)
	}
	
	static var subheadingStyle: Font {
		return Font.system(size: 18)
	}
}
