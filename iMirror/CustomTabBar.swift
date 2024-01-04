//
//  CustomTabBar.swift
//  iMirror
//
//  Created by Christopher Endress on 1/3/24.
//

import UIKit

class CustomTabBar: UITabBar {
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    layer.masksToBounds = true
    layer.cornerRadius = 20 
    barTintColor = UIColor.lightGray
    isTranslucent = false
  }
}

