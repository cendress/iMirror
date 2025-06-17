//
//  CustomProgressView.swift
//  iMirror
//
//  Created by Christopher Endress on 1/8/24.
//

import UIKit

final class CustomProgressView: UIView {
    var progressDidChange: ((CGFloat) -> Void)?

    var progress: CGFloat {
        get { _value }
        set { setProgress(newValue, animated: true) }
    }

    private var _value: CGFloat = 0
    private let track = CAGradientLayer()
    private let fill = CAGradientLayer()
    private let knob = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))

    override init(frame: CGRect) { super.init(frame: frame); configure() }
    required init?(coder: NSCoder) { super.init(coder: coder); configure() }

    private func configure() {
        isAccessibilityElement = true
        accessibilityTraits    = .updatesFrequently

        setupLayers(); setupKnob(); addGesture()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let h = bounds.height, w = bounds.width

        track.frame = bounds; track.cornerRadius = h / 2
        fill.frame  = CGRect(x: 0, y: 0, width: w * _value, height: h)
        fill.cornerRadius = h / 2

        knob.layer.cornerRadius = knob.bounds.width / 2
        knob.center = CGPoint(x: w * _value, y: h / 2)
    }

    func setProgress(_ value: CGFloat, animated: Bool) {
        let clamped = min(max(0, value), 1)
        guard clamped != _value else { return }
        _value = clamped

        CATransaction.begin(); CATransaction.setDisableActions(!animated)
        fill.frame.size.width = bounds.width * clamped
        CATransaction.commit()

        UIView.animate(withDuration: animated ? 0.1 : 0) { self.knob.center.x = self.bounds.width * clamped }
    }

    private func setupLayers() {
        track.colors = [UIColor.secondarySystemFill.cgColor, UIColor.secondarySystemFill.withAlphaComponent(0.2).cgColor]
        track.startPoint = .zero; track.endPoint = CGPoint(x: 0, y: 1)
        layer.addSublayer(track)

        let brand = UIColor(named: "AppColor")!
        fill.colors = [brand.cgColor, brand.withAlphaComponent(0.6).cgColor]
        fill.startPoint = CGPoint(x: 0, y: 0.5); fill.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(fill)
    }

    private func setupKnob() {
        knob.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        knob.clipsToBounds = true
        knob.contentView.backgroundColor = UIColor(named: "AppColor")!
        knob.layer.shadowColor = UIColor.black.cgColor
        knob.layer.shadowOpacity = 0.25
        knob.layer.shadowOffset = CGSize(width: 0, height: 2)
        knob.layer.shadowRadius = 4
        addSubview(knob)
    }

    private func addGesture() {
        knob.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
    }

    @objc private func handlePan(_ g: UIPanGestureRecognizer) {
        let pct = min(max(0, g.location(in: self).x / bounds.width), 1)

        switch g.state {
        case .began:
            animateKnob(scale: 1.15, shadow: 0.5)
        case .changed:
            _value = pct; progressDidChange?(pct); setNeedsLayout()
        case .ended, .cancelled, .failed:
            Haptic.impact(.light)
            animateKnob(scale: 1, shadow: 0.25)
        default: break
        }
    }

    private func animateKnob(scale: CGFloat, shadow: Float) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3, animations: { self.knob.transform = .init(scaleX: scale, y: scale); self.knob.layer.shadowOpacity = shadow })
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        knob.frame.insetBy(dx: -20, dy: -20).contains(point) ? knob : super.hitTest(point, with: event)
    }
}
