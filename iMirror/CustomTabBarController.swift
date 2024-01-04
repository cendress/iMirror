//
//  CustomTabBarVC.swift
//  iMirror
//
//  Created by Christopher Endress on 1/3/24.
//

import UIKit

class CustomTabBarController: UITabBarController {
  
  //MARK: - init methods
  
  init() {
    super.init(nibName: nil, bundle: nil)
    // Use CustomTabBar
    self.setValue(CustomTabBar(), forKey: "tabBar")
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    // Use CustomTabBar
    self.setValue(CustomTabBar(), forKey: "tabBar")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    customizeTabBar()
    setupTabs()
  }
  
  //MARK: - Tab bar configuration method
  
  private func setupTabs() {
    let journalVC = JournalVC()
    journalVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "text.book.closed"), tag: 0)
    
    let questionPromptsVC = QuestionPromptsVC()
    questionPromptsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus"), tag: 1)
    
    let settingsVC = SettingsVC()
    settingsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "gear"), tag: 2)
    
    viewControllers = [journalVC, questionPromptsVC, settingsVC]
  }
  
  private func customizeTabBar() {
    // Customize the tab bar using the CustomTabBar's properties
    if let customTabBar = tabBar as? CustomTabBar {
      // Further customization if needed
    }
  }
}
