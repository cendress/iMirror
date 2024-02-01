//
//  PaddedLabel.swift
//  iMirror
//
//  Created by Christopher Endress on 2/1/24.
//

import UIKit

class PaddingLabel: UILabel {
  var topInset: CGFloat = 0
  var bottomInset: CGFloat = 0
  var leftInset: CGFloat = 0
  var rightInset: CGFloat = 0
  
  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    super.drawText(in: rect.inset(by: insets))
  }
  
  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    let width = size.width + leftInset + rightInset
    let height = size.height + topInset + bottomInset
    return CGSize(width: width, height: height)
  }
  
  override var bounds: CGRect {
    didSet {
      preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
    }
  }
}
