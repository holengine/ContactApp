//
//  ViewController.swift
//  Contacts
//
//  Created by Aleksandr Savinyh on 15.06.2022.
//

import UIKit

protocol ViewControllerDelegate: AnyObject {
    func update(firstName: String?, secondName: String?, numberPhone: String)
}

class ViewController: UIViewController, ViewControllerDelegate {
    var contacts: [ContactProtocol] = [] {
        didSet {
            contacts.sort {
                (($0.firstName ?? "").uppercased() + ($0.secondName ?? "")).uppercased() < (($1.firstName ?? "").uppercased() + ($1.secondName ?? "")).uppercased()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? DetailViewController else { return }
        destination.delegate = self
   }
    
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        var configuration = cell.defaultContentConfiguration()
        configuration.text = "\(arrayOfHeaderSections[indexPath.section].array[indexPath.row].firstName ?? "")" + " \( arrayOfHeaderSections[indexPath.section].array[indexPath.row].secondName ?? "")"
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
        arrayOfHeaderSections.append(contentsOf: [HeaderSection(title: "", array: [Contact(firstName: "Aleksandr", secondName: "Savinyh", numberPhone: "+79586385845")])])
        
        var titleChar: String = ""
        
        for string in contacts {
            let cun = (string.firstName ?? "") + (string.secondName ?? "")
            if (cun.first?.uppercased() != titleChar) {
                titleChar = cun.first?.uppercased() ?? ""
                var contactsInSection: [ContactProtocol] = []
                
                for item in contacts {
                    if (((item.firstName ?? "") + (item.secondName ?? "")).first?.uppercased() == titleChar) {
                        contactsInSection.append(item)
                    }
                }
                arrayOfHeaderSections.append(contentsOf: [HeaderSection(title: String(titleChar).uppercased(), array: contactsInSection)])
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
            return 50
        }
    }
    
    func update(firstName: String?, secondName: String?, numberPhone: String) {
        let contact = Contact(firstName: firstName, secondName: secondName, numberPhone: numberPhone)
        self.contacts.append(contact)
        self.loadHeaderSections()
        self.tableView.reloadData()
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
        guard let infoViewController = storyboard.instantiateViewController(identifier: "InfoViewController") as? InfoViewController else { return }
        infoViewController.firstName = arrayOfHeaderSections[indexPath.section].array[indexPath.row].firstName ?? ""
        infoViewController.secondName = arrayOfHeaderSections[indexPath.section].array[indexPath.row].secondName ?? ""
        infoViewController.phoneNumber = arrayOfHeaderSections[indexPath.section].array[indexPath.row].numberPhone
        show(infoViewController, sender: nil)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section != 0 {
            var countCell = 0
            let count = indexPath.section
            for i in 1..<count {
                countCell += arrayOfHeaderSections[i].array.count
            }
            countCell += indexPath.row
            let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
                self.contacts.remove(at: countCell)
                self.loadHeaderSections()
                tableView.reloadData()
            }
            let actions = UISwipeActionsConfiguration(actions: [actionDelete])
            return actions
        }
        return nil
    }
}
