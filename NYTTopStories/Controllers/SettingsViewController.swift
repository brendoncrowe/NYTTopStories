//
//  SettingsViewController.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/18/23.
//

import UIKit

struct UserKey {
    static let sectionName = "News Section"
}

class SettingsViewController: UIViewController {
    
    private let settingsView = SettingsView()
    private let sections = ["Arts", "Automobiles", "Books", "Business", "Fashion", "Food", "Health", "Insider", "Magazine", "Movies", "NYRegion", "Opinion", "Politics", "RealEstate", "Science", "Sports", "SundayReview", "Technology", "Theater", "Travel", "Upshot", "US", "World"]
    
    private var sectionName = UserDefaults.standard.object(forKey: UserKey.sectionName) as? String ?? "Technology"
    
    override func loadView() {
        super.loadView()
        view = settingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView.pickerView.delegate = self
        settingsView.pickerView.dataSource = self
        settingsView.pickerView.selectRow(sections.firstIndex(of: sectionName)!, inComponent: 0, animated: true)
        view.backgroundColor = .systemGroupedBackground
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
        UserDefaults.standard.set(sectionName, forKey: UserKey.sectionName)
    }
}
