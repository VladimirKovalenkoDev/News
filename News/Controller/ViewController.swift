//
//  ViewController.swift
//  News
//
//  Created by Владимир Коваленко on 16.06.2020.
//  Copyright © 2020 Vladimir Kovalenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var articlesArray = [Articles]()
    let categoryArray = ["auto","world","index","communal","health","games","internet","movies","koronavirus","cosmos","music","science","society","politics",
                        "incident","sport",
                        "computers",
    "finances","ecology","business"]
    
    let myRefreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)) , for: .valueChanged)
        return refreshControl
    }()
    
    @IBOutlet var newsTableView: UITableView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.delegate = self
        newsTableView.dataSource = self
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        newsTableView.refreshControl = myRefreshControl
         downloadData(with: "auto")
    }
    
    @objc private func refresh(sender: UIRefreshControl){
        newsTableView.reloadData()
        sender.endRefreshing()
    }

}
// MARK: - TableViewDelegate, TableViewDataSource
extension ViewController : UITableViewDelegate, UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(articlesArray.count)
        return articlesArray.count
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.timeTitleLabel.text = articlesArray[indexPath.row].lastbuilddate
        cell.upTitleLabel.text = articlesArray[indexPath.row].title
        
        return cell 
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToList", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
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
// MARK: - PickerViewDataSource,PickerViewDelegate
extension ViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return categoryArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        return categoryArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let categoryPicked = categoryArray[row]
        downloadData(with: categoryPicked)
        
        
    }
    
    
    
}


// MARK: - parcing Xml & getting data
extension ViewController: XMLParserDelegate {
    func downloadData(with category: String) {
          let feedParser = FeedParser()
        
        
          feedParser.parseFeed(url: "https://news.yandex.ru/\(category).rss") { (articlesArray) in
              self.articlesArray = articlesArray
              //self.cellStates = Array(repeating: .collapsed, count: rssItems.count)
              
              OperationQueue.main.addOperation {
                self.newsTableView.reloadData()
              }
          }
      }
   }
