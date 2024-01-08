//
//  SettingsVC.swift
//  iMirror
//
//  Created by Christopher Endress on 1/3/24.
//

import UIKit

class SettingsVC: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    self.title = "Settings"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
}
