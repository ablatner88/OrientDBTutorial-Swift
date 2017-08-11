//
//  Order.swift
//  OrientDBTutorial-Swift
//
//  Created by Anthony Blatner on 8/6/17.
//  Copyright © 2017 Anthony Blatner. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Order {
    var rid: String?
    var totalPrice: Double?
    
    init(rid:String, totalPrice:Double) {
        self.rid = rid
        self.totalPrice = totalPrice
    }
    
    convenience init(orderJSON: JSON){
        
        let rid = orderJSON["@rid"].stringValue
        let totalPrice = orderJSON["TotalPrice"].doubleValue
        
        // Create the Product object from the Response
        self.init(rid: rid, totalPrice: totalPrice)
    }
    
    func description() -> String {
        return "Order: {" +
            "\n\trid: " + rid!.description +
            "\n\ttotalPrice: " + totalPrice!.description +
            "\n}"
    }
}
