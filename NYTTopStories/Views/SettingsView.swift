//
//  SettingsView.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/20/23.
//

import UIKit


class SettingsView: UIView {
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.alpha = 0.5
        label.numberOfLines = 1
        label.text = "select a default news section"
        label.textAlignment = .center
        return label
    }()
    
    public lazy var pickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setPickerViewConstraints()
        setLabelConstraints()
    }
    
    private func setLabelConstraints() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: pickerView.topAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    private func setPickerViewConstraints() {
        addSubview(pickerView)
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
