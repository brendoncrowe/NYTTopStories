//
//  SettingsViewController.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/18/23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let settingsView = SettingsView()
    private let sections = ["Arts", "Automobiles", "Books", "Business", "Fashion", "Food", "Health", "Insider", "Magazine", "Movies", "NYRegion", "Opinion", "Politics", "RealEstate", "Science", "Sports", "SundayReview", "Technology", "Theater", "Travel", "Upshot", "US", "World"]
    public var userPreference: UserPreference
    
    init(_ userPreference: UserPreference) {
        self.userPreference = userPreference
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func loadView() {
        super.loadView()
        view = settingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView.pickerView.delegate = self
        settingsView.pickerView.dataSource = self
        view.backgroundColor = .systemGroupedBackground
        
        
        if let sectionName = userPreference.getSectionName() {
            if let index = sections.firstIndex(of: sectionName) {
                settingsView.pickerView.selectRow(index, inComponent: 0, animated: true)
            }
        }
    }
}

extension SettingsViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sections.count
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sections[row] // access each individual string via the index [2]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // store the current selected news section in user defaults
        let sectionName = sections[row]
        userPreference.setSectionName(sectionName)
    }
}
