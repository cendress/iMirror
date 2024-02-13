//
//  CustomProgressView.swift
//  iMirror
//
//  Created by Christopher Endress on 1/8/24.
//

import UIKit

class CustomProgressView: UIView {
  var progressDidChange: ((CGFloat) -> Void)?
  
  private var progressLayer = CALayer()
  private var trackLayer = CALayer()
  private let sliderKnob = UIView()
  
  var progress: CGFloat = 0 {
    didSet {
      updateSliderPosition()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    setupLayers()
    setupSliderKnob()
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    sliderKnob.addGestureRecognizer(panGesture)
  }
  
  private func setupLayers() {
    trackLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
    layer.addSublayer(trackLayer)
    
    progressLayer.backgroundColor = UIColor(named: "AppColor")?.cgColor
    layer.addSublayer(progressLayer)
  }
  
  private func setupSliderKnob() {
    sliderKnob.backgroundColor = UIColor(named: "AppColor")
    sliderKnob.layer.cornerRadius = 15
    sliderKnob.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    sliderKnob.isUserInteractionEnabled = true
    sliderKnob.layer.shadowColor = UIColor.systemGray.cgColor
    sliderKnob.layer.shadowOffset = CGSize(width: 0, height: 5)
    sliderKnob.layer.shadowRadius = 8
    sliderKnob.layer.shadowOpacity = 0.3
    addSubview(sliderKnob)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let cornerRadius = bounds.size.height / 2
    trackLayer.cornerRadius = cornerRadius
    progressLayer.cornerRadius = cornerRadius
    
    trackLayer.frame = bounds
    updateSliderPosition()
  }
  
  private func updateSliderPosition() {
    let sliderPosition = self.bounds.width * self.progress
    self.progressLayer.frame = CGRect(x: 0, y: 0, width: sliderPosition, height: self.bounds.height)
    self.sliderKnob.center = CGPoint(x: sliderPosition, y: self.bounds.height / 2)
  }
  
  @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    let location = gesture.location(in: self)
    let width = bounds.width
    let newProgress = min(max(0, location.x / width), 1)
    
    progress = newProgress
    progressDidChange?(progress)
    updateSliderPosition()
    
    switch gesture.state {
    case .began:
      UIView.animate(withDuration: 0.1) {
        self.sliderKnob.layer.shadowOpacity = 1
      }
    case .ended, .cancelled:
      UIView.animate(withDuration: 0.1) {
        self.sliderKnob.layer.shadowOpacity = 0
      }
    default:
      break
    }
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let knobFrame = sliderKnob.frame.insetBy(dx: -10, dy: -10)
    if knobFrame.contains(point) {
      return sliderKnob
    }
    return super.hitTest(point, with: event)
  }
}
