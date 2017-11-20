//
//  ViewController.swift
//  Project0410
//
//  Created by yipei zhu on 4/10/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import UIKit


class NewsView: UITableView, UITableViewDelegate, UITableViewDataSource{
    
    let itemStore = NewsDataStore()

    
    let NewsAdd = { (itemStore:DataStore, json: [ String : AnyObject], newsView:NewsView )->Void in
        if let articlesFromJson = json["results"] as? [[String:AnyObject]]{
            itemStore.clear()
            for articleFromJson in articlesFromJson{
                let dataItem = NewsDataItem()
                if let title = articleFromJson["title"] as? String,
                    let byline = articleFromJson["byline"] as? String,
                    let desc = articleFromJson["abstract"] as? String,
                    let url = articleFromJson["url"] as? String,
                    let publishedtime = articleFromJson["published_date"] as? String{
                    
                    dataItem.byline = byline
                    dataItem.desc = desc
                    dataItem.url = url
                    dataItem.title = title
                    dataItem.publishedate = publishedtime
                    
                    if let imageList = articleFromJson["multimedia"] as? [[String:AnyObject]]{
                        for imageInfo in imageList{
                            
                            if let imageUrl = imageInfo["url"] as? String,
                                let copyright = imageInfo["copyright"] as? String,
                                let format = imageInfo["format"] as? String {
                                var imageItem = Photo()
                                imageItem.ImageUrl = imageUrl
                                imageItem.copyright = copyright
                                imageItem.format = format
                                dataItem.imageList.append(imageItem)
                            }
                        }
                        
                    }
                    
                    //dataItem.image = DataProcessing.downloadImage(from: urlToImage)!

                    itemStore.append(dataItem)
                }
            }
        }
        DispatchQueue.main.async{
            newsView.reloadData()
            
        }
    }
    
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newsWeb") as! NewsWebViewController
        webVC.url = self.itemStore.allItems[indexPath.row].url
        present(webVC, animated: true, completion: nil)
    }*/
    
    
    func init(frame: CGRect,style: UITableViewStyle){
        DataProcessing.loadNewList(SubURL.HomeUrl,itemStore,self,NewsAdd)

    }
    
    
    let indexBar:IndexBar = {
        let indexbar = IndexBar()
        return indexbar
    }()
    
   

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        cell.titleLabel.text = itemStore.allItems[indexPath.row].title
        cell.descriptionLabel.text = itemStore.allItems[indexPath.row].desc
        //cell.authorLabel.text =  itemStore.allItems[indexPath.row].byline
        cell.authorLabel.text = itemStore.allItems[indexPath.row].publishedate
        if itemStore.allItems[indexPath.row].imageList.count > 0 {
            cell.newsImage.downloadImage(from: itemStore.allItems[indexPath.row].imageList[0].ImageUrl!)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("itemStore.allItems.count: \(itemStore.allItems.count)")
        
        return itemStore.allItems.count
    }
    

    

}



