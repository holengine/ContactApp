//
//  DetailViewController.swift
//  Contacts
//
//  Created by Aleksandr Savinyh on 17.06.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    var firstName: String?
    var secondName: String?
    var phoneNumber: String = ""
    
//    var contact: ContactProtocol!
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
        delegate?.update(firstName: firstNameOutlet.text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? "", secondName: secondNameOutlet.text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? "", numberPhone: numberInputOutlet.text!)
        
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
    //    @IBAction func showNewContactAlert(_ sender: Any) {
//        let alertController = UIAlertController(title: "Создайте  новый контакт", message: "Введите имя и телефон", preferredStyle: .alert)
//
//        alertController.addTextField() { textField in
//            textField.placeholder = "Имя"
//        }
//
//        alertController.addTextField() { textField in
//            textField.placeholder = "Номер телефона"
//        }
//
//        let createButton = UIAlertAction(title: "Создать", style: .default) { _ in
//            guard let contactName = alertController.textFields?[0].text,
//                  let contactPhone = alertController.textFields?[1].text else {
//                return
//            }
//            let contact = Contact(title: contactName, phone: contactPhone)
//            self.contacts.append(contact)
//            self.loadHeaderSections()
//            self.tableView.reloadData()
//        }
//
//        let cancelButton = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
//        alertController.addAction(cancelButton)
//        alertController.addAction(createButton)
//
//        self.present(alertController, animated: true)
//    }
}
