//
//  Product.swift
//  OrientDBTutorial-Swift
//
//  Created by Anthony Blatner on 8/2/17.
//  Copyright © 2017 Anthony Blatner. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Product {

    var rid: String?
    var price: Double?
    var productName: String?
    var productNameShort: String?
    var productDescription: String?
    var productImageURL: URL?
    var componentEdgeRids: Array<String>?
    var compatibleWithEdgeRids: Array<String>?

    
    init(rid:String,
         price:Double,
         productName: String,
         productNameShort: String,
         productDescription: String,
         productImageURL: URL,
         componentEdgeRids: Array<String>,
         compatibleWithEdgeRids: Array<String>
        ) {
        
        self.rid = rid
        self.price = price
        self.productName = productName
        self.productNameShort = productNameShort
        self.productDescription = productDescription
        self.productImageURL = productImageURL
        
        self.componentEdgeRids = componentEdgeRids
        self.compatibleWithEdgeRids = compatibleWithEdgeRids
    }
    
    convenience init(productJSON: JSON){
        
        let rid = productJSON["@rid"].stringValue
        let productNameShort = productJSON["ProductNameShort"].stringValue
        let productName = productJSON["ProductName"].stringValue
        let price = productJSON["Price"].doubleValue
        let productDescription = productJSON["ProductDescription"].stringValue
        let productImageURL0 = productJSON["ProductImageURL"].stringValue
        let productImageURL = URL(string: productImageURL0)!
        
        let componentEdgeRids = productJSON["out_Components"].arrayValue.map({$0.stringValue})
        let compatibleWithEdgeRids = productJSON["out_CompatibleWith"].arrayValue.map({$0.stringValue})
        
        // Create the Product object from the Response
        self.init(rid: rid,
            price: price,
            productName: productName,
            productNameShort: productNameShort,
            productDescription: productDescription,
            productImageURL: productImageURL,
            componentEdgeRids: componentEdgeRids,
            compatibleWithEdgeRids: compatibleWithEdgeRids)
    }
    
    
    func description() -> String {
        return "Product: {\n\tproductNameShort: " + productNameShort! +
              "\n\trid: " + rid!.description +
              "\n\tprice: " + price!.description +
              "\n\tproductName: " + productName! +
              "\n\tproductDescription: " + productDescription! +
              "\n\tproductImageURL: " + productImageURL!.description +
              "\n\tcomponentEdgeRids: " + componentEdgeRids!.description +
              "\n\tcompatibleWithEdgeRids: " + compatibleWithEdgeRids!.description + "\n}"
    }

}
