//
//  NewsListViewController.swift
//  News
//
//  Created by Владимир Коваленко on 18.06.2020.
//  Copyright © 2020 Vladimir Kovalenko. All rights reserved.
//

import UIKit

class NewsListViewController: UIViewController {

    @IBOutlet weak var mainContent: UITextView!
    @IBOutlet weak var mainTitle: UILabel!
    var article:Articles?
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTitle.text = article?.title
        mainContent.text = article?.description
       
      /*
        if let imageURL = URL(string: article!.urlToImage) {
                   DispatchQueue.global().async {
                       let data = try? Data(contentsOf: imageURL)
                       if let data = data {
                           let image = UIImage(data: data)
                           DispatchQueue.main.async {
                            self.articleImg.image = image
                              
                       }
                   }
               }
        
          }
        */
     }
}
    

    


