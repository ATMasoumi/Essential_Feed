//
//  URLSessionHTTPClient.swift
//  Essential Feed
//
//  Created by Amin on 5/7/1401 AP.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    let session: URLSession
    public init(session: URLSession = .shared) {
        self.session = session
    }
    private struct UnexpectedValuesRepresentation: Error {}
    
    public func get(from url: URL, completion: @escaping(HTTPClient.Result) -> ()) {
        session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                }else if let data = data , let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
            
        }.resume()
    }
}
