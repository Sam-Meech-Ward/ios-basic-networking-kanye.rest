//
//  ViewController.swift
//  Quotes
//
//  Created by Sam Meech-Ward on 2020-05-23.
//  Copyright © 2020 meech-ward. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var label: UILabel!
  
  @IBOutlet weak var imageView: UIImageView!
  
  let networker = Networker.shared
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    networker.getImage { (data, error)  in
      if let error = error {
        print(error)
        return
      }
      
      self.imageView.image = UIImage(data: data!)
    }
  }

  @IBAction func randomQuote(_ sender: Any) {
    
    networker.getQuote { (kanye, error) -> (Void) in
      if let _ = error {
        self.label.text = "Error"
        return
      }
      
      self.label.text = kanye?.quote
    }
    
  }
  
}

