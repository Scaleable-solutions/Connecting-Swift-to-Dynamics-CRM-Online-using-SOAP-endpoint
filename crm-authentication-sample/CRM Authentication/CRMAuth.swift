//
//  CRMAuth.swift
//  CRM Authetication
//
//  Created by Hamza on 01/12/2015.
//  Copyright © 2015 Scaleable Solutions. All rights reserved.
//

import Foundation

protocol CRMAuthDelegate{
    
    func authFinishWithSuccess(holder:AuthHolder)
}

class CRMAuth : NetworkDelegate {
    
    var delegate:CRMAuthDelegate? = nil
    
    func finishWithSuccess(response: String, tag: String) {
        if(tag == "CRMAuth"){
            let authXMLParser = AuthXMLParser(xml: response)
            if authXMLParser.parse(){
                if let holder = authXMLParser.returnValue{
                    delegate?.authFinishWithSuccess(holder)
                }
            }
        }
    }
    
    func finishWithError(error: String, tag: String) {
        
    }
        
    
    func getAuthHeader(domain:String,username:String,password:String){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://login.microsoftonline.com/RST2.srf")!)
        request.HTTPMethod = "POST"
        request.addValue("Keep-Alive", forHTTPHeaderField: "Connection")
        request.addValue("text/xml; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        let postString = getAuthHeaderEnvelopOnline(domain, username: username, password: password)
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let svcHandler = ServiceHandler()
        svcHandler.delegate = self
        svcHandler.tag = "CRMAuth"
        svcHandler.getNetworkData(request)
    }
    
    func getAuthHeaderEnvelopOnline(url:String, username:String, password:String) -> String{
        let urnAddress = GetUrnOnline(url)
        var XML = [String]()
        //Get Auth Header Request
        XML.append("<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:u=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\">")
        XML.append("<s:Header>")
        XML.append("<a:Action s:mustUnderstand=\"1\">http://schemas.xmlsoap.org/ws/2005/02/trust/RST/Issue</a:Action>")
        XML.append("<a:MessageID>urn:uuid:\(CreateGUID()) </a:MessageID>")
        XML.append("<a:ReplyTo>")
        XML.append("<a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address>")
        XML.append("</a:ReplyTo>")
        XML.append("<a:To s:mustUnderstand=\"1\">https://login.microsoftonline.com/RST2.srf</a:To>")
        XML.append("<o:Security s:mustUnderstand=\"1\" xmlns:o=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\">")
        XML.append("<u:Timestamp u:Id=\"_0\">")
        XML.append("<u:Created>\(GetCurrentDateAndTime())</u:Created>")
        XML.append("<u:Expires>\(Get1HourPlusDateAndTime())</u:Expires>")
        XML.append("</u:Timestamp>")
        XML.append("<o:UsernameToken u:Id=\"uuid-\(CreateGUID())-1\">")
        XML.append("<o:Username>\(username)</o:Username>")
        XML.append("<o:Password>\(password)</o:Password>")
        XML.append("</o:UsernameToken>")
        XML.append("</o:Security>")
        XML.append("</s:Header>")
        XML.append("<s:Body>")
        XML.append("<trust:RequestSecurityToken xmlns:trust=\"http://schemas.xmlsoap.org/ws/2005/02/trust\">")
        XML.append("<wsp:AppliesTo xmlns:wsp=\"http://schemas.xmlsoap.org/ws/2004/09/policy\">")
        XML.append("<a:EndpointReference>")
        XML.append("<a:Address>urn:\(urnAddress)</a:Address>")
        XML.append("</a:EndpointReference>")
        XML.append("</wsp:AppliesTo>")
        XML.append("<trust:RequestType>http://schemas.xmlsoap.org/ws/2005/02/trust/Issue</trust:RequestType>")
        XML.append("</trust:RequestSecurityToken>")
        XML.append("</s:Body>")
        XML.append("</s:Envelope>")
        return XML.joinWithSeparator("")
    }
    
    
    
    func CreateGUID() -> String{
        return NSUUID().UUIDString
    }
    
    func GetUrnOnline(url:String) -> String{
        if (url.uppercaseString.rangeOfString("CRM2.DYNAMICS.COM") != nil) {
            return "crmsam:dynamics.com";
        }
        if (url.uppercaseString.rangeOfString("CRM4.DYNAMICS.COM") != nil) {
            return "crmemea:dynamics.com";
        }
        if (url.uppercaseString.rangeOfString("CRM5.DYNAMICS.COM") != nil) {
            return "crmapac:dynamics.com";
        }
        if (url.uppercaseString.rangeOfString("CRM6.DYNAMICS.COM") != nil) {
            return "crmoce:dynamics.com";
        }
        if (url.uppercaseString.rangeOfString("CRM7.DYNAMICS.COM") != nil) {
            return "crmjpn:dynamics.com";
        }
        if (url.uppercaseString.rangeOfString("CRM9.DYNAMICS.COM") != nil) {
            return "crmgcc:dynamics.com";
        }
        return "crmna:dynamics.com";
    }
    
    func GetCurrentDateAndTime() -> String{
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        return formatter.stringFromDate(date)
    }
    
    func Get1HourPlusDateAndTime() -> String{
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        return formatter.stringFromDate(date.dateByAddingTimeInterval(60*60))
    }
    
}


