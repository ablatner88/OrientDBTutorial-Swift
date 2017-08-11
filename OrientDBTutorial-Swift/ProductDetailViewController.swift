//
//  ProductDetailViewController.swift
//  OrientDBTutorial-Swift
//
//  Created by Anthony Blatner on 8/1/17.
//  Copyright © 2017 Anthony Blatner. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON
import UIKit

class ProductDetailViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var product : Product?
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameTextView: UITextView!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var productComponentsTableView: UITableView!
    @IBOutlet weak var componentsLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    var componentRids : Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ProductDetailViewController viewDidLoad() Product: " + (product?.description())!)

        self.title = self.product?.productNameShort
        self.productImageView.af_setImage(withURL: (product?.productImageURL)!)
        self.productNameTextView.text = self.product?.productName
        self.productDescriptionTextView.text = self.product?.productDescription
        self.productPriceLabel.text = "$" + (self.product?.price?.description)!
        
        let productRid = self.product?.rid
        let productRidTrim = productRid?.trimmingCharacters(in: ["#"])
        
        // GET http://{{server}}:{{port}}/query/{{database}}/{{language}}/SELECT expand(out(‘Components’)) from <<@rid>>
        let requestString = "http://admin:admin@localhost:2480/query/ComputerStore/sql/select expand(out('Components')) from " + productRidTrim!
        let escapedString = requestString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        Alamofire.request(escapedString!).validate().responseJSON { response in
            switch response.result {
            case .success (let value):
                print("---Response Received---")
                print("Request: \(String(describing: response.request))")
                print("Result: \(response.result)")
                
                let json = JSON(value)
                let result = json["result"].arrayValue
                
                self.componentRids = Array<String>()
                
                // Load all of the products
                for componentProductJSON in result {
                    let componentRid = componentProductJSON["@rid"].stringValue
                    
                    self.componentRids?.append(componentRid)
                    
                    print("ProductDetailViewController found componentRid: " + componentRid)
                }
                
                // Reload the table to display the actual products instead of our placeholders
                self.productComponentsTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    
    @IBAction func clickBuy(_ sender: Any) {
        print("--clickBuy--")
        
        // Show a purchase confirmation dialogue
        let alert = UIAlertController(title: "Confirm", message: "Select Buy to Purchase", preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { (alert) in
            print("--Click Confirm--")
            self.createOrder()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (alert) in
            print("--Click Cancel--")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func createOrder(){
        let productRidTrim = product?.rid?.trimmingCharacters(in: ["#"])
        let userRidTrim = userRid?.trimmingCharacters(in: ["#"])
        
        // POST http://{{server}}:{{port}}/function/{{database}}/{{name}}/{{argument1}}/{{argument2}}
        // POST http://localhost:2480/function/ComputerStore/CreateOrder/23:1/5:0

        let requestString = "http://admin:admin@localhost:2480/function/ComputerStore/CreateOrder/" + productRidTrim! + "/" + userRidTrim!
        let escapedString = requestString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        Alamofire.request(escapedString!, method: .post).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("---Response Received---")
                print("Request: \(String(describing: response.request))")
                print("Result: \(response.result)")
                
                // Alert that the order was successful
                let alert = UIAlertController(title: "Purchase Completed", message: "Thank you for your order.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (product?.componentEdgeRids?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComponentCell", for: indexPath)
        
        // If we have not yet received components, then insert placeholders
        if(self.componentRids != nil && self.componentRids?[indexPath.row] != nil){
            // Look up components with rids
            let componentRid = self.componentRids?[indexPath.row]
            let componentProduct = products[componentRid!]
            
            cell.textLabel?.text = componentProduct?.productNameShort!
            cell.detailTextLabel?.text = componentProduct?.productDescription!.description
        }else{
            // Don't have components, but have edge RIDs
            let componentEdgeRid = product?.componentEdgeRids?[indexPath.row]
            
            cell.textLabel?.text = componentEdgeRid
            cell.detailTextLabel?.text = "Edge"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ProductsTableViewController didSelectRowAt: " + indexPath.row.description)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(self.componentRids != nil && self.componentRids?[indexPath.row] != nil){
            
            let componentRid = self.componentRids?[indexPath.row]
            let componentProduct = products[componentRid!]
            
            // Open component in a product detail view controller
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let productsDetailViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            productsDetailViewController.product = componentProduct
            self.navigationController?.pushViewController(productsDetailViewController, animated: true)
        }
    }
    
}
