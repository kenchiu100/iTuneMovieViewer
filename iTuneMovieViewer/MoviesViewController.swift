//
//  MoviesViewController.swift
//  iTuneMovieViewer
//
//  Created by KaKin Chiu on 3/27/17.
//  Copyright © 2017 KaKin Chiu. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movies: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        //Get data from the api
        let url = URL(string: "https://itunes.apple.com/us/rss/topmovies/limit=25/json")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    let feed = dataDictionary["feed"] as! NSDictionary
                    self.movies = feed["entry"] as? NSArray
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //if movies is not nil
        if let movies = movies{
            return movies.count
        }else{
            return 0
        }
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        let movie = self.movies![indexPath.row] as! NSDictionary
        let titleDic = movie["title"] as? NSDictionary
        let title = titleDic?["label"] as! String
        
        cell.textLabel!.text = title
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
