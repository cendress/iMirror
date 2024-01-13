//
//  CustomProgressView.swift
//  iMirror
//
//  Created by Christopher Endress on 1/8/24.
//

import UIKit

class CustomProgressView: UIView {
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
    setupLayers()
    setupSliderKnob()

    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    sliderKnob.addGestureRecognizer(panGesture)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
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
    let sliderPosition = bounds.width * progress
    
    let progressLayerWidth = sliderPosition + sliderKnob.frame.width / 2
    progressLayer.frame = CGRect(x: 0, y: 0, width: progressLayerWidth, height: bounds.height)
    
    sliderKnob.center = CGPoint(x: sliderPosition, y: bounds.height / 2)
  }
  
  @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    let location = gesture.location(in: self)
    let width = bounds.width
    progress = min(max(0, location.x / width), 1)
    updateSliderPosition()
    
    switch gesture.state {
    case .began, .changed:
      sliderKnob.layer.shadowColor = UIColor.gray.cgColor
      sliderKnob.layer.shadowRadius = 8
      sliderKnob.layer.shadowOpacity = 3
      sliderKnob.layer.shadowOffset = CGSize(width: 0, height: 0)
    default:
      sliderKnob.layer.shadowOpacity = 0
    }
  }
}
