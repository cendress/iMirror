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
    self.selectedImage = createCustomPlusImage().withRenderingMode(.alwaysTemplate)
    self.title = ""
  }
  
  private func createCustomPlusImage() -> UIImage {
    let size = CGSize(width: 75, height: 75)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    
    let context = UIGraphicsGetCurrentContext()!
    context.setShadow(offset: CGSize(width: 0, height: 3), blur: 6, color: UIColor.black.cgColor)
    
    let circlePath = UIBezierPath(ovalIn: CGRect(x: 5, y: 5, width: size.width - 10, height: size.height - 10))
    UIColor.systemBackground.setFill()
    circlePath.fill()
    
    let plusImage = UIImage(systemName: "plus")?.withTintColor(UIColor(named: "AppColor")!, renderingMode: .alwaysOriginal)
    let plusImageRect = CGRect(x: size.width/2 - 10, y: size.height/2 - 10, width: 20, height: 20)
    plusImage?.draw(in: plusImageRect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return image
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    addBounceAnimation()
  }
  
  private func addBounceAnimation() {
    let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
    bounceAnimation.values = [1.0, 1.4, 0.9, 1.2, 1.0]
    bounceAnimation.duration = 0.6
    bounceAnimation.calculationMode = .cubic
    (self.value(forKey: "view") as AnyObject).layer.add(bounceAnimation, forKey: nil)
  }
}

