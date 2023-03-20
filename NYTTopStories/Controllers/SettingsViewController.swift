//
//  SettingsViewController.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/18/23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let settingsView = SettingsView()
    private let sections = ["Arts", "Automobiles", "Books", "Business", "Fashion", "Food", "Health", "Insider", "Magazine", "Movies", "NYRegion", "Obituaries", "Opinion", "Politics", "RealeEstate", "Science", "Sports", "SundayReview", "Technology", "Theater", "T-Magazine", "Travel", "Upshot", "US", "World"]
    
    override func loadView() {
        super.loadView()
        view = settingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView.pickerView.delegate = self
        settingsView.pickerView.dataSource = self
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
    
}
