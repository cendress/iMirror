//
//  JournalNotesVC.swift
//  iMirror
//
//  Created by Christopher Endress on 1/23/24.
//

import UIKit

class JournalNotesVC: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
  }
  
  //MARK: - @objc methods
  
  @objc private func closeButtonTapped() {
    self.dismiss(animated: true)
  }
}
