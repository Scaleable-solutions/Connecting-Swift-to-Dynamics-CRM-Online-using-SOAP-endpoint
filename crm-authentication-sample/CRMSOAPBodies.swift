//
//  CRMSOAPBodies.swift
//  crm-authentication-sample
//
//  Created by Hamza on 28/12/2015.
//  Copyright © 2015 Scaleable Solutions. All rights reserved.
//

import Foundation

class SOAPBodies{
    
    class func WhoIAMBody() -> String{
        
        var XML = [String]()
        XML.append("<s:Body>")
        XML.append("<Execute xmlns=\"http://schemas.microsoft.com/xrm/2011/Contracts/Services\">")
        XML.append("<request i:type=\"c:WhoAmIRequest\" xmlns:b=\"http://schemas.microsoft.com/xrm/2011/Contracts\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:c=\"http://schemas.microsoft.com/crm/2011/Contracts\">")
        XML.append("<b:Parameters xmlns:d=\"http://schemas.datacontract.org/2004/07/System.Collections.Generic\"/>")
        XML.append("<b:RequestId i:nil=\"true\"/>")
        XML.append("<b:RequestName>WhoAmI</b:RequestName>")
        XML.append("</request>")
        XML.append("</Execute>")
        XML.append("</s:Body>")
        return XML.joinWithSeparator("")
    }
    
    class func CRMUserInfoBody(id:String) -> String{
        
        var XML = [String]()
        XML.append("<s:Body>")
        XML.append("<Execute xmlns=\"http://schemas.microsoft.com/xrm/2011/Contracts/Services\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\">")
        XML.append("<request i:type=\"a:RetrieveRequest\" xmlns:a=\"http://schemas.microsoft.com/xrm/2011/Contracts\">")
        XML.append("<a:Parameters xmlns:b=\"http://schemas.datacontract.org/2004/07/System.Collections.Generic\">")
        XML.append("<a:KeyValuePairOfstringanyType>")
        XML.append("<b:key>Target</b:key>")
        XML.append("<b:value i:type=\"a:EntityReference\">")
        XML.append("<a:Id>\(id)</a:Id>")
        XML.append("<a:LogicalName>systemuser</a:LogicalName>")
        XML.append("<a:Name i:nil=\"true\" />")
        XML.append("</b:value>")
        XML.append("</a:KeyValuePairOfstringanyType>")
        XML.append("<a:KeyValuePairOfstringanyType>")
        XML.append("<b:key>ColumnSet</b:key>")
        XML.append("<b:value i:type=\"a:ColumnSet\">")
        XML.append("<a:AllColumns>false</a:AllColumns>")
        XML.append("<a:Columns xmlns:c=\"http://schemas.microsoft.com/2003/10/Serialization/Arrays\">")
        XML.append("<c:string>firstname</c:string>")
        XML.append("<c:string>lastname</c:string>")
        XML.append("</a:Columns>")
        XML.append("</b:value>")
        XML.append("</a:KeyValuePairOfstringanyType>")
        XML.append("</a:Parameters>")
        XML.append("<a:RequestId i:nil=\"true\" />")
        XML.append("<a:RequestName>Retrieve</a:RequestName>")
        XML.append("</request>")
        XML.append("</Execute>")
        XML.append("</s:Body>")
        return XML.joinWithSeparator("")
    }
}