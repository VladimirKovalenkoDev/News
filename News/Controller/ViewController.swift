//
//  ViewController.swift
//  News
//
//  Created by Владимир Коваленко on 16.06.2020.
//  Copyright © 2020 Vladimir Kovalenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let url = URL(string: "https://newsapi.org/v2/everything?q=apple&sortBy=popularity&apiKey=b183697651ca46ab9f9978a8d2372f5e")
    var articlesArray = [Articles]()
    let myRefreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)) , for: .valueChanged)
        return refreshControl
    }()
    
    @IBOutlet var newsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.delegate = self
        newsTableView.dataSource = self
        downloadData()
        newsTableView.refreshControl = myRefreshControl
        
    }
    @objc private func refresh(sender: UIRefreshControl){
        newsTableView.reloadData()
        sender.endRefreshing()
    }

    
      
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(articlesArray.count)
        return articlesArray.count
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.timeTitleLabel.text = articlesArray[indexPath.row].publishedAt
        cell.upTitleLabel.text = articlesArray[indexPath.row].title
        
        return cell 
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToList", sender: self)
      
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "goToList" {
            if let indexPath = newsTableView.indexPathForSelectedRow {
                      let destinationVC = segue.destination as! NewsListViewController
                destinationVC.article = articlesArray[indexPath.row]
            }
        }
      }
}



// MARK: - parcing JSON & getting data
extension ViewController {
    
      func downloadData() {
          guard let downloadURL = url else { return }
          URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
              guard let data = data, error == nil, urlResponse != nil else {
                  print("something is wrong")
                  return
              }
              print("downloaded")
              do
              {
                  let decoder = JSONDecoder()
                  let decodeData = try decoder.decode(ArticleData.self, from: data)
                self.articlesArray = decodeData.articles
                  DispatchQueue.main.async {
                      self.newsTableView.reloadData()
                  }
              } catch {
                  print("something wrong after downloaded")
              }
          }.resume()
      }
   }
