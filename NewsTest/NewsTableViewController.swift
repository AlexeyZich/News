//
//  ViewController.swift
//  NewsTest
//
//  Created by Алексей Ермолаев on 16.03.2019.
//  Copyright © 2019 Алексей Ермолаев. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class NewsTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var news: Results<NewsDB>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryNews()
        setupTableView()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setupTableView() {
        news = realm.objects(NewsDB.self)
        tableView.register(UINib(nibName: Constants.nibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifire)
        tableView.reloadData()
        tableView.separatorColor = UIColor.clear
        tableView.refreshControl?.addTarget(self, action: #selector(NewsTableViewController.pullToRefresh(refreshControl:)), for: .valueChanged)
        tableView.refreshControl?.tintColor = UIColor.gray
        tableView.refreshControl?.beginRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (news != nil) {
            return news.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifire) as! NewsTableViewCell
        let newsItem = news[indexPath.row]
        cell.newsTitle.text = newsItem.newsTitle
        cell.newsTime.text = newsItem.newsPublishedTime
        cell.newsDate.text = newsItem.newsPublishedDate
        cell.newsImage?.imageFromServerURL(urlString: newsItem.newsImage, placeHolder: nil)
        cell.newsImage.contentMode = .scaleAspectFit
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tap at \(indexPath.row) indexPath.row")
        let newsItem = news[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailNewsViewController = storyboard.instantiateViewController(withIdentifier: "DetailNewsViewController") as! DetailNewsViewController
        detailNewsViewController.newsTitle = newsItem.newsTitle
        detailNewsViewController.newsTimePublished = newsItem.newsPublishedTime
        detailNewsViewController.newsDatePublished = newsItem.newsPublishedDate
        detailNewsViewController.newsDesription = newsItem.newsDescription
        detailNewsViewController.newsImageUrl = newsItem.newsImage
        
        self.navigationController?.pushViewController(detailNewsViewController, animated: true)
    }
    
    func queryNews() {
        getNewsFromApi()
    }
    
    @objc func pullToRefresh(refreshControl: UIRefreshControl) {
        cleanRealmDB()
        self.getNewsFromApi()
        refreshControl.endRefreshing()
    }
    
    func getNewsFromApi() {
        Alamofire.request("https://newsapi.org/v2/top-headlines?country=ru&apiKey=\(Constants.APIKey)").responseJSON { [unowned self] response in
            print("Result: \(response.result)")
            if (response.result.isSuccess) {
                if let json = response.result.value {
                    if let dict = json as? NSDictionary {
                        let status = dict.value(forKey: Constants.status) as? String
                        if (status == "ok") {
                            if let articles = dict[Constants.articles] as? NSArray {
                                for article in articles {
                                    if let news = article as? NSDictionary {
                                        let newsItem = NewsDB()
                                        newsItem.newsTitle = (news.value(forKey: Constants.title) as? String)!
                                        let publishedAt = news.value(forKey: Constants.publishedAt) as? String
                                        newsItem.newsPublishedTime = publishedAt?.convertDatePublishedToTime(publishedAt: publishedAt ?? "") ?? ""
                                        newsItem.newsPublishedDate = publishedAt?.convertDatePublishedToDate(publishedAt: publishedAt ?? "") ?? ""
                                        newsItem.newsDescription = (news.value(forKey: Constants.description) as? String ?? "")
                                        newsItem.newsUrl = (news.value(forKey: Constants.url) as? String)!
                                        newsItem.newsImage = (news.value(forKey: Constants.image) as? String ?? "")
                                        self.writeNewsItemRealmDB(newsItem: newsItem)
                                    }
                                }
                            }
                        } else {
                            let message = dict[Constants.message] as? String
                            self.buildAlertController(message: message!)
                        }
                    }
                }
            } else if (response.result.isFailure) {
                self.buildAlertController(message: "")
            }
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func writeNewsItemRealmDB(newsItem: NewsDB) {
        try! self.realm.write {
            self.realm.add(newsItem)
        }
    }
    
    func cleanRealmDB () {
        try! self.realm.write {
            self.realm.deleteAll()
        }
    }
    
    func buildErrorImage() {
        self.tableView.refreshControl?.endRefreshing()
        
        let imageName = "ooop.jpg"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        self.tableView.isHidden = true
        self.view.isHidden = false
        self.view.addSubview(imageView)
        imageView.center.x = self.view.center.x
        imageView.center.y = self.view.center.y - 50
    }
    
    func buildAlertController(message: String) {
        if (news.count == 0) {
            self.buildErrorImage()
        }
        let alertController = UIAlertController(title: Constants.errorTitle, message: message.isEmpty ? Constants.connectionError : message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: Constants.OK, style: .cancel) { (action:UIAlertAction) in }
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }

}



