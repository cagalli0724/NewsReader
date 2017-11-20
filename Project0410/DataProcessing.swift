//
//  DataProcessing.swift
//  Project0410
//
//  Created by yipei zhu on 4/10/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON
import AlamofireImage
import FirebaseDatabase



enum SubURLEnum: String {
    case HomeUrl = "home"
    case WorldUrl = "world"
    case NationalUrl = "national"
    case PoliticsUrl = "politics"
    case UpshotUrl = "upshot"
    case NyregionUrl = "nyregion"
    case BusinessUrl = "business"
    case TechnologyUrl = "technology"
    case ScienceUrl = "science"
    case HealthUrl = "health"
    case SportsUrl = "sports"
    case ArtsUrl = "arts"
    case BooksUrl = "books"
    case MoviesUrl = "movies"
    case TheaterUrl = "theater"
    case FashionUrl = "fashion"
    case FoodUrl = "food"
    case TravelUrl = "travel"
    case RealestateUrl = "realestate"
    case AutomobilesUrl = "automobiles"

}


class DataProcessing
{
        
    static func SaveToFirebase(_ fvtstore:FavoriteStore,_ indexStore:IndexStore,  _ name:String){
        let favoriteFileName = "\(name)-favorite"
        let newString = favoriteFileName.replacingOccurrences(of: ".", with: "-")
        let ref = FIRDatabase.database().reference().child(newString)
        print(newString)
        ref.removeValue(completionBlock: {(error, ref1) -> Void in
            if error != nil {
                print("\(error)")
                return
            }
            for item in fvtstore.allItems{
                var tmpFvt = [String:String]()
                tmpFvt["title"] = item.title
                tmpFvt["url"] = item.url
                ref1.childByAutoId().setValue(tmpFvt)
            }
            
        })
        
        let indexFileName = "\(name)-index"
        let newString2 = indexFileName.replacingOccurrences(of: ".", with: "-")
        print(newString2)
        let refIndex = FIRDatabase.database().reference().child(newString2)
        
        refIndex.removeValue(completionBlock: {(error, ref2) -> Void in
            if error != nil {
                print("\(error)")
                return
            }
            
            var tmpIndex = [String]()
            for item in indexStore.allItems{
                tmpIndex.append(item)
            }
            
            ref2.childByAutoId().setValue(tmpIndex)
            
            
        })
        
        
    }
    
    
    static func RestoreFromFirebase(_ newsCtrl:NewsViewController, _ itemStore:NewsDataStore, _ fvtstore:FavoriteStore,_ indexStore:IndexStore,  _ name:String)
        //_ fvtCtrl:FavoriteController,
    {
       
        let favoriteFileName = "\(name)-favorite"
        let newString = favoriteFileName.replacingOccurrences(of: ".", with: "-")
        let ref = FIRDatabase.database().reference().child(newString)
        fvtstore.clearAll()
        ref.observeSingleEvent(of: FIRDataEventType.value, with: {(snapshot) in
            
            if snapshot.childrenCount > 0{
                
                
                for news in snapshot.children.allObjects as![FIRDataSnapshot]{
                    let object = news.value as? [String:AnyObject]
                    
                    let title = object?["title"]
                    let url = object?["url"]
                    
                    let favorite = FavoriteItem(Title: title as! String, Url: url as! String)
                    fvtstore.allItems.append(favorite)
                    
                }
            //fvtCtrl.tableView.reloadData()
                
            }
        
        
        
        })
        
        let indexFileName = "\(name)-index"
        let newString2 = indexFileName.replacingOccurrences(of: ".", with: "-")
        let refIndex = FIRDatabase.database().reference().child(newString2)
        
        refIndex.observeSingleEvent(of: FIRDataEventType.value, with: {(snapshot) in
            
            
            if snapshot.childrenCount > 0{
                indexStore.clearAll()
                
                for index in snapshot.children.allObjects as![FIRDataSnapshot]{
                    if let index = index.value as? [String]{
                        for value in index {
                            indexStore.allItems.append(value)
                        }
                    }
                    
                    
                }
                
                
                
            }else{
                indexStore.resetToDefaultList()
            }
            
            var indexNum: Int = 0
            itemStore.setIndexNum(indexStore.allItems.count)
            
            for selectItem in indexStore.allItems{
                DataProcessing.loadNewList(selectItem,itemStore,indexNum,newsCtrl)
                indexNum = indexNum + 1
            }
            
        })

        
        
    }
    
