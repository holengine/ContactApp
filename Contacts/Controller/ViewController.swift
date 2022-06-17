//
//  ViewController.swift
//  Contacts
//
//  Created by Aleksandr Savinyh on 15.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var contacts: [ContactProtocol] = [] {
        didSet {
            contacts.sort { $0.title < $1.title}
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
        guard segue.identifier == "viewDetailContact" else { return }
        self.loadHeaderSections()
        self.tableView.reloadData()
//        guard let destination = segue.destination as? DetailViewController else { return }
//        destination.contact = contacts[1]
     }
    
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        var configuration = cell.defaultContentConfiguration()
        configuration.text = "\(arrayOfHeaderSections[indexPath.section].array[indexPath.row].title)"
//        configuration.secondaryText = "\(arrayOfHeaderSections[indexPath.section].array[indexPath.row].phone)"
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
        for string in contacts {
            if let letter = string.title.first {
                var newContacts: [ContactProtocol] = []
                for item in contacts {
                    if item.title.first == letter {
                        newContacts.append(item)
                    }
                }
                arrayOfHeaderSections.append(contentsOf: [HeaderSection(title: String(letter).uppercased(), array: newContacts)])
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfHeaderSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
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
