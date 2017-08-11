//
//  LoginViewController.swift
//  OrientDBTutorial-Swift
//
//  Created by Anthony Blatner on 8/1/17.
//  Copyright © 2017 Anthony Blatner. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signinClicked(_ sender: Any) {
        
        print("--signinClicked--");
        
        username = usernameTextField.text
        password = passwordTextField.text
        
        //GET http://{{server}}:{{port}}/connect/{{database}}
        
        let connectString = baseURL() + "/connect/ComputerStore/"
        let escapedString = connectString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        // Connection Request
        Alamofire.request(escapedString!).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("---Response Received---")
                print("Request: \(String(describing: response.request))")
                print("Result: \(response.result)")
                if let json = response.result.value {
                    print("JSON: \(json)")
                }
                
                // Lookup username in the OUser database
                // GET http://{{server}}:{{port}}/query/{{database}}/{{language}}/SELECT from OUser where...
                let getUserString = baseURL() + "/query/ComputerStore/sql/SELECT from OUser where name=\""+username!+"\""
                let escapedUserString = getUserString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                Alamofire.request(escapedUserString!).validate().responseJSON { response in
                    switch response.result {
                        case .success (let value):
                            print("---Response Received---")
                            print("Request: \(String(describing: response.request))")
                            print("Result: \(response.result)")
                            if let json = response.result.value {
                                print("JSON: \(json)")
                            }
                            
                            let json = JSON(value)
                            
                            // extract user rid
                            let result = json["result"]
                            let result0 = result[0]
                            let rid = result0["@rid"].stringValue
                            userRid = rid // Set our global user rid
                        
                            print("userRid: " + rid.description)
                            
                            // Once logged in, drill down to ComputerStore view
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                            self.navigationController?.pushViewController(newViewController, animated: true)
                            
                        case .failure(let error):
                            print(error)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
   
        }

        
    }
}
