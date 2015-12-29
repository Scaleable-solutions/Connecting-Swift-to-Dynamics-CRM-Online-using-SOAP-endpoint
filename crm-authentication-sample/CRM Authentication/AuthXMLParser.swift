//
//  XMLParser.swift
//  CRM Authetication
//
//  Created by Hamza on 03/12/2015.
//  Copyright © 2015 Scaleable Solutions. All rights reserved.
//

import Foundation

class AuthXMLParser : NSObject,NSXMLParserDelegate  {
    
    private var xmlString:String
    var returnValue:AuthHolder?
    var holder = AuthHolder()
    var cipherValuetag:Int
    var elementName:String = ""
    
    init(xml:String){
        self.xmlString=xml
        self.cipherValuetag = 0
        super.init()
    }
    
    func parse()->Bool{
        let p=NSXMLParser(data: xmlString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        p.delegate = self
        if p.parse(){
            returnValue = holder
            return true
        }
        NSLog("Error")
        return false
    }
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.elementName = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        if(self.elementName == "CipherValue"){
            if(self.cipherValuetag == 0){
                holder.token0 = string
                self.cipherValuetag++
            }else{
                holder.token1 = string
            }
        }
        if(self.elementName == "wsse:KeyIdentifier" && self.holder.keyIdentifier == ""){
            holder.keyIdentifier  = string
        }
        if(self.elementName == "wsu:Expires" && self.holder.expire == ""){
            holder.expire = string
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
}