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
  private var hasChangedVideo: Bool = false
  
  private var isSoundEnabled: Bool = true {
    didSet {
      updateSoundButtonImage()
    }
  }
  
  private var soundButton: UIBarButtonItem?
  private var changeVideoButtonItem: UIBarButtonItem?
  
  private var videoFiles = ["waterfall", "waves", "jungle", "neonTunnel", "particles"]
  private var audioFiles = ["waterfallMusic", "wavesMusic", "jungleMusic", "neonTunnelMusic", "particlesMusic"]
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
    
    navigationItem.hidesBackButton = true
    
    NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
  }
  
  private func setupView() {
    view.backgroundColor = .systemBackground
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleNavigationBar))
    view.addGestureRecognizer(tapGesture)
    
    // Add swipe gesture recognizer for left swipe
    let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeVideo))
    swipeLeftGesture.direction = .left
    view.addGestureRecognizer(swipeLeftGesture)
  }
  
  // MARK: - @objc methods
  
  @objc func updateAppAppearance() {
    let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
    self.view.window?.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
  }
  
  @objc private func exitMeditation() {
      Haptic.impact(.heavy)
    audioPlayer?.stop()
    dismiss(animated: true)
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
      Haptic.impact(.light)
    isSoundEnabled.toggle()
    if isSoundEnabled {
      audioPlayer?.play()
    } else {
      audioPlayer?.pause()
    }
    
    updateSoundButtonImage()
  }
  
  //MARK: - Notification handler methods
  
  @objc private func appDidEnterBackground() {
    player?.pause()
    audioPlayer?.pause()
  }
  
  @objc private func appWillEnterForeground() {
    if isSoundEnabled {
      audioPlayer?.play()
    }
    player?.play()
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
    
    playMeditationMusic()
  }
  
  @objc private func changeVideo() {
      Haptic.impact(.light)
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
    
    hasChangedVideo = true
  }
  
  @objc private func goBackToPreviousVideo() {
      Haptic.impact(.light)
    guard hasChangedVideo else { return }
    
    if currentVideoIndex == 0 {
      currentVideoIndex = videoFiles.count - 1
    } else {
      currentVideoIndex -= 1
    }
    
    hasChangedVideo = true
    
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
    // Stop the previous audio player before initializing a new one
    audioPlayer?.stop()
    audioPlayer?.currentTime = 0
    
    guard let audioPath = Bundle.main.path(forResource: audioFiles[currentVideoIndex], ofType: "mp3"), isSoundEnabled else {
      print("Audio file not found or sound is disabled")
      return
    }
    let audioURL = URL(fileURLWithPath: audioPath)
    
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
      audioPlayer?.prepareToPlay()
      // Delay audio playback slightly to ensure smooth transition
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
        self?.audioPlayer?.play()
      }
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
    
    let changeVideoButtonImage = UIImage(systemName: "gobackward")
    changeVideoButtonItem = UIBarButtonItem(image: changeVideoButtonImage, style: .plain, target: self, action: #selector(goBackToPreviousVideo))
    changeVideoButtonItem?.tintColor = .white
    
    navigationItem.leftBarButtonItems = [soundButton, changeVideoButtonItem].compactMap { $0 }
  }
  
  private func updateSoundButtonImage() {
    let buttonImageName = isSoundEnabled ? "speaker.wave.3.fill" : "speaker.slash.fill"
    soundButton?.image = UIImage(systemName: buttonImageName)
  }
  
  // MARK: - Other methods
  
  deinit {
    NotificationCenter.default.removeObserver(self)
    audioPlayer?.stop()
  }
}
