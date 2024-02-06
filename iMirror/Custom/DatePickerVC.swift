//
//  DatePickerVC.swift
//  iMirror
//
//  Created by Christopher Endress on 2/6/24.
//

import UIKit

class DatePickerVC: UIViewController {
  var datePicker: UIDatePicker!
  var completion: ((Date?) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    setupDatePicker()
    setupButtons()
  }
  
  private func setupDatePicker() {
    datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.preferredDatePickerStyle = .inline
    datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    
    view.addSubview(datePicker)
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      // Slightly below half of the screen
      datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
      datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
  private func setupButtons() {
    let doneButton = UIButton(type: .system)
    doneButton.setTitle("Done", for: .normal)
    doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
    
    let cancelButton = UIButton(type: .system)
    cancelButton.setTitle("Cancel", for: .normal)
    cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    
    view.addSubview(doneButton)
    view.addSubview(cancelButton)
    
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: ReuseableUI.smallPadding),
      doneButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
      cancelButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: ReuseableUI.smallPadding),
      cancelButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10)
    ])
  }
  
  @objc func dateChanged(_ sender: UIDatePicker) {
    // Might want to add a gesture to dismiss
  }
  
  @objc func doneAction() {
    completion?(datePicker.date)
    dismiss(animated: true, completion: nil)
  }
  
  @objc func cancelAction() {
    completion?(nil)
    dismiss(animated: true, completion: nil)
  }
}