    static func NewAdd(_ itemStore:NewsDataStore,_ json: [ String : AnyObject],_ IndexNum:Int,_ viewContr: NewsViewController ){
        if let articlesFromJson = json["results"] as? [[String:AnyObject]]{
            itemStore.clearItemsByIndx(IndexNum)
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
                    dataItem.type = viewContr.indexStore.allItems[IndexNum]
                    
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
                    
                    itemStore.append(IndexNum,dataItem)
                }
            }
        }
        itemStore.appendItemCount(IndexNum)
        
        if(viewContr.indexStore.SelectedIndex == IndexNum)
        {
            //if(viewContr != nil)
            //{
                viewContr.tableview.reloadData()
                viewContr.collectionview.reloadData()
            //}
           

        }
        
    }
    
    static let indexURL: [Int:String] =  [
                                             0:"home",
                                             1:"world",
                                             2:"national",
                                             3:"politics",
                                             4:"upshot",
                                             5:"nyregion",
                                             6:"business",
                                             7:"technology",
                                             8:"science",
                                             9:"health",
                                             10:"sports",
                                             11:"arts",
                                             12:"books",
                                             13:"movies",
                                             14:"theater",
                                             15:"fashion",
                                             16:"food",
                                             17:"travel",
                                             18:"realestate",
                                             19:"automobiles"
    ]

    
    
    static let subURL: [String:String] =  ["home":"home.json",
                                    "world":"world.json",
                                    "national":"national.json",
                                    "politics":"politics.json",
                                    "upshot":"upshot.json",
                                    "nyregion":"nyregion.json",
                                    "business":"business.json",
                                    "technology":"technology.json",
                                    "science":"science.json",
                                    "health":"health.json",
                                    "sports":"sports.json",
                                    "arts":"arts.json",
                                    "books":"books.json",
                                    "movies":"movies.json",
                                    "theater":"theater.json",
                                    "fashion":"fashion.json",
                                    "food":"food.json",
                                    "travel":"travel.json",
                                    "realestate":"realestate.json",
                                    "automobiles":"automobiles.json"
                                    ]
    
        
    
    fileprivate static let baseURLString = "https://api.nytimes.com/svc/topstories/v2/"
    fileprivate static let APIKey = "7b9385ceda3044849cf86ff995a39bf2"
    
    init()
    {
        
    }
   
    fileprivate static func nyTimeURL(_ subURLName: String,_ parameters: [String: String]?) -> URL{
        let url:String = "\(baseURLString)\(subURL[subURLName]!)"
        var components = URLComponents(string:url)
        var queryItems = [URLQueryItem]()
        
        let baseParams = ["api-key": APIKey]
        
        for (key, value) in baseParams {
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        }


        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let queryItem = URLQueryItem(name: key, value: value)
                queryItems.append(queryItem)
            }
        }
        
        components?.queryItems = queryItems
        
        return components!.url!

    }
    
    static func loadNewList(_ subUrl: String,_ store:NewsDataStore,_ selectedIndex:Int, _ viewContr: NewsViewController){
                            //_ closure: @escaping(_ store:NewsDataStore,_ source: [ String : AnyObject],_ selectedIndex:Int) -> Void){
        
        
            let url:URL = nyTimeURL(subUrl,nil)
            
            print("URL:\(url.absoluteString)")
            
            Alamofire.request(url.absoluteString).responseJSON{
                (response) -> Void in // method defaults to `.get`
                switch response.result {
                case .success:
                    print("data: \(response.result.value)")
                    let json = response.result.value as! [String : AnyObject]
                    DataProcessing.NewAdd(store,json,selectedIndex, viewContr)
                case .failure(let error):
                    print(error)
                    return
                }
                
            }
        
        
        
        
    }
    
}

/*class DataStore{
    
    init(){
        print("DataStore init!")
    }
    
    func append(_ item: NSObject) -> Void{
        print("DataStore append!")
    }
    
    func clear() -> Void{
        print("DataStore clear!")
    }
}*/

extension UIImageView{
    func downloadImage(from url:String, to imageStore:ImageStore){
        Alamofire.request(url).responseImage { response in
            
            switch response.result {
            case .success:
                if let img = response.result.value {
                    self.image = img
                    imageStore.setImage(img, forKey: url)
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
}



