//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by aria javanmard on 4/29/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numberOfTweets : Int!
    let refreshControll = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControll.addTarget(self, action: #selector(LoadTweet), for: .valueChanged)
        tableView.refreshControl = refreshControll
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
        //self.LoadTweet()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.LoadTweet()
    }
    @objc func LoadTweet(){
        numberOfTweets = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myprams = ["count" : numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myprams, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
               self.tableView.reloadData()
            self.refreshControll.endRefreshing()
        }, failure: { (Error) in
            print("could't retrieve tweets")
        })
    }
    
    
    func loadMoreTweets(){
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = numberOfTweets + 20
        let myparam = ["count":numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myparam, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
               self.tableView.reloadData()
            self.refreshControll.endRefreshing()
        }, failure: { (Error) in
            print("could't retrieve tweets")
        })

        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    

    @IBAction func Logout_Button(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "User Logged in")
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetcell", for: indexPath) as! TweetCellTableViewCell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as! String
        cell.descriptionLabel.text = tweetArray[indexPath.row]["text"] as! String
       
        let imageUrl = URL(string: (user["profile_image_url_https"] as! String))
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data{
            cell.profilePic.image = UIImage(data: imageData)
        }
       // cell.setFavorite(tweetArray[indexPath.row]["favorited"]) as! Bool
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        
        
        
        cell.retweeted = tweetArray[indexPath.row]["retweeted"] as! Bool
        return cell
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

    

}
