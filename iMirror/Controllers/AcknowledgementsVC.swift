//
//  AcknowledgementsVC.swift
//  iMirror
//
//  Created by Christopher Endress on 2/14/24.
//

import UIKit
import WebKit

class AcknowledgmentsVC: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    self.title = "Acknowledgments"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  private func setupLabel() {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.text = "Here we list acknowledgments..."
    view.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
    ])
  }
}
