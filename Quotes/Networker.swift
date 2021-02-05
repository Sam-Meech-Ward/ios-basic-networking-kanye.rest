//
//  Networker.swift
//  Quotes
//
//  Created by Sam Meech-Ward on 2020-05-23.
//  Copyright © 2020 meech-ward. All rights reserved.
//

import Foundation

enum NetworkerError: Error {
  case badResponse
  case badStatusCode(Int)
  case badData
}

class Networker {
  
  static let shared = Networker()
  
  private let session: URLSession
  
  init() {
    let config = URLSessionConfiguration.default
    session = URLSession(configuration: config)
  }
  
  func getQuote(completion: @escaping (Kanye?, Error?) -> (Void)) {
    let url = URL(string: "https://api.kanye.rest/")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
      
      if let error = error {
        DispatchQueue.main.async {
          completion(nil, error)
        }
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse else {
        DispatchQueue.main.async {
          completion(nil, NetworkerError.badResponse)
        }
        return
      }
      
      guard (200...299).contains(httpResponse.statusCode) else {
        DispatchQueue.main.async {
          completion(nil, NetworkerError.badStatusCode(httpResponse.statusCode))
        }
        return
      }
      
      guard let data = data else {
        DispatchQueue.main.async {
          completion(nil, NetworkerError.badData)
        }
        return
      }
      
      do {
        let kanye = try JSONDecoder().decode(Kanye.self, from: data)
        DispatchQueue.main.async {
          completion(kanye, nil)
        }
      } catch let error {
        DispatchQueue.main.async {
          completion(nil, error)
        }
      }
    }
    task.resume()
  }
  
  func getImage(completion: @escaping (Data?, Error?) -> (Void)) {
    let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Kanye_West_at_the_2009_Tribeca_Film_Festival-2_%28cropped%29.jpg/440px-Kanye_West_at_the_2009_Tribeca_Film_Festival-2_%28cropped%29.jpg")!
    
    let task = session.downloadTask(with: url) { (localUrl: URL?, response: URLResponse?, error: Error?) in
      
      if let error = error {
        DispatchQueue.main.async {
          completion(nil, error)
        }
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse else {
        DispatchQueue.main.async {
          completion(nil, NetworkerError.badResponse)
        }
        return
      }
      
      guard (200...299).contains(httpResponse.statusCode) else {
        DispatchQueue.main.async {
          completion(nil, NetworkerError.badStatusCode(httpResponse.statusCode))
        }
        return
      }
      
      guard let localUrl = localUrl else {
        DispatchQueue.main.async {
          completion(nil, NetworkerError.badData)
        }
        return
      }
      
      do {
        let data = try Data(contentsOf: localUrl)
        DispatchQueue.main.async {
          completion(data, nil)
        }
      } catch let error {
        DispatchQueue.main.async {
          completion(nil, error)
        }
      }
    }
    task.resume()
  }
  
}
