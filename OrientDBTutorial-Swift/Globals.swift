//
//  Globals.swift
//  OrientDBTutorial-Swift
//
//  Created by Anthony Blatner on 8/5/17.
//  Copyright © 2017 Anthony Blatner. All rights reserved.
//

import Foundation

var username: String?
var password: String?
var userRid: String?

var products = Dictionary<String, Product>()

var baseURL0 = "localhost:2480"

func baseURL() -> String {
    if(username != nil && password != nil){
        return "http://" + username! + ":" + password! + "@" + baseURL0
    }else{
        return "http://" + baseURL0
    }
}
