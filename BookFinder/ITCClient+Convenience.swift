//
//  ITCClient+Convenience.swift
//  BookFinder
//
//  Created by Atikur Rahman on 6/17/16.
//  Copyright © 2016 Atikur Rahman. All rights reserved.
//

import UIKit

extension ITCClient {
    
    func getBooksForSearchTerm(term: String) {
        let methodParameters: [String: String] = [
            ParameterKeys.Term: term,
            ParameterKeys.Entity: ParameterValues.EntityEbook
        ]
        
        let url = itcURLFromParameters(methodParameters)
        let request = NSURLRequest(URL: url)
        
        taskForRequest(request) {
            result, error in
            
            guard error == nil else {
                print(error)
                return
            }
            
            print(result)
        }
    }
    
    // MARK: - Helpers
    
    private func itcURLFromParameters(parameters: [String: AnyObject]) -> NSURL {
        let components = NSURLComponents()
        components.scheme = Constants.APIScheme
        components.host = Constants.APIHost
        components.path = Constants.APIPath
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
}