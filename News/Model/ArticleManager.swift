//
//  ArticleManager.swift
//  News
//
//  Created by Владимир Коваленко on 16.06.2020.
//  Copyright © 2020 Vladimir Kovalenko. All rights reserved.
//
import Foundation
import UIKit
protocol ArticleManagerDelegate {
    func didUploadNews(_ articleManager : ArticleManager, article: Article)
    func didFailWithError (error: Error )
}

struct ArticleManager {
    
    var delegate : ArticleManagerDelegate?
    
    let myUrl = "https://newsapi.org/v2/everything?q=apple&sortBy=popularity&apiKey="
    let apiKey = "b183697651ca46ab9f9978a8d2372f5e"
    var newsData = [Articles] ()

    mutating func loadData(){
    let urlString = "\(myUrl)\(apiKey)"
    print(urlString)
    if let url = URL(string: urlString) {
    // create url session
      let session = URLSession(configuration: .default)
      // GIVE THE session a task
      let task = session.dataTask(with: url) { (data, response, error) in
        print("DONE")
             if error != nil {
                print(error!)
                self.delegate?.didFailWithError(error: error!)
                   return
               }
                  
      if let safeData = data {
        if let article = self.parseJSON(safeData){
    
            self.delegate?.didUploadNews(self, article: article)
            
                }
            }
        }
        task.resume()
    }
}
    mutating func parseJSON(_ data: Data) -> Article? {
        let decoder = JSONDecoder()
        do{
            
            let decodeData = try decoder.decode(ArticleData.self, from: data)
            let newArticle = decodeData.articles
            self.newsData = newArticle
            let title = decodeData.articles[0].title
            let content = decodeData.articles[1].content
            let pubAt = decodeData.articles[2].publishedAt
            print(newArticle)
            let article = Article(titleName: title, contetVieww: content, publishedAtTime: pubAt)
            //print(article.titleName)
                // print(self.newsData)
            
            return article
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
            
        }
        
    }
}
