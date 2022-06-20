//
//  DetailViewController.swift
//  Contacts
//
//  Created by Aleksandr Savinyh on 17.06.2022.
//

import UIKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var firstName: String?
    var secondName: String?
    var phoneNumber: String = ""
    
    @IBOutlet weak var firstNameOutlet: UITextField!
    @IBOutlet weak var secondNameOutlet: UITextField!
    @IBOutlet weak var readyButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var groupPhone: UIView!
    @IBOutlet weak var addNewNumberOutlet: UIButton!
    @IBOutlet weak var numberInputOutlet: UITextField!
    
    weak var delegate: ViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameOutlet.text = firstName
        secondNameOutlet.text = secondName
        numberInputOutlet.text = phoneNumber
    }
    
    @IBAction func checkFieldFirst(_ sender: UITextField) {
        if (sender.text != "") {
            readyButtonOutlet.isEnabled = true
        }else {
            readyButtonOutlet.isEnabled = false
        }
    }
    
    @IBAction func checkFieldSecond(_ sender: UITextField) {
        if (sender.text != "") {
            readyButtonOutlet.isEnabled = true
        }else {
            readyButtonOutlet.isEnabled = false
        }
    }
    
    @IBAction func saveContact(_ sender: Any) {
        delegate?.update(firstName: firstNameOutlet.text ?? "", secondName: secondNameOutlet.text ?? "", numberPhone: numberInputOutlet.text!)
        
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addNewNumber(_ sender: Any) {
        addNewNumberOutlet.isEnabled = false
        groupPhone.isHidden = false
        
    }
    
    @IBAction func deleteNumber(_ sender: Any) {
        numberInputOutlet.text = nil
        groupPhone.isHidden = true
        addNewNumberOutlet.isEnabled = true
    }
}
