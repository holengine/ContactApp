//
//  ViewController.swift
//  Contacts
//
//  Created by Aleksandr Savinyh on 15.06.2022.
//

import UIKit

protocol ViewControllerDelegate: AnyObject {
    func update(firstName: String, secondName: String, numberPhone: String)
}

class ViewController: UIViewController, ViewControllerDelegate {
    func update(firstName: String, secondName: String, numberPhone: String) {
        let contact = Contact(firstName: firstName, secondName: secondName, numberPhone: numberPhone)
        self.contacts.append(contact)
        self.loadHeaderSections()
        self.tableView.reloadData()
    }
    
    var contacts: [ContactProtocol] = [] {
        didSet {
            contacts.sort {
                ($0.firstName?.uppercased() ?? $0.secondName?.uppercased() ?? "") < ($1.firstName?.uppercased() ?? $1.secondName?.uppercased() ?? "")
            }
            storage.save(contacts: contacts)
        }
    }
    
    var arrayOfHeaderSections: [HeaderSectionProtocol] = [] {
        didSet {
            arrayOfHeaderSections.sort { $0.title < $1.title}
        }
    }

    var storage: ContactStorageProtocol!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = ContactStorage()
        loadContacts()
        loadHeaderSections()
    }
    
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        var configuration = cell.defaultContentConfiguration()
        configuration.text = "\(arrayOfHeaderSections[indexPath.section].array[indexPath.row].firstName ?? "")" + " \( arrayOfHeaderSections[indexPath.section].array[indexPath.row].secondName ?? "")"
        configuration.secondaryText = "\(arrayOfHeaderSections[indexPath.section].array[indexPath.row].numberPhone)"
        cell.contentConfiguration = configuration
        
        let nib = UINib(nibName: "CustomHeaderView", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        tableView.tableFooterView = UIView()
    }

    private func loadContacts() {
        contacts = storage.load()
    }
    
    private func loadHeaderSections() {
        arrayOfHeaderSections.removeAll()
        arrayOfHeaderSections.append(contentsOf: [HeaderSection(title: "Profile", array: contacts)])
        
        var titleChar: String? = nil
        
        for string in contacts {
            if ((string.firstName?.first?.uppercased()) != nil && (string.firstName?.first?.uppercased()) != titleChar) {
                titleChar = string.firstName?.first?.uppercased()
                var contactsInSection: [ContactProtocol] = []
                
                for item in contacts {
                    if item.firstName?.first?.uppercased() == titleChar || ((item.secondName?.first?.uppercased()) != nil && item.secondName?.first?.uppercased() == titleChar) {
                        contactsInSection.append(item)
                    }
                }
                arrayOfHeaderSections.append(contentsOf: [HeaderSection(title: String(titleChar!).uppercased(), array: contactsInSection)])
            }else if ((string.secondName?.first?.uppercased()) != nil && (string.secondName?.first?.uppercased()) != titleChar){
                titleChar = string.secondName?.first?.uppercased()
                var contactsInSection: [ContactProtocol] = []
                
                for item in contacts {
                    if item.secondName?.first?.uppercased() == titleChar || ((item.firstName?.first?.uppercased()) != nil && item.firstName?.first?.uppercased() == titleChar){
                        contactsInSection.append(item)
                    }
                }
                arrayOfHeaderSections.append(contentsOf: [HeaderSection(title: String(titleChar!).uppercased(), array: contactsInSection)])
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfHeaderSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }else {
            return arrayOfHeaderSections[section].array.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as? CustomHeaderViewController
            header?.titleLabel?.text = arrayOfHeaderSections[section].title
            return header
        }else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 90
        }else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "ProfileCell")
            var configuration = cell.defaultContentConfiguration()
            configuration.image = UIImage(named: "avatar")
            configuration.imageProperties.cornerRadius = 50
            configuration.text = "Aleksandr Savinyh"
            configuration.secondaryText = "Моя карточка"
            cell.contentConfiguration = configuration
            return cell
        }else if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "MyCell") {
            var cell: UITableViewCell
            cell = reuseCell
            configure(cell: &cell, for: indexPath)
            return cell
        }else {
            var cell: UITableViewCell
            cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
            configure(cell: &cell, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailViewController = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return }
        detailViewController.firstName = arrayOfHeaderSections[indexPath.section].array[indexPath.row].firstName
        detailViewController.secondName = arrayOfHeaderSections[indexPath.section].array[indexPath.row].secondName
        detailViewController.phoneNumber = arrayOfHeaderSections[indexPath.section].array[indexPath.row].numberPhone
        show(detailViewController, sender: nil)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section != 0 {
            let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
                self.contacts.remove(at: indexPath.row)
                self.loadHeaderSections()
                tableView.reloadData()
            }
            let actions = UISwipeActionsConfiguration(actions: [actionDelete])
            return actions
        }
        return nil
    }
}
