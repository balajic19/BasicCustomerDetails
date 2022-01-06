//
//  CreateCustomerViewController.swift
//  FinalProject
//
//  Created by Mrudula on 10/11/21.
//

import UIKit

/// This view controller used to create and update customer
class CustomerDetailsViewController: UIViewController {
    
    /// defines view type
    enum ViewType {
        case edit
        case create
    }
    
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var customerPhoneNumberTextField: UITextField!
    /// Called on saving of new customer
    var customerCreationOnSuccess: ((Customer)->())?
    /// called on editing on exiting customer completes
    var customerEditSuccess: (()->())?
    
    var viewType: ViewType = .create
    var selectedCustomer: Customer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addNavigationRightBarButtonItem()
    }
    
    /// Used to setup UI
    func setupUI() {
        switch viewType {
        case .edit:
            title = "Edit"
            prefillCustomerDetails()
        case .create:
            title = "Add Customer"
        }
    }
    
    /// preefills selected customer details on text fields
    func prefillCustomerDetails() {
        guard let customer = selectedCustomer else { return }
        customerNameTextField.text  = customer.name
        customerPhoneNumberTextField.text = customer.phoneNumber
    }
    
    ///  adds save button to navigation bar
    func addNavigationRightBarButtonItem() {
        let addButton = UIBarButtonItem.init(
              title: "Save",
              style: .done,
              target: self,
              action: #selector(saveButtonTapped(sender:))
        )
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    /// Create/updates a customer
    @objc func saveButtonTapped(sender: UIBarButtonItem) {
        switch viewType {
        case .edit:
            selectedCustomer?.name = customerNameTextField.text ?? ""
            selectedCustomer?.phoneNumber = customerPhoneNumberTextField.text ?? ""
            customerEditSuccess?()
            navigationController?.popViewController(animated: true)
        case .create:
            let customer = Customer(name: customerNameTextField.text ?? "", phoneNumber: customerPhoneNumberTextField.text ?? "")
            customerCreationOnSuccess?(customer)
            navigationController?.popViewController(animated: true)
        }
    }

}
