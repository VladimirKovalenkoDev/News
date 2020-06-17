//
//  ArticleManager.swift
//  News
//
//  Created by Владимир Коваленко on 16.06.2020.
//  Copyright © 2020 Vladimir Kovalenko. All rights reserved.
//

import Foundation

protocol ArticleManagerDelegate {
    func didUpdateNews(_ articleManager : ArticleManager, article: Article)
    func didFailWithError (error: Error )
}

struct ArticleManager {
    
    var delegate : ArticleManagerDelegate?
    
    let myUrl = "https://newsapi.org/v2/sources?language=en&country=us&apiKey="
    let apiKey = "b183697651ca46ab9f9978a8d2372f5e"
    let data : [Article] = []

func loadData(){
    let urlString = "\(myUrl)\(apiKey)"
    print(urlString)
    if let url = URL(string: urlString) {
    // create url session
      let session = URLSession(configuration: .default)
      // GIVE THE session a task
      let task = session.dataTask(with: url) { (data, response, error) in
             if error != nil {
                print(error!)
                self.delegate?.didFailWithError(error: error!)
                   return
               }
                  
      if let safeData = data {
        if let article = self.parseJSON(safeData){
            
            self.delegate?.didUpdateNews(self, article: article)
            
                }
            }
        }
        task.resume()
    }
}
    func parseJSON(_ data: Data) -> Article? {
        let decoder = JSONDecoder()
        do{
            
            let decodeData = try decoder.decode(ArticleData.self, from: data)
            let title = decodeData.title
            let content = decodeData.contet
            let sourceName = decodeData.sourceName
            let pubAt = decodeData.publishedAt
             
            let article = Article(titleName: title, contetVieww: content, sourceNameArt: sourceName, publishedAtTime: pubAt)
            return article
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
            
        }
        
    }
}
