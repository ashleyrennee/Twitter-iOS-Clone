//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Ashley Acevedo on 9/29/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    
    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        myRefreshControl.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    
    
    @objc func loadTweet(){
        
        numberOfTweet = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams=["count": numberOfTweet]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: {(tweets: [NSDictionary]) in self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
                
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        
        }, failure: { Error in
            print("could not retrieve tweet")
            print(Error.localizedDescription)
        })
    }

    
    
    
    func loadMoreTweets(){
        
    numberOfTweet = numberOfTweet + 5
    let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    let myParams=["count": numberOfTweet]
        
    TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: {(tweets: [NSDictionary]) in self.tweetArray.removeAll()
        for tweet in tweets{
        self.tweetArray.append(tweet)
                }
        self.tableView.reloadData()
        self.myRefreshControl.endRefreshing()
        
    }, failure: { Error in
        print("could not retrieve tweet")
        print(Error.localizedDescription)
        })
        
    }
    
    override func tableView(_ tableView: UITableView,willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row + 1 == tweetArray.count{
            loadMoreTweets()
        }
    }
    
    // MARK: - Table view data source

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true,completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell",for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = (tweetArray[indexPath.row]["text"] as! String)
        
        //populates images
        let imageUrl = URL(string: (user["profile_image_url_https"]as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    
   // override func viewDidAppear(_ animated: Bool) {
       // super.viewDidAppear(animated)
       // myRefreshControl.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        //tableView.refreshControl = myRefreshControl
    // }

}
