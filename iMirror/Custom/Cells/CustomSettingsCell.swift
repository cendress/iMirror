//
//  CustomSettingsCell.swift
//  iMirror
//
//  Created by Christopher Endress on 2/15/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
  let cellPadding: CGFloat = 16
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: cellPadding, bottom: 0, right: cellPadding))
  }
}

