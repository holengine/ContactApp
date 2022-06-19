//
//  File.swift
//  Contacts
//
//  Created by Aleksandr Savinyh on 15.06.2022.
//

import Foundation

protocol ContactProtocol {
    var firstName: String? {get set}
    var secondName: String? {get set}
    var numberPhone: String {get set}
}

protocol ContactStorageProtocol {
    func load() -> [ContactProtocol]
    func save(contacts: [ContactProtocol])
}

protocol HeaderSectionProtocol {
    var title: String {get set}
    var array: [ContactProtocol] {get}
}

struct Contact: ContactProtocol {
    var firstName: String?
    var secondName: String?
    var numberPhone: String
}

struct HeaderSection: HeaderSectionProtocol {
    var title: String
    var array: [ContactProtocol]
}

class ContactStorage: ContactStorageProtocol {
    private var storage = UserDefaults.standard
    private var storageKey = "contacts"
    
    private enum ContactKey: String {
        case firstName
        case secondName
        case numberPhone
    }
    
    func load() -> [ContactProtocol] {
        var resultContacts: [ContactProtocol] = []
        let contactFromStorage = storage.array(forKey: storageKey) as? [[String: String]] ?? []
        for contact in contactFromStorage {
            guard let firstName = contact[ContactKey.firstName.rawValue],
                  let secondName = contact[ContactKey.secondName.rawValue],
                  let numberPhone = contact[ContactKey.numberPhone.rawValue] else {
                continue
            }
            resultContacts.append(Contact(firstName: firstName, secondName: secondName, numberPhone: numberPhone))
        }
        return resultContacts
    }
    
    func save(contacts: [ContactProtocol]) {
        var arrayFromStorage: [[String: String]] = []
        contacts.forEach { contact in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[ContactKey.firstName.rawValue] = contact.firstName
            newElementForStorage[ContactKey.secondName.rawValue] = contact.secondName
            newElementForStorage[ContactKey.numberPhone.rawValue] = contact.numberPhone
            arrayFromStorage.append(newElementForStorage)
        }
        storage.set(arrayFromStorage, forKey: storageKey)
    }
}
