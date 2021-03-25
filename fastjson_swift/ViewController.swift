//
//  ViewController.swift
//  fastjson_swift
//
//  Created by CuiXg on 2021/3/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let json = "{\"ndame\": \"Andy\"}"
        print(try! JSON.parseObject(json, type: Body.self).name)

    }


    struct Body: Codable {
        @Default<Bool.True> var name: Bool
    }



}

