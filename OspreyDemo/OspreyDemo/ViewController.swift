//
//  ViewController.swift
//  OspreyDemo
//
//  Created by Rob Timpone on 7/11/20.
//  Copyright © 2020 Rob Timpone. All rights reserved.
//

import Osprey
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var request = HTTPRequest()
        request.host = "swapi.dev"
        request.path = "/api/people/1/"
        request.parameters = [
            "test": "true",
            "attempt": "1"
        ]
        
        URLSession.shared.load(request: request) { result in
            print(result)
        }
    }
}
