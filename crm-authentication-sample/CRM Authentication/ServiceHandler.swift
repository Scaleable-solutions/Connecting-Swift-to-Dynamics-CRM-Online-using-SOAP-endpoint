//
//  ServiceHandler.swift
//  CRM Authetication
//
//  Created by Hamza on 01/12/2015.
//  Copyright © 2015 Scaleable Solutions. All rights reserved.
//

import Foundation

protocol NetworkDelegate{
    
    func finishWithError(error:String,tag:String)
    
    func finishWithSuccess(response:String,tag:String)
}

class ServiceHandler {
    
    var delegate:NetworkDelegate? = nil
    var tag:String? = nil
    
    func getNetworkData(request:NSMutableURLRequest){
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil{
                self.delegate?.finishWithError(error!.description,tag: self.tag!)
                return
            }
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            self.delegate?.finishWithSuccess(responseString! as String,tag: self.tag!)
        }
        task.resume()
    }
}