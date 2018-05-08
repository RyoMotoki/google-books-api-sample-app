//
//  ViewController.swift
//  GoogleBooksAPISampleApp
//
//  Created by Ryo Motoki on 2018/05/08.
//  Copyright © 2018年 RyoMotoki. All rights reserved.
//
import GoogleBooksApiClient
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var titileTableView: UITableView!
    var articles: [[String: Any?]] = []
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // searchBarをNavigationBarに載せる
        searchBar = UISearchBar()
        self.navigationItem.titleView = searchBar
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.placeholder = "キーワードを入力して検索"
        searchBar.delegate = self
        
        titileTableView.delegate = self
        titileTableView.dataSource = self
        
        getArticles()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = articles[indexPath.row]["title"] as? String
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let session = URLSession.shared
        let client = GoogleBooksApiClient(session: session)
        
        let req = GoogleBooksApi.VolumeRequest.List(query: searchBar.text!)
        let task: URLSessionDataTask = client.invoke(
            req,
            onSuccess: { volumes in NSLog("\(volumes)")
                self.articles.removeAll()
                for item in volumes.items {
                    let article: [String: Any?] = [
                        "title": item.volumeInfo.title,
                        "authors": item.volumeInfo.authors,
                        "publisher": item.volumeInfo.publisher
                    ]
                    self.articles.append(article)
                }
                print(self.articles.count)
                print(self.articles)
                
                DispatchQueue.main.async {
                    self.titileTableView.reloadData()
                }
        },
            onError: { error in NSLog("\(error)") }
        )
        task.resume()
    }
    
    func getArticles() {
        let session = URLSession.shared
        let client = GoogleBooksApiClient(session: session)
        
        let req = GoogleBooksApi.VolumeRequest.List(query: "東野圭吾")
        let task: URLSessionDataTask = client.invoke(
            req,
            onSuccess: { volumes in NSLog("\(volumes)")
                for item in volumes.items {
                    let article: [String: Any?] = [
                        "title": item.volumeInfo.title,
                        "authors": item.volumeInfo.authors,
                        "publisher": item.volumeInfo.publisher
                    ]
                    self.articles.append(article)
                }
                print(self.articles.count)
                print(self.articles)
                
                DispatchQueue.main.async {
                    self.titileTableView.reloadData()
                }
        },
            onError: { error in NSLog("\(error)") }
        )
        task.resume()
    }
    
}
