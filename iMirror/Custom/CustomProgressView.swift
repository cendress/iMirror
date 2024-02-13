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
  private let surroundingView = UIView()
  
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
    setupSurroundingView()
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    sliderKnob.addGestureRecognizer(panGesture)
  }
  
  private func setupSurroundingView() {
    addSubview(surroundingView)
    surroundingView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
    surroundingView.layer.cornerRadius = 20
    surroundingView.alpha = 0
    surroundingView.isUserInteractionEnabled = false
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
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleKnobTap(_:)))
    sliderKnob.addGestureRecognizer(tapGesture)
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
  }
  
  @objc private func handleKnobTap(_ gesture: UITapGestureRecognizer) {
    surroundingView.frame = CGRect(x: sliderKnob.frame.origin.x - 10, y: sliderKnob.frame.origin.y - 10, width: sliderKnob.frame.width + 40, height: sliderKnob.frame.height + 40)
    UIView.animate(withDuration: 0.25, animations: {
      self.surroundingView.alpha = 1
    }) { _ in
      UIView.animate(withDuration: 0.25, delay: 1.0, options: [], animations: {
        self.surroundingView.alpha = 0
      }, completion: nil)
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
