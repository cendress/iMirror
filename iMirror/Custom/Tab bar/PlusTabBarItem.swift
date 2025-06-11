//
//  PlusTabBarItem.swift
//  iMirror
//
//  Created by Christopher Endress on 1/7/24.
//

import UIKit

class PlusTabBarItem: UITabBarItem {
  
  override init() {
    super.init()
    setupItem()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupItem()
  }
  
  private func setupItem() {
    self.image = createCustomPlusImage().withRenderingMode(.alwaysOriginal)
    self.selectedImage = createCustomPlusImage().withRenderingMode(.alwaysOriginal)
    self.title = ""
  }
  
  private func createCustomPlusImage() -> UIImage {
    let size = CGSize(width: 80, height: 80)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    
    let context = UIGraphicsGetCurrentContext()!
    context.setShadow(offset: CGSize(width: 0, height: 2), blur: 3, color: UIColor.black.cgColor)
    
    let circlePath = UIBezierPath(ovalIn: CGRect(x: 10, y: 10, width: size.width - 20, height: size.height - 20))
    UIColor(named: "AppColor")!.setFill()
    circlePath.fill()
    
    context.setShadow(offset: CGSize.zero, blur: 0, color: nil)
    
    let plusImage = UIImage(systemName: "plus")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
    let plusImageRect = CGRect(x: size.width/2 - 10, y: size.height/2 - 10, width: 20, height: 20)
    plusImage?.draw(in: plusImageRect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return image
  }
}
