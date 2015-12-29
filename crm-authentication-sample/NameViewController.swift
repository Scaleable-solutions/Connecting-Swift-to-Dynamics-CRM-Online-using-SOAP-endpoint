//
//  NameViewController.swift
//  crm-authentication-sample
//
//  Created by Hamza on 28/12/2015.
//  Copyright © 2015 Scaleable Solutions. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    var fullName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = fullName
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
