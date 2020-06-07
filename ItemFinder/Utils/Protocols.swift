//
//  Protocols.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-18.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

protocol SignUpDelegate: class {
    func handleGetLocationPressed(_ button: UIButton)
    func handleSignUpPressed(for view: SignUpView)
    func alreadyHaveAnAccountButton(_ button: UIButton)
}

protocol LoginDelegate {
    func didPressLogin(_ emailTextField: UITextField, _ passwordTextField: UITextField)
    func didPressDontHaveAccountButton(_ button: UIButton)
}

protocol AddItemVCDelegate: class {
    func selectedCell(selectedIndexPath: IndexPath, selectedCell: ItemPhotoCVCell)
}

protocol AddItemViewDelegate: class {
    func saveButton(_ button: UIButton, withTitle title: String?, withKeyWords keyWords: String?, withDescription description: String?)
    
    func itemIsForSale(_ sender: UISwitch)
    
    func itemIsNotForSale(_ sender: UISwitch)
    
    func closeButton(_ button: UIButton)
}

protocol ImageProvidedDelegate: class {
    func image(_ didSelectImageWithImage: UIImage)
}

protocol CategoryPickerDelegate {
    func pickerView(_ picker: UIPickerView, _ selectedCategory: String)
}

protocol SearchTableDelegate {
    func didSelectRow(_ tableView: UITableView, indexPath: IndexPath)
}
