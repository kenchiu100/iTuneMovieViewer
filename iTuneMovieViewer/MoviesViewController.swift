//
//  MoviesViewController.swift
//  iTuneMovieViewer
//
//  Created by KaKin Chiu on 3/27/17.
//  Copyright © 2017 KaKin Chiu. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        movieSearchBar.delegate = self

        
        //Get data from the api
        let url = URL(string: "https://itunes.apple.com/us/rss/topmovies/limit=25/json")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    let feed = dataDictionary["feed"] as! NSDictionary
                    self.movies = feed["entry"] as! [NSDictionary]
                    self.filteredData = self.movies
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
        if let movies = filteredData{
            return movies.count
        }else{
            return 0
        }
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
//        let movie = self.movies![indexPath.row] as! NSDictionary
        let movie = self.filteredData![indexPath.row] 
        
        //get the title
        let titleDic = movie["title"] as? NSDictionary
        let title = titleDic?["label"] as! String
        //get the release date
        let releaseDateDic = movie["im:releaseDate"] as! NSDictionary
        let attributesDic = releaseDateDic["attributes"] as! NSDictionary
        let releaseDate = attributesDic["label"] as! String
        //get the price
        let priceDic = movie["im:price"] as? NSDictionary
        let price = priceDic?["label"] as! String
        //get the poster
        let imageDic = movie["im:image"] as! NSArray
        let imagelink = imageDic[2] as! NSDictionary // for the height:60
//        print(imagelink)
        let imageUrlString = imagelink["label"] as! String
        let imageUrl = URL(string: imageUrlString)
        
        cell.titleLabel.text = title
        cell.releaseDateLabel.text = releaseDate
        cell.priceLabel.text = price
        cell.posterView.setImageWith(imageUrl!)
        return cell
    }
    
    
    // This method updates filteredData based on the text in the Search Box
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            filteredData = movies
//        } else {
//            filteredData = movies?.filter({ (movie: NSDictionary) -> Bool in
//                if let title = movie["title"] as? String {
//                    if title.range(of: searchText, options: .caseInsensitive) != nil {
//                        
//                        return  true
//                    } else {
//                        return false
//                    }
//                }
//                return false
//            })
//        }
//        tableView.reloadData()
//    }
    
    //need to change movie from NSArray to Dictionary somehowe in order to fit in movie: NSDictionary
//    // This method updates filteredData based on the text in the Search Box
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = movies
        } else{
            filteredData = movies?.filter({ (amovie: NSDictionary) -> Bool in
                let titleDic = amovie["title"] as! NSDictionary
                if let title = titleDic["label"] as? String{
                    print(title)
                    if title.range(of: searchText, options: .caseInsensitive) != nil{
                        return true
                    }else{
                        return false
                    }
                }
                return false
            })
        }
        tableView.reloadData()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.movieSearchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.movieSearchBar.setShowsCancelButton(false, animated: true)
        movieSearchBar.resignFirstResponder()
        movieSearchBar.text = ""
        filteredData = movies
        tableView.reloadData()
    }

}
