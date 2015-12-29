//
//  ExecuteSOAP.swift
//  CRM Authetication
//
//  Created by Hamza on 01/12/2015.
//  Copyright © 2015 Scaleable Solutions. All rights reserved.
//

import Foundation

protocol ExecuteSOAPDelegate{
    func finishSOAPCall(response:String)
}

class ExecuteSOAP : NetworkDelegate {
    
    var delegate:ExecuteSOAPDelegate? = nil
    
    func Execute(holder:AuthHolder,domain:String,body:String){
        
        let header = CreateSOAPHeaderOnline(domain, keyIdentifier: holder.keyIdentifier, token0: holder.token0, token1: holder.token1)
        var XML = [String]()
        XML.append("<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\">")
        XML.append(header)
        XML.append(body)
        XML.append("</s:Envelope>")
        let postString = XML.joinWithSeparator("")
        
        let completeURL = domain + "/XRMServices/2011/Organization.svc"
        let request = NSMutableURLRequest(URL: NSURL(string: completeURL)!)
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPMethod = "POST"
        request.addValue("application/soap+xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/xml, text/xml, */*", forHTTPHeaderField: "Accept")
        request.addValue("\(postString.characters.count)", forHTTPHeaderField: "Content-Length")
        request.addValue("http://schemas.microsoft.com/xrm/2011/Contracts/Services/IOrganizationService/Execute", forHTTPHeaderField: "SOAPAction")
        
        let svc = ServiceHandler()
        svc.tag = "executeSOAP"
        svc.delegate = self
        svc.getNetworkData(request)
    }
    
    
    
    func CreateSOAPHeaderOnline(url:String,keyIdentifier:String,token0:String,token1:String) -> String{
        var XML = [String]()
        XML.append("<s:Header>")
        XML.append("<a:Action s:mustUnderstand=\"1\">http://schemas.microsoft.com/xrm/2011/Contracts/Services/IOrganizationService/Execute</a:Action>")
        XML.append("<Security xmlns=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\">")
        XML.append("<EncryptedData Id=\"Assertion0\" Type=\"http://www.w3.org/2001/04/xmlenc#Element\" xmlns=\"http://www.w3.org/2001/04/xmlenc#\">")
        XML.append("<EncryptionMethod Algorithm=\"http://www.w3.org/2001/04/xmlenc#tripledes-cbc\"/>")
        XML.append("<ds:KeyInfo xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\">")
        XML.append("<EncryptedKey>")
        XML.append("<EncryptionMethod Algorithm=\"http://www.w3.org/2001/04/xmlenc#rsa-oaep-mgf1p\"/>")
        XML.append("<ds:KeyInfo Id=\"keyinfo\">")
        XML.append("<wsse:SecurityTokenReference xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\">")
        XML.append("<wsse:KeyIdentifier EncodingType=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary\" ValueType=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509SubjectKeyIdentifier\">\(keyIdentifier)</wsse:KeyIdentifier>")
        XML.append("</wsse:SecurityTokenReference>")
        XML.append("</ds:KeyInfo>")
        XML.append("<CipherData>")
        XML.append("<CipherValue>\(token0)</CipherValue>")
        XML.append("</CipherData>")
        XML.append("</EncryptedKey>")
        XML.append("</ds:KeyInfo>")
        XML.append("<CipherData>")
        XML.append("<CipherValue>\(token1)</CipherValue>")
        XML.append("</CipherData>")
        XML.append("</EncryptedData>")
        XML.append("</Security>")
        XML.append("<a:MessageID>urn:uuid:\(CreateGUID())</a:MessageID>")
        XML.append("<a:ReplyTo>")
        XML.append("<a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address>")
        XML.append("</a:ReplyTo>")
        XML.append("<a:To s:mustUnderstand=\"1\">\(url)/XRMServices/2011/Organization.svc</a:To>")
        XML.append("</s:Header>")
        return XML.joinWithSeparator("")
    }
    private func CreateGUID() -> String{
        return NSUUID().UUIDString
    }
    
    func finishWithSuccess(response: String, tag: String) {
        delegate?.finishSOAPCall(response)
    }
    
    func finishWithError(error: String, tag: String) {
        print(error)
    }
}