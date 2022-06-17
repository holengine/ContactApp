//
//  DetailViewController.swift
//  Contacts
//
//  Created by Aleksandr Savinyh on 17.06.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
//    var contact: ContactProtocol!
    @IBOutlet weak var firstNameOutlet: UITextField!
    @IBOutlet weak var secondNameOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func saveContact(_ sender: Any) {
        let contact = Contact(title: firstNameOutlet.text!, phone: secondNameOutlet.text!)
        contacts.append(contact)
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
