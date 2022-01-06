//
//  ViewController.swift
//  FinalProject
//
//  Created by Mrudula on 09/11/21.
//

import UIKit

/// This View Controller is used to show customers list
class CustomerListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nodataLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var customersList: [Customer] = [] {
        didSet {
            /// Hide/showing nodata label when customer list udpated
            nodataLabel.isHidden = !customersList.isEmpty
        }
    }

    //  MARK:  - Viewlife Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        title =  "Customers list"
        addNavigationRightBarButtonItem()
    }
    
    /// adding new customer button to navigation bar
    func addNavigationRightBarButtonItem() {
        let addButton = UIBarButtonItem.init(
              title: "New Customer",
              style: .done,
              target: self,
              action: #selector(addNewCustomerButtonAction(sender:))
        )
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    /// redirects user  to customer add screen
    @objc func addNewCustomerButtonAction(sender: UIBarButtonItem) {
        /// Pushing  to new customer view controller to create customers
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customerDetailsViewController = storyboard.instantiateViewController(withIdentifier: "CustomerDetailsViewController") as! CustomerDetailsViewController
        customerDetailsViewController.viewType = .create
        customerDetailsViewController.customerCreationOnSuccess = { customer in
            self.customersList.append(customer)
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(customerDetailsViewController, animated: true)
    }
    
    /// setting table view controller for table cell
    func setUpTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // MARK: - TableViewDelegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customersList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /// redirecting user to customer details screen to update details
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customerDetailsViewController = storyboard.instantiateViewController(withIdentifier: "CustomerDetailsViewController") as! CustomerDetailsViewController
        customerDetailsViewController.viewType = .edit
        customerDetailsViewController.selectedCustomer = customersList[indexPath.row]
        /// reloading table view on customer details update
        customerDetailsViewController.customerEditSuccess = {
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(customerDetailsViewController, animated: true)
        
    }
    

    // MARK: - TableViewDataSource Methods

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = customersList[indexPath.row].name
        cell.detailTextLabel?.text  = customersList[indexPath.row].phoneNumber
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //deleting selected customer from customers array
        if editingStyle == .delete {
            customersList.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }

}

