//
//  ViewController.swift
//  Lesson 14
//
//  Created by Maxim Gorin on 03.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var secondNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        firstNameTextField.text = UserDefaultsPersistance.shared.firstName
        secondNameTextField.text = UserDefaultsPersistance.shared.secondName
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UserDefaultsPersistance.shared.firstName = firstNameTextField.text
        UserDefaultsPersistance.shared.secondName = secondNameTextField.text

        self.view.endEditing(true)
    }
}
