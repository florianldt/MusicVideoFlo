//
//  APIManager .swift
//  MusicVideoFlo
//
//  Created by Florian LUDOT on 26/06/16.
//  Copyright © 2016 Florian LUDOT. All rights reserved.
//

import Foundation

class APIManager {
    
    func loadData(urlString:String, completion: (result:String) -> Void ) {
        
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        // let session = NSURLSession.sharedSession()
        let url = NSURL(string: urlString)!
        
        let task = session.dataTaskWithURL(url) {
            (data, response, error) -> Void in
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    completion(result: (error!.localizedDescription))
                }
            } else {
                
                //Added for JSONSerialization
                //print(data)
                do {
                    /* .AllowsFragment - top level object is not Array or Dictionnary.
                     Any type of string or value
                     NJSONSerialization requires the Do / Try / Catch
                     Convert the NSDATA into a JSON Object and cast it to a Dictionnary */
                    
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                        as? [String: AnyObject] {
                        
                        print(json)
                        
                        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
                        dispatch_async(dispatch_get_global_queue(priority, 0)) {
                            dispatch_async(dispatch_get_main_queue()) {
                                completion(result: "JSONSerialization Successful")
                            }
                        }
                    }
                } catch {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(result: "ERROR IN NSJSONSerialization")
                    }
                }
                //End of JSONSerialization                                    }
            }
            
        }
        task.resume()
        
    }
}