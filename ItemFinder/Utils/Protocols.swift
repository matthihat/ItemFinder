//
//  Protocols.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-05-18.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

protocol SignUpDelegate: class {
    func handleSignUpPressed(for view: SignUpView)
}

protocol LoginDelegate {
    func didPressLogin(_ emailTextField: UITextField, _ passwordTextField: UITextField)
}

protocol AddItemVCDelegate: class {
    func selectedCell(selectedIndexPath: IndexPath, selectedCell: ItemPhotoCVCell)
}

protocol AddItemViewDelegate: class {
    func saveButton(_ button: UIButton, withTitle title: String?, withKeyWords keyWords: String?, withDescription description: String?)
    
    func closeButton(_ button: UIButton)
}

protocol ImageProvidedDelegate: class {
    func image(_ didSelectImageWithImage: UIImage)
}
