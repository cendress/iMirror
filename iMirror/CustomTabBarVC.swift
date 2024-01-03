//
//  CustomTabBarVC.swift
//  iMirror
//
//  Created by Christopher Endress on 1/3/24.
//

import UIKit

class CustomTabBarVC: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabs()
  }
  
  private func setupTabs() {
    let journalVC = JournalVC()
    journalVC.view.backgroundColor = .blue
    journalVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "text.book.closed"), tag: 0)
    
    let questionPromptsVC = QuestionPromptsVC()
    questionPromptsVC.view.backgroundColor = .yellow
    questionPromptsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus"), tag: 1)
    
    let settingsVC = SettingsVC()
    settingsVC.view.backgroundColor = .green
    settingsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "gear"), tag: 2)
    
    viewControllers = [journalVC, questionPromptsVC, settingsVC]
  }
}
