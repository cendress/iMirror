//
//  QuestionPromptsVC.swift
//  iMirror
//
//  Created by Christopher Endress on 1/3/24.
//

import UIKit

class CurrentMoodVC: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
  }
  
  @objc func closeButtonTapped() {
    self.dismiss(animated: true)
  }
  
  private func createLabel(withText text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }
  
  private func createProgressView(withProgress progress: Float) -> CustomProgressView {
    let progressView = CustomProgressView()
    progressView.progress = CGFloat(progress)
    progressView.translatesAutoresizingMaskIntoConstraints = false
    return progressView
  }
  
  private static func createButton(withTitle title: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }
  
}
