//
//  SettingsViewController.swift
//  NYTTopStories
//
//  Created by Laxmikanth Reddy on 12/11/22.
//

import UIKit

class SettingsViewController: UIViewController {

    private let settingsView = SettingsView()
    
    // data for pickerview
    
    private let sections = ["Arts","Automobiles","Books","Business","Fashion","Food","Health"].sorted() // ascending from a-z
    
    override func loadView() {
        view = settingsView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        
        // setup pickerview
        settingsView.pickerView.dataSource = self
        settingsView.pickerView.delegate = self
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sections[row] // accessing each individual string in the sections array
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
