//
//  ViewController.swift
//  News
//
//  Created by Владимир Коваленко on 16.06.2020.
//  Copyright © 2020 Vladimir Kovalenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ArticleManagerDelegate {
    
    func didUploadNews(_ articleManager: ArticleManager, article: Article) {
        DispatchQueue.main.async {
            self.newsTableView.reloadData()
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
    
    @IBOutlet var newsTableView: UITableView!
    
    var articleManager = ArticleManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //newsTableView.delegate = self
        newsTableView.dataSource = self
        articleManager.delegate = self
        articleManager.loadData()
       
        
    }

    
      
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(articleManager.newsData.count)
        return articleManager.newsData.count
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let article = articleManager.newsData[indexPath.row]
        cell.timeTitleLabel.text = articleManager.newsData[indexPath.row].title
        print(article)
        return cell 
    }
    
    
    
    
   
    

}

