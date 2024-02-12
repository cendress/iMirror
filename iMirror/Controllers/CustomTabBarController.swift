//
//  CustomTabBarVC.swift
//  iMirror
//
//  Created by Christopher Endress on 1/3/24.
//

import UIKit
import UIOnboarding

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setValue(CustomTabBar(), forKey: "tabBar")
    setupTabs()
    self.delegate = self
    self.selectedIndex = 0
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleJournalEntrySave), name: .didSaveJournalEntry, object: nil)
  }
  
  //MARK: - Present onboarding method
  
  private func presentOnboarding() {
    // Check if it's the first launch
    let isFirstLaunch = UserDefaults.standard.bool(forKey: "HasLaunchedBefore")
    if !isFirstLaunch {
      UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
      UserDefaults.standard.synchronize()
      
      // Present the onboarding view controller
      let onboardingController = UIOnboardingViewController(withConfiguration: .setUp())
      onboardingController.delegate = self
      onboardingController.modalPresentationStyle = .fullScreen
      self.present(onboardingController, animated: true)
    }
  }
  
  // MARK: - Tab bar configuration method
  
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
  
  // MARK: - Tab bar controller delegate method
  
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    if viewController.tabBarItem is PlusTabBarItem {
      presentCurrentMoodVC()
      return false
    }
    return true
  }
  
  private func presentCurrentMoodVC() {
    if (viewControllers?.first as? UINavigationController)?.viewControllers.first is JournalVC {
      let questionPromptsVC = CurrentMoodVC()
      
      questionPromptsVC.hidesBottomBarWhenPushed = true
      let navController = UINavigationController(rootViewController: questionPromptsVC)
      
      navController.modalPresentationStyle = .fullScreen
      self.present(navController, animated: true, completion: nil)
    }
  }
  
  //MARK: - @objc method
  
  @objc private func handleJournalEntrySave() {
    self.selectedIndex = 0
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

extension CustomTabBarController: UIOnboardingViewControllerDelegate {
  func didFinishOnboarding(onboardingViewController: UIOnboardingViewController) {
    onboardingViewController.dismiss(animated: true, completion: nil)
  }
}
