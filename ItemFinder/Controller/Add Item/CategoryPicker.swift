//
//  CategoryPicker.swift
//  
//
//  Created by Mattias Törnqvist on 2020-06-02.
//

import UIKit


class CategoryPickerDelegateDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let model = ["Select category",SportCategories.biking.rawValue, SportCategories.running.rawValue, SportCategories.skiing.rawValue]
    
    var picker: UIPickerView
    var delegate: CategoryPickerDelegate
    
    init(_ picker: UIPickerView, _ delegate: CategoryPickerDelegate) {
        self.picker = picker
        self.delegate = delegate
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return model.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return model[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print("DEBUG row selected", row)
        delegate.pickerView(picker, model[row])
    }
    
}

