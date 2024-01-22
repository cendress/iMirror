//
//  EmotionListVC.swift
//  iMirror
//
//  Created by Christopher Endress on 1/22/24.
//

import UIKit

class EmotionListVC: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
  }
  
  @objc private func closeButtonTapped() {
    self.dismiss(animated: true)
  }
  
}
