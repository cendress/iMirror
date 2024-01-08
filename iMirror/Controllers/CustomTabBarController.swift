//
//  CustomTabBarVC.swift
//  iMirror
//
//  Created by Christopher Endress on 1/3/24.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setValue(CustomTabBar(), forKey: "tabBar")
    setupTabs()
    self.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.selectedIndex = 0
  }
  
  //MARK: - Tab bar configuration method
  
  private func setupTabs() {
    let journalVC = JournalVC()
    journalVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "text.book.closed"), tag: 0)
    
    let journalNavController = UINavigationController(rootViewController: journalVC)
    
    let questionPromptsVC = CurrentMoodVC()
    questionPromptsVC.tabBarItem = PlusTabBarItem()
    
    let settingsVC = SettingsVC()
    settingsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "gear"), tag: 2)
    
    let settingsNavController = UINavigationController(rootViewController: settingsVC)
    
    viewControllers = [journalNavController, questionPromptsVC, settingsNavController]
  }
  
  //MARK: - Tab bar controller delegate method
  
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    if let plusItem = item as? PlusTabBarItem {
      plusItem.animateOnTap()
      
      let questionPromptsVC = CurrentMoodVC()
      questionPromptsVC.hidesBottomBarWhenPushed = true
      let navController = UINavigationController(rootViewController: questionPromptsVC)
      navController.modalPresentationStyle = .fullScreen 
      self.present(navController, animated: true, completion: nil)
    }
  }

}
