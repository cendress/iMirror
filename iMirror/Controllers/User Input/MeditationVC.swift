//
//  MeditationVC.swift
//  iMirror
//
//  Created by Christopher Endress on 2/7/24.
//

import UIKit
import AVFoundation

class MeditationVC: UIViewController {
  var player: AVPlayer?
  var playerLayer: AVPlayerLayer?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exitMeditation))
    navigationItem.rightBarButtonItem?.tintColor = .red
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    
    setupAndPlayVideo()
  }
  
  private func setupView() {
    view.backgroundColor = .systemBackground
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleNavigationBar))
    view.addGestureRecognizer(tapGesture)
  }
  
  private func setupAndPlayVideo() {
    guard let videoPath = Bundle.main.path(forResource: "YourVideoFileName", ofType: "mp4") else {
      print("Video file not found")
      return
    }
    let videoURL = URL(fileURLWithPath: videoPath)
    player = AVPlayer(url: videoURL)
    playerLayer = AVPlayerLayer(player: player)
    
    guard let playerLayer = playerLayer else { return }
    
    // Video fills entire screen
    playerLayer.frame = self.view.bounds
    playerLayer.videoGravity = .resizeAspectFill
    view.layer.addSublayer(playerLayer)
    
    player?.play()
  }
  
  @objc private func toggleNavigationBar() {
    let isNavigationBarHidden = navigationController?.navigationBar.isHidden ?? true
    
    // Toggle state of navigation bar
    navigationController?.setNavigationBarHidden(!isNavigationBarHidden, animated: true)
  }
  
  @objc private func exitMeditation() {
    self.dismiss(animated: true, completion: nil)
  }
}
