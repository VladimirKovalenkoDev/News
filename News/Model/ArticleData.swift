//
//  ArticleData.swift
//  News
//
//  Created by Владимир Коваленко on 16.06.2020.
//  Copyright © 2020 Vladimir Kovalenko. All rights reserved.
//

import Foundation

class ArticleData: Codable {

    let articles:[Articles]
    init(articles:[Articles]){
        self.articles = articles
    }
    
} 
class Articles: Codable {
    let title: String
    let content: String
    let publishedAt: String
    // let source: [Source]
    init(title:String ,content:String ,publishedAt: String){
        self.title = title
        self.content = content
        self.publishedAt = publishedAt
}
//struct Source: Codable {
//    let name: String
}
