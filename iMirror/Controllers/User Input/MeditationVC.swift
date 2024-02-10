//
//  MeditationVC.swift
//  iMirror
//
//  Created by Christopher Endress on 2/7/24.
//

import UIKit
import AVFoundation

class MeditationVC: UIViewController {
  
  // MARK: - Initial setup
  
  private var player: AVPlayer?
  private var playerLayer: AVPlayerLayer?
  private var audioPlayer: AVAudioPlayer?
  private var nextPlayerItem: AVPlayerItem?
  
  private var isSoundEnabled: Bool = true {
    didSet {
      updateSoundButtonImage()
    }
  }
  
  private var soundButton: UIBarButtonItem?
  private var changeVideoButtonItem: UIBarButtonItem?
  
  private var videoFiles = ["waves", "purpleTunnel", "tunnel", "rays", "seaweed"]
  private var currentVideoIndex = 0
  
  private var hideNavBarTimer: Timer?
  
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
    playMeditationMusic()
    
    navigationItem.hidesBackButton = true
  }
  
  private func setupView() {
    view.backgroundColor = .systemBackground
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleNavigationBar))
    view.addGestureRecognizer(tapGesture)
  }
  
  // MARK: - @objc methods
  
  @objc private func exitMeditation() {
    showAlert()
  }
  
  @objc func loopVideo() {
    player?.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: { [weak self] _ in
      self?.player?.playImmediately(atRate: 1.0)
    })
  }
  
  @objc private func toggleNavigationBar() {
    guard let isNavigationBarHidden = navigationController?.navigationBar.isHidden else { return }
    
    UIView.animate(withDuration: 0.5) {
      self.navigationController?.navigationBar.alpha = isNavigationBarHidden ? 1.0 : 0.0
    } completion: { _ in
      self.navigationController?.setNavigationBarHidden(!isNavigationBarHidden, animated: false)
      if !isNavigationBarHidden {
        self.navigationController?.navigationBar.alpha = 1.0
      }
    }
    
    // Start timer for 5 seconds if navigation bar is shown
    if isNavigationBarHidden {
      hideNavBarTimer?.invalidate()
      hideNavBarTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
        UIView.animate(withDuration: 0.5) {
          self?.navigationController?.navigationBar.alpha = 0.0
        } completion: { _ in
          self?.navigationController?.setNavigationBarHidden(true, animated: false)
          self?.navigationController?.navigationBar.alpha = 1.0
        }
      }
    } else {
      hideNavBarTimer?.invalidate()
    }
  }
  
  @objc private func toggleSound() {
    isSoundEnabled.toggle()
    if isSoundEnabled {
      audioPlayer?.play()
    } else {
      audioPlayer?.pause()
    }
    
    updateSoundButtonImage()
  }
  
  // MARK: - Video & music methods
  
  private func setupAndPlayVideo() {
    let videoName = videoFiles[currentVideoIndex]
    guard let videoPath = Bundle.main.path(forResource: videoName, ofType: "mp4") else {
      print("Video file not found")
      return
    }
    let videoURL = URL(fileURLWithPath: videoPath)
    player = AVPlayer(url: videoURL)
    playerLayer?.removeFromSuperlayer()
    playerLayer = AVPlayerLayer(player: player)
    guard let playerLayer = playerLayer else { return }
    
    // Video fills entire screen
    playerLayer.frame = view.bounds
    playerLayer.videoGravity = .resizeAspectFill
    view.layer.addSublayer(playerLayer)
    
    player?.play()
    
    NotificationCenter.default.addObserver(self, selector: #selector(loopVideo), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
  }
  
  @objc private func changeVideo() {
    currentVideoIndex += 1
    if currentVideoIndex >= videoFiles.count {
      currentVideoIndex = 0
    }
    
    CATransaction.begin()
    
    CATransaction.setCompletionBlock { [weak self] in
      guard let self = self else { return }
      
      self.setupAndPlayVideo()
      
      self.playerLayer?.opacity = 0
      
      UIView.animate(withDuration: 0.5) {
        self.playerLayer?.opacity = 1
      }
    }
    
    let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
    fadeOutAnimation.fromValue = 1
    fadeOutAnimation.toValue = 0
    fadeOutAnimation.duration = 0.5
    fadeOutAnimation.fillMode = .forwards
    fadeOutAnimation.isRemovedOnCompletion = false
    
    playerLayer?.add(fadeOutAnimation, forKey: "fadeOut")
    
    CATransaction.commit()
  }
  
  private func playMeditationMusic() {
    guard let audioPath = Bundle.main.path(forResource: "meditationMusic", ofType: "mp3"), isSoundEnabled else {
      print("Audio file not found or sound is disabled")
      return
    }
    let audioURL = URL(fileURLWithPath: audioPath)
    
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
      audioPlayer?.prepareToPlay()
      audioPlayer?.play()
      audioPlayer?.numberOfLoops = -1
    } catch {
      print("Could not load music file")
    }
  }
  
  // MARK: - Navigation bar methods
  
  private func setNavBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(white: 0.1, alpha: 1.0).withAlphaComponent(0.5)
    
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    
    navigationController?.navigationBar.shadowImage = UIImage()
    
    updateNavigationItems()
  }
  
  private func updateNavigationItems() {
    let soundButtonImageName = isSoundEnabled ? "speaker.wave.3.fill" : "speaker.slash.fill"
    let soundButtonImage = UIImage(systemName: soundButtonImageName)
    soundButton = UIBarButtonItem(image: soundButtonImage, style: .plain, target: self, action: #selector(toggleSound))
    soundButton?.tintColor = .white
    
    let changeVideoButtonImage = UIImage(systemName: "arrow.triangle.2.circlepath.camera")
    changeVideoButtonItem = UIBarButtonItem(image: changeVideoButtonImage, style: .plain, target: self, action: #selector(changeVideo))
    changeVideoButtonItem?.tintColor = .white
    
    navigationItem.leftBarButtonItems = [soundButton, changeVideoButtonItem].compactMap { $0 }
  }
  
  private func updateSoundButtonImage() {
    let buttonImageName = isSoundEnabled ? "speaker.wave.3.fill" : "speaker.slash.fill"
    soundButton?.image = UIImage(systemName: buttonImageName)
  }
  
  // MARK: - Other methods
  
  private func showAlert() {
    let ac = UIAlertController(title: "Are you sure you want to exit the meditation?", message: nil, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Yes", style: .default) { action in
      self.audioPlayer?.stop()
      self.dismiss(animated: true)
    })
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    
    present(ac, animated: true)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
    audioPlayer?.stop()
  }
}
