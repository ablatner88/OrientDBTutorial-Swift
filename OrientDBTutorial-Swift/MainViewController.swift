//
//  ViewController.swift
//  OrientDBTutorial-Swift
//
//  Created by Anthony Blatner on 7/30/17.
//  Copyright © 2017 Anthony Blatner. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController {

    @IBAction func clickGetProducts(_ sender: Any) {
        print("---clickGetProducts---")
        
        //GET http://{{server}}:{{port}}/query/{{database}}/{{language}}/SELECT from PRODUCTS
        let requestString = baseURL() + "/query/ComputerStore/sql/SELECT from PRODUCTS"
        let escapedString = requestString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        Alamofire.request(escapedString!).validate().responseJSON { response in
            switch response.result {
                case .success (let value):
                    print("---Response Received---")
                    print("Request: \(String(describing: response.request))")
                    print("Result: \(response.result)")
                    
                    let json = JSON(value)
                    let result = json["result"].arrayValue
                    
                    // Unpack and load products
                    for product in result {
                        
                        let rid = product["@rid"].stringValue
                        let productObject = Product(productJSON: product)
                        
                        products[rid] = productObject
                    }
                
                    // Push the Products Table
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let productsTableViewController = storyBoard.instantiateViewController(withIdentifier: "ProductsTableViewController") as! ProductsTableViewController
                    self.navigationController?.pushViewController(productsTableViewController, animated: true)
                
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    @IBAction func clickGetOrders(_ sender: Any) {
        print("---clickGetOrders---")
        
        //http://localhost:2480/query/ComputerStore/sql/SELECT expand(out("HasOrder")) from  5:0
        
        let userRidTrim = userRid?.trimmingCharacters(in: ["#"])
        let requestString = baseURL() + "/query/ComputerStore/sql/SELECT expand(out(\"HasOrder\")) from " + userRidTrim!
        let escapedString = requestString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        Alamofire.request(escapedString!).validate().responseJSON { response in
            switch response.result {
            case .success (let value):
                print("---Response Received---")
                print("Request: \(String(describing: response.request))")
                print("Result: \(response.result)")
                
                let json = JSON(value)
                let result = json["result"].arrayValue
                var orders = Array<Order>()
                
                // Upack and load orders
                for orderJSON in result {
                    let order = Order(orderJSON: orderJSON)
                    orders.append(order)
                }
                
                // Push the Orders Table
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let ordersTableViewController = storyBoard.instantiateViewController(withIdentifier: "OrdersTableViewController") as! OrdersTableViewController
                ordersTableViewController.orders = orders
                self.navigationController?.pushViewController(ordersTableViewController, animated: true)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

