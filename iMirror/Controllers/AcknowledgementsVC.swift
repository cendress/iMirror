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
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left.circle.fill"), style: .plain, target: self, action: #selector(backButtonTapped))
    
    NotificationCenter.default.addObserver(self, selector: #selector(updateAppAppearance), name: NSNotification.Name("UpdateAppAppearance"), object: nil)
  }
  
  @objc func updateAppAppearance() {
    let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
    self.view.window?.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
  }
  
  @objc private func backButtonTapped() {
    navigationController?.popViewController(animated: true)
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
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
