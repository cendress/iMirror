//
//  MeditationVC.swift
//  iMirror
//
//  Created by Christopher Endress on 2/7/24.
//

import UIKit
import AVFoundation

class MeditationVC: UIViewController {
  
  //MARK: - Initial setup
  
  private var player: AVPlayer?
  private var playerLayer: AVPlayerLayer?
  private var audioPlayer: AVAudioPlayer?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setNavBarAppearance()
    
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exitMeditation))
    navigationItem.rightBarButtonItem?.tintColor = .red
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAndPlayVideo()
    
    navigationItem.hidesBackButton = true
  }
  
  private func setupView() {
    view.backgroundColor = .systemBackground
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleNavigationBar))
    view.addGestureRecognizer(tapGesture)
  }
  
  //MARK: - @objc methods
  
  @objc private func exitMeditation() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc func loopVideo() {
    player?.seek(to: .zero)
    player?.play()
  }
  
  @objc private func toggleNavigationBar() {
    guard let isNavigationBarHidden = navigationController?.navigationBar.isHidden else { return }
    
    UIView.animate(withDuration: 0.3) {
      self.navigationController?.navigationBar.alpha = isNavigationBarHidden ? 1.0 : 0.0
    } completion: { _ in
      self.navigationController?.setNavigationBarHidden(!isNavigationBarHidden, animated: false)
      self.navigationController?.navigationBar.alpha = 1.0
    }
  }
  
  //MARK: - Video methods
  
  private func setupAndPlayVideo() {
    guard let videoPath = Bundle.main.path(forResource: "stars", ofType: "mp4") else {
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
    
    NotificationCenter.default.addObserver(self, selector: #selector(loopVideo), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
  }
  
  //MARK: - UI methods
  
  private func setNavBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    
    navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  //MARK: - Other methods
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
