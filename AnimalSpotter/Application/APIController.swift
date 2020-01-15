//
//  APIController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class APIController {
    
    private let baseURL = URL(string: "https://lambdaanimalspotter.vapor.cloud/api")!
    var bearer: Bearer?
    
    // create function for sign up
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        
        // building up url request
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            // or we can do
//            request.httpBody = try jsonEncoder.encode(user)
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    .resume()
    }
    
    // create function for sign in
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
            let signInURL = baseURL.appendingPathComponent("users/login")
            
            // building up url request
            var request = URLRequest(url: signInURL)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let jsonEncoder = JSONEncoder()
            do {
                let jsonData = try jsonEncoder.encode(user)
                request.httpBody = jsonData
                // or we can do
    //            request.httpBody = try jsonEncoder.encode(user)
            } catch {
                print("Error encoding user object: \(error)")
                completion(error)
                return
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let response = response as? HTTPURLResponse,
                    response.statusCode != 200 {
                    completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                    return
                }
                
                if let error = error {
                    completion(error)
                    return
                }
                
                guard let data = data else {
                    completion(NSError())
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    self.bearer = try decoder.decode(Bearer.self, from: data)
                } catch {
                    print("Error decoding bearer object: \(error)")
                    completion(error)
                    return
                }
                completion(nil)
            }
        .resume()
        }
    
    // create function for fetching all animal names
    
    // create function for fetching animal details
    
    // create function to fetch image
}
