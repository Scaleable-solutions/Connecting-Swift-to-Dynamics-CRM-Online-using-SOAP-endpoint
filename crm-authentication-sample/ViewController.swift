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
        domainTextField.autocorrectionType = .No
        usernameTextField.autocorrectionType = .No
        passwordTextField.autocorrectionType = .No
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
        let domain = domainTextField.text!
        if(domain.isEmpty){
            let alert = UIAlertController(title: "Error", message: "Please provide Organization url", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){action in
                switch action.style{
                case .Default:
                    self.domainTextField.becomeFirstResponder()
                default:
                    break
                }
                })
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        if(!matches(domain, pattern: "https://[a-z]*.crm[2-9]?.dynamics.com")){
            let alert = UIAlertController(title: "Error", message: "Please enter correct domain\nhttps://<organization name>.crm.dynamics.com", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        let username = usernameTextField.text!
        if(username.isEmpty){
            let alert = UIAlertController(title: "Error", message: "Please provide username", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){action in
                switch action.style{
                case .Default:
                    self.usernameTextField.becomeFirstResponder()
                default:
                    break
                }
                })
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        let password = passwordTextField.text!
        if(password.isEmpty){
            let alert = UIAlertController(title: "Error", message: "Please provide password", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){action in
                switch action.style{
                case .Default:
                    self.becomeFirstResponder()
                default:
                    break
                }
                })
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        self.addActivityIndicator()
        let crmAuth = CRMAuth()
        crmAuth.delegate = self
        crmAuth.getAuthHeader(domain, username: username, password: password)
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
    
    func matches(searchString:String, pattern : String)->Bool{
        
        do{
            let regex = try NSRegularExpression(pattern: pattern, options: [.CaseInsensitive])
            let matchCount = regex.numberOfMatchesInString(searchString, options: [], range: NSMakeRange(0, searchString.characters.count))
            
            return matchCount > 0
        }catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
    }
}

