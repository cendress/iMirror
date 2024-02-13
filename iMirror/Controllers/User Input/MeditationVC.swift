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
  private var nextPlayer: AVPlayer?
  private var nextPlayerLayer: AVPlayerLayer?
  
  private var isSoundEnabled: Bool = true {
    didSet {
      updateSoundButtonImage()
    }
  }
  
  private var soundButton: UIBarButtonItem?
  private var changeVideoButtonItem: UIBarButtonItem?
  
  private var videoFiles = ["waves", "jungle", "neonTunnel", "waterfall", "particles"]
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
    
    NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
  }
  
  private func setupView() {
    view.backgroundColor = .systemBackground
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleNavigationBar))
    view.addGestureRecognizer(tapGesture)
    
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    view.addGestureRecognizer(panGesture)
    
    // Add swipe gesture recognizer for left swipe
    //    let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeVideo))
    //    swipeLeftGesture.direction = .left
    //    view.addGestureRecognizer(swipeLeftGesture)
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
  }
  
  @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: view)
    
    switch gesture.state {
    case .changed:
      if let playerLayer = playerLayer {
        let newPosition = CGPoint(x: translation.x + view.bounds.midX, y: playerLayer.position.y)
        playerLayer.position = newPosition
      }
      
    case .ended:
      let dragDistance = translation.x
      if abs(dragDistance) > view.bounds.width / 2 {
        changeVideoToNext()
      } else {
        UIView.animate(withDuration: 0.25) {
          self.playerLayer?.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        }
      }
      
    default:
      break
    }
    
    gesture.setTranslation(.zero, in: view)
  }
  
  private func changeVideoToNext() {
    let nextVideoIndex = (currentVideoIndex + 1) % videoFiles.count
    prepareNextVideo(index: nextVideoIndex)
    
    DispatchQueue.main.async {
      self.playerLayer?.removeFromSuperlayer()
      
      self.player = self.nextPlayer
      self.playerLayer = self.nextPlayerLayer
      self.currentVideoIndex = nextVideoIndex
      
      self.playerLayer?.frame = self.view.bounds
      self.playerLayer?.videoGravity = .resizeAspectFill
      self.view.layer.insertSublayer(self.playerLayer!, at: 0)
      
      self.player?.play()
      
      NotificationCenter.default.addObserver(self, selector: #selector(self.loopVideo), name: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
      
      self.nextPlayer = nil
      self.nextPlayerLayer = nil
    }
  }
  
  private func prepareNextVideo(index: Int) {
    let videoName = videoFiles[index]
    guard let videoPath = Bundle.main.path(forResource: videoName, ofType: "mp4") else {
      print("Next video file not found")
      return
    }
    let videoURL = URL(fileURLWithPath: videoPath)
    nextPlayer = AVPlayer(url: videoURL)
    nextPlayerLayer = AVPlayerLayer(player: nextPlayer)
    guard let nextPlayerLayer = nextPlayerLayer else { return }
    
    nextPlayerLayer.frame = view.bounds
    nextPlayerLayer.videoGravity = .resizeAspectFill
    nextPlayerLayer.opacity = 0
    view.layer.addSublayer(nextPlayerLayer)
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
    
    navigationItem.leftBarButtonItem = soundButton
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
