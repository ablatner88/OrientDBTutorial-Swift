//
//  OrdersTableViewController.swift
//  OrientDBTutorial-Swift
//
//  Created by Anthony Blatner on 8/1/17.
//  Copyright © 2017 Anthony Blatner. All rights reserved.
//

import Foundation
import UIKit

class OrdersTableViewController : UITableViewController {
    
    public var orders : Array<Order>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OrdersTableViewController viewDidLoad()")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(self.orders != nil){
            return self.orders!.count
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
        
        let order = orders?[indexPath.row]
        
        cell.textLabel?.text = "Order: " + (order?.rid!.description)!
        cell.detailTextLabel?.text = "$" + (order?.totalPrice!.description)!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("OrdersTableViewController didSelectRowAt: " + indexPath.row.description)
    }

}
