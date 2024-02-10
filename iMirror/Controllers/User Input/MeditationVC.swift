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
  
  private var isSoundEnabled: Bool = true
  
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
  
  //MARK: - @objc methods
  
  @objc private func exitMeditation() {
    showAlert()
  }
  
  @objc func loopVideo() {
    player?.seek(to: .zero)
    player?.play()
  }
  
  @objc private func toggleNavigationBar() {
    guard let isNavigationBarHidden = navigationController?.navigationBar.isHidden else { return }
    
    UIView.animate(withDuration: 0.5) {
      self.navigationController?.navigationBar.alpha = isNavigationBarHidden ? 1.0 : 0.0
    } completion: { _ in
      self.navigationController?.setNavigationBarHidden(!isNavigationBarHidden, animated: false)
      self.navigationController?.navigationBar.alpha = 1.0
    }
  }
  
  //MARK: - Video & music methods
  
  private func setupAndPlayVideo() {
    guard let videoPath = Bundle.main.path(forResource: "rays", ofType: "mp4") else {
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
  
  private func playMeditationMusic() {
    guard let audioPath = Bundle.main.path(forResource: "meditationMusic", ofType: "mp3") else {
      print("Audio file not found")
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
  
  //MARK: - Navigation bar methods
  
  private func setNavBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    //    appearance.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    appearance.backgroundColor = UIColor(white: 0.1, alpha: 1.0).withAlphaComponent(0.5)
    
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    
    navigationController?.navigationBar.shadowImage = UIImage()
    
    updateSoundToggleButton()
  }
  
  private func updateSoundToggleButton() {
    let buttonImageName = isSoundEnabled ? "speaker.wave.3.fill" : "speaker.slash.fill"
    let buttonImage = UIImage(systemName: buttonImageName)
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(toggleSound))
  }
  
  @objc private func toggleSound() {
    isSoundEnabled.toggle()
    if isSoundEnabled {
      audioPlayer?.play()
    } else {
      audioPlayer?.pause()
    }
    updateSoundToggleButton()
  }
  
  //MARK: - Other methods
  
  private func showAlert() {
    let ac = UIAlertController(title: "Are you sure you want to exit the meditation?", message: nil, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Yes", style: .default) { action in
      // Stop audio playing
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
