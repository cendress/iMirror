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
    customizeTabBar()
  }
  
  private func setupTabs() {
    let journalVC = JournalVC()
    journalVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "text.book.closed"), tag: 0)
    
    let questionPromptsVC = QuestionPromptsVC()
    questionPromptsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus"), tag: 1)
    
    let settingsVC = SettingsVC()
    settingsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "gear"), tag: 2)
    
    tabBarController?.viewControllers = [journalVC, questionPromptsVC, settingsVC]
  }
  
  private func customizeTabBar() {
    tabBar.barTintColor = UIColor.systemGray
    tabBar.unselectedItemTintColor = UIColor.white
  }
}
