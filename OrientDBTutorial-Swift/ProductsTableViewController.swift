//
//  ProductsTableViewController.swift
//  OrientDBTutorial-Swift
//
//  Created by Anthony Blatner on 8/1/17.
//  Copyright © 2017 Anthony Blatner. All rights reserved.
//

import Foundation
import UIKit

class ProductsTableViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProductsTableViewController viewDidLoad()")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        
        // Get an ordered array of our products to display in the table
        let product = Array(products.values)[indexPath.row]
        
        // Configure the cell...
        cell.textLabel?.text = product.productNameShort
        cell.detailTextLabel?.text = "$" + product.price!.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ProductsTableViewController didSelectRowAt: " + indexPath.row.description)
        
        // Lookup the selected product in the same ordered array of products
        let product = Array(products.values)[indexPath.row]
        
        // Push the Product Detail View
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let productsDetailViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        productsDetailViewController.product = product
        self.navigationController?.pushViewController(productsDetailViewController, animated: true)
    }
    
    
}
