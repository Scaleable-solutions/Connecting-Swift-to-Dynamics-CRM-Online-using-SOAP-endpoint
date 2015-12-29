//
//  ViewController.swift
//  crm-authentication-sample
//
//  Created by Hamza on 28/12/2015.
//  Copyright © 2015 Scaleable Solutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ExecuteSOAPDelegate,CRMAuthDelegate {

    @IBOutlet weak var domainTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var fullName = ""
    
    var activityIndicator:UIActivityIndicatorView!
    
    var aHolder = AuthHolder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NameSegue"{
            let destinationViewController = segue.destinationViewController as? NameViewController
            destinationViewController?.fullName = fullName
        }
    }
    
    @IBAction func submitButtonAction(sender: UIButton) {
        self.addActivityIndicator()
        let crmAuth = CRMAuth()
        crmAuth.delegate = self
        crmAuth.getAuthHeader(domainTextField.text!, username: usernameTextField.text!, password: passwordTextField.text!)
    }
    
    func authFinishWithSuccess(holder: AuthHolder) {
        aHolder = holder
        let soap = ExecuteSOAP()
        soap.delegate = self
        soap.Execute(holder, domain: domainTextField.text!, body: SOAPBodies.WhoIAMBody())
    }
    
    func finishSOAPCall(response: String) {
        let xml = SWXMLHash.parse(response)
        if let id = xml["s:Envelope"]["s:Body"]["ExecuteResponse"]["ExecuteResult"]["b:Results"]["b:KeyValuePairOfstringanyType"][0]["d:value"].element?.text!{
            let soap = ExecuteSOAP()
            soap.delegate = self
            soap.Execute(aHolder, domain: domainTextField.text!, body: SOAPBodies.CRMUserInfoBody(id))
        }
        let firstName = xml["s:Envelope"]["s:Body"]["ExecuteResponse"]["ExecuteResult"]["b:Results"]["b:KeyValuePairOfstringanyType"]["c:value"]["b:Attributes"]["b:KeyValuePairOfstringanyType"][0]["c:value"].element?.text!
        let lastName = xml["s:Envelope"]["s:Body"]["ExecuteResponse"]["ExecuteResult"]["b:Results"]["b:KeyValuePairOfstringanyType"]["c:value"]["b:Attributes"]["b:KeyValuePairOfstringanyType"][1]["c:value"].element?.text!
        if firstName != nil && lastName != nil{
            dispatch_async(dispatch_get_main_queue()){
                self.fullName = "\(firstName!) \(lastName!)"
                self.performSegueWithIdentifier("NameSegue", sender: self)
                self.removeActivityIndicator()
            }
        }
    }
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }
}

