//
//  ReuseableUI.swift
//  iMirror
//
//  Created by Christopher Endress on 1/22/24.
//

import Foundation
import UIKit

struct ReuseableUI {
  
  static let largePadding: CGFloat = 60
  static let padding: CGFloat = 40
  static let smallPadding: CGFloat = 20
  
  static func createLabel(withText text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = UIFont(name: "Roboto-Medium", size: 30)
    label.lineBreakMode = .byTruncatingTail
    label.textAlignment = .center
    label.numberOfLines = 0
    label.adjustsFontSizeToFitWidth = true
    label.sizeToFit()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }
  
  static func createButton(withTitle title: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18)
    button.backgroundColor = .tintColor
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 30
    button.layer.borderWidth = 4
    button.layer.masksToBounds = false
    
    button.layer.shadowColor = UIColor.systemGray.cgColor
    button.layer.shadowOffset = CGSize(width: 0, height: 4)
    button.layer.shadowRadius = 10
    button.layer.shadowOpacity = 0.5
    
    return button
  }
  
  static func backgroundColorForTraitCollection(_ traitCollection: UITraitCollection) -> UIColor {
    switch traitCollection.userInterfaceStyle {
    case .dark:
      return UIColor(white: 0.0, alpha: 1.0)
    default:
      return UIColor(white: 0.95, alpha: 1.0)
    }
  }
  
  static func colorForTraitCollection(_ traitCollection: UITraitCollection) -> UIColor {
    switch traitCollection.userInterfaceStyle {
    case .dark:
      return UIColor(white: 0.1, alpha: 1.0)
    default:
      return UIColor.systemBackground
    }
  }
}
