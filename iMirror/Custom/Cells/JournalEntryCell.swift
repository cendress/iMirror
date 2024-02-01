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
  private let noteLabel = UILabel()
  private let dateLabel = UILabel()
  private let timeLabel = UILabel()
  private let moodBackgroundView = UIView()
  private let scrollView = UIScrollView()
  private let emotionsStackView = UIStackView()
  private let containerView = UIView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
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
    scrollView.addSubview(emotionsStackView)
    
    emotionsStackView.axis = .horizontal
    emotionsStackView.alignment = .center
    emotionsStackView.distribution = .equalSpacing
    emotionsStackView.spacing = 8
    
    configureAppearance()
    setupContainerViewConstraints()
    setupConstraints()
  }
  
  private func configureAppearance() {
    moodLabel.font = UIFont(name: "Roboto-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
    titleLabel.font = UIFont(name: "Roboto-Bold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
    noteLabel.font = UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
    dateLabel.font = UIFont(name: "Roboto-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
    timeLabel.font = UIFont(name: "Roboto-Thin", size: 12) ?? UIFont.systemFont(ofSize: 12)
    
    moodBackgroundView.backgroundColor = UIColor.systemGray5
    moodBackgroundView.layer.cornerRadius = 20
    
    containerView.backgroundColor = UIColor.white
    containerView.layer.borderWidth = 1
    containerView.layer.borderColor = UIColor.black.cgColor
    containerView.layer.cornerRadius = 20
    containerView.layer.shadowColor = UIColor.black.cgColor
    containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
    containerView.layer.shadowRadius = 4
    containerView.layer.shadowOpacity = 0.1
    containerView.clipsToBounds = true
  }
  
  private func setupContainerViewConstraints() {
    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
      containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -20)
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
    
    NSLayoutConstraint.activate([
      moodBackgroundView.centerYAnchor.constraint(equalTo: moodLabel.centerYAnchor),
      moodBackgroundView.centerXAnchor.constraint(equalTo: moodLabel.centerXAnchor),
      moodBackgroundView.widthAnchor.constraint(equalTo: moodLabel.widthAnchor, constant: 20),
      moodBackgroundView.heightAnchor.constraint(equalTo: moodBackgroundView.widthAnchor),
      
      moodLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
      moodLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
      
      titleLabel.topAnchor.constraint(equalTo: moodLabel.bottomAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
      titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
      
      noteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
      noteLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
      noteLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
      
      dateLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 10),
      dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
      dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
      
      timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
      timeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
      timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
      
      scrollView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
      scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
      scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
      scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
      
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
      label.textColor = UIColor.white
      label.backgroundColor = UIColor(named: "AppColor")
      label.layer.cornerRadius = 9
      label.clipsToBounds = true
      label.textAlignment = .center
      label.font = UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 16)
      
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
