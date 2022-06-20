//
//  InfoViewController.swift
//  Contacts
//
//  Created by Aleksandr Savinyh on 20.06.2022.
//

import UIKit

class InfoViewController: UIViewController {
    
    var firstName: String?
    var secondName: String?
    var phoneNumber: String = ""
    
    @IBOutlet weak var fullNameOutlet: UILabel!
    @IBOutlet weak var phoneNumberOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameOutlet.text = (firstName ?? "") + " " + (secondName ?? "")
        phoneNumberOutlet.setTitle(phoneNumber, for: .normal)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func editContact(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailViewController = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return }
        detailViewController.firstName = firstName
        detailViewController.secondName = secondName
        detailViewController.phoneNumber = phoneNumber
        show(detailViewController, sender: nil)
    }
}
