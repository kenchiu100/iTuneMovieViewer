//
//  DetailViewController.swift
//  iTuneMovieViewer
//
//  Created by KaKin Chiu on 3/29/17.
//  Copyright © 2017 KaKin Chiu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
//    @IBOutlet weak var viewBtn: UIButton!
    var movie: NSDictionary!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set contentsize so scrollView knows how much to scroll
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        //get the title
        let titleDic = movie["title"] as? NSDictionary
        let title = titleDic?["label"] as! String
        //get the overview
        let summaryDic = movie["summary"] as? NSDictionary
        let summary = summaryDic?["label"] as! String
        
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
        
        if let imageUrlString = imagelink["label"] as? String{
            let imageUrl = URL(string: imageUrlString)
            posterImageView.setImageWith(imageUrl!)
            
        }
        
        
        titleLabel.text = title
        overviewLabel.text = summary
        overviewLabel.sizeToFit()
        releaseDateLabel.text = releaseDate
        priceLabel.text = price
        


        // Do any additional setup after loading the view.
    }

    @IBAction func viewInItunes(_ sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: "itms://itunes.apple.com/us/movie/moana-2016/id1175204079?uo=2")! as URL)
        

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
