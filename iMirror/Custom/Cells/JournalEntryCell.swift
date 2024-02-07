//
//  JournalEntryCell.swift
//  iMirror
//
//  Created by Christopher Endress on 1/28/24.
//

import UIKit

class JournalEntryCell: UITableViewCell {
  
  private let moodLabel = UILabel()
  private let titleLabel = UILabel()
  let noteLabel = UILabel()
  private let dateLabel = UILabel()
  private let timeLabel = UILabel()
  private let moodBackgroundView = UIView()
  private let scrollView = UIScrollView()
  private let emotionsStackView = UIStackView()
  private let containerView = UIView()
  private let dividerView = UIView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
    self.selectionStyle = .none
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupCell() {
    contentView.addSubview(containerView)
    containerView.addSubview(moodBackgroundView)
    containerView.addSubview(moodLabel)
    containerView.addSubview(titleLabel)
    containerView.addSubview(noteLabel)
    containerView.addSubview(dateLabel)
    containerView.addSubview(timeLabel)
    containerView.addSubview(scrollView)
    containerView.addSubview(dividerView)
    scrollView.addSubview(emotionsStackView)
    
    emotionsStackView.axis = .horizontal
    emotionsStackView.alignment = .center
    emotionsStackView.distribution = .equalSpacing
    emotionsStackView.spacing = 8
    
    dividerView.backgroundColor = .lightGray
    dateLabel.textColor = .darkGray
    
    configureAppearance()
    setupContainerViewConstraints()
    setupConstraints()
  }
  
  private func configureAppearance() {
    moodLabel.font = UIFont(name: "Roboto-Regular", size: 22) ?? UIFont.boldSystemFont(ofSize: 22)
    titleLabel.font = UIFont(name: "Roboto-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 20)
    noteLabel.font = UIFont(name: "Roboto-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
    dateLabel.font = UIFont(name: "Roboto-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)
    timeLabel.font = UIFont(name: "Roboto-Light", size: 14) ?? UIFont.systemFont(ofSize: 12)
    
//    moodBackgroundView.backgroundColor = UIColor(named: "AppColor")
    moodBackgroundView.backgroundColor = UIColor { (traitCollection) -> UIColor in
      switch traitCollection.userInterfaceStyle {
      case .dark:
        return UIColor(white: 0.0, alpha: 1.0)
      default:
        return UIColor(white: 0.95, alpha: 1.0)
      }
    }
    
    moodBackgroundView.layer.cornerRadius = 19
    moodBackgroundView.layer.shadowColor = UIColor.systemGray.cgColor
    moodBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 6)
    moodBackgroundView.layer.shadowRadius = 8
    moodBackgroundView.layer.shadowOpacity = 0.3
    
    containerView.layer.cornerRadius = 15
    containerView.layer.shadowColor = UIColor.black.cgColor
    containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
    containerView.layer.shadowRadius = 4
    containerView.layer.shadowOpacity = 0.3
    
    containerView.backgroundColor = UIColor { (traitCollection) -> UIColor in
      switch traitCollection.userInterfaceStyle {
      case .dark:
        return UIColor(white: 0.1, alpha: 1.0)
      default:
        return UIColor.systemBackground
      }
    }
    
    noteLabel.numberOfLines = 2
    
    moodLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
  }
  
  private func setupContainerViewConstraints() {
    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
      containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -ReuseableUI.smallPadding)
    ])
  }
  
  private func setupConstraints() {
    moodBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    moodLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    noteLabel.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    timeLabel.translatesAutoresizingMaskIntoConstraints = false
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    emotionsStackView.translatesAutoresizingMaskIntoConstraints = false
    dividerView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      moodBackgroundView.centerYAnchor.constraint(equalTo: moodLabel.centerYAnchor),
      moodBackgroundView.centerXAnchor.constraint(equalTo: moodLabel.centerXAnchor),
      moodBackgroundView.widthAnchor.constraint(equalTo: moodLabel.widthAnchor, constant: 15),
      moodBackgroundView.heightAnchor.constraint(equalTo: moodBackgroundView.widthAnchor),
      
      moodLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: ReuseableUI.smallPadding),
      moodLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ReuseableUI.smallPadding),
      
      titleLabel.topAnchor.constraint(equalTo: moodBackgroundView.topAnchor, constant: 0),
      titleLabel.leadingAnchor.constraint(equalTo: moodBackgroundView.trailingAnchor, constant: 10),
      titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -ReuseableUI.smallPadding),
      
      timeLabel.leadingAnchor.constraint(equalTo: moodBackgroundView.trailingAnchor, constant: 10),
      timeLabel.bottomAnchor.constraint(equalTo: moodBackgroundView.bottomAnchor, constant: 0),
      
      noteLabel.topAnchor.constraint(equalTo: moodBackgroundView.bottomAnchor, constant: ReuseableUI.smallPadding),
      noteLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ReuseableUI.smallPadding),
      noteLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -ReuseableUI.smallPadding),
      
      scrollView.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 10),
      scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ReuseableUI.smallPadding),
      scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -ReuseableUI.smallPadding),
      
      dividerView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: ReuseableUI.smallPadding),
      dividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
      dividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
      dividerView.heightAnchor.constraint(equalToConstant: 0.25),
      
      dateLabel.topAnchor.constraint(equalTo: dividerView.topAnchor, constant: 8),
      dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ReuseableUI.smallPadding),
      dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -ReuseableUI.smallPadding),
      dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
      
      emotionsStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
      emotionsStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
      emotionsStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
      emotionsStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
      emotionsStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
    ])
  }
  
  func configure(with entry: JournalEntry) {
    moodLabel.text = entry.mood
    titleLabel.text = entry.title
    noteLabel.text = entry.note
    dateLabel.text = formatDate(entry.currentDate ?? Date())
    timeLabel.text = formatTime(entry.currentTime ?? Date())
    createEmotionLabels(for: entry.emotion as? [String] ?? [])
  }
  
  private func createEmotionLabels(for emotions: [String]) {
    emotionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    emotions.forEach { emotion in
      let label = PaddedLabel()
      label.text = emotion.lowercased()
      label.textColor = UIColor.systemGray
//      label.backgroundColor = UIColor(named: "AppColor")
      label.layer.cornerRadius = 10
      label.clipsToBounds = true
      label.textAlignment = .center
      label.font = UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 16)
      
      label.backgroundColor = UIColor { (traitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .dark:
          return UIColor.systemBackground
        default:
          return UIColor(white: 0.95, alpha: 1.0)
        }
      }
      
      label.topInset = 6
      label.bottomInset = 6
      label.leftInset = 10
      label.rightInset = 10
      
      emotionsStackView.addArrangedSubview(label)
    }
  }
  
  private func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d"
    return dateFormatter.string(from: date)
  }
  
  private func formatTime(_ time: Date) -> String {
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "h:mm a"
    return timeFormatter.string(from: time)
  }
}
