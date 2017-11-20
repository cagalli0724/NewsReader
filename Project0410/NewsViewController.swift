//
//  ViewController.swift
//  Project0410
//
//  Created by yipei zhu on 4/10/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import UIKit
import MJRefresh

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var collectionview:UICollectionView!
    
    //top refresh
    let headerRefresh = MJRefreshNormalHeader()
    //button refresh
    let footerRefresh = MJRefreshAutoNormalFooter()
    
    //var refresher: UIRefreshControl = UIRefreshControl()
    
    var itemStore:NewsDataStore!
    
    var indexStore:IndexStore!
    
    var imageStore:ImageStore!
    
    var favoriteStore: FavoriteStore!
    
    
    
    
    func HRefresh(){
        print("Refreshing works!")
        DataProcessing.loadNewList(indexStore.allItems[indexStore.SelectedIndex],itemStore,indexStore.SelectedIndex,self)
        
        self.tableview.mj_header.endRefreshing()
    }
    
    func fRefresh(){
        print("Refreshing works!")
        
        itemStore.appendItemCount(indexStore.SelectedIndex)
        
        self.tableview.reloadData()
        self.tableview.mj_footer.endRefreshing()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.performSegue(withIdentifier: "NewsDetail", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Segue invoked.")
        
        if segue.identifier == "NewsDetail" {
            print("go to webpage")
            if let row = tableview.indexPathForSelectedRow?.row {
                let item = itemStore.allItems[indexStore.SelectedIndex][row]
                
                let destinationController = segue.destination as! NewsWebViewController
                destinationController.url = item.url
            }
            
            
        }
    }
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        
    
        //self.automaticallyAdjustsScrollViewInsets = false
        
        
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        collectionview.delegate = self
        collectionview.dataSource = self
        
        
        headerRefresh.setRefreshingTarget(self,refreshingAction: #selector(NewsViewController.HRefresh))
        
        self.tableview.mj_header = headerRefresh
        
        footerRefresh.setRefreshingTarget(self, refreshingAction: #selector(NewsViewController.fRefresh))
        self.tableview.mj_footer = footerRefresh
        
        if(MyTabBarController.ifLogin){
            
            print("!!!!!!!!!!!!!!!!!!!!!!!")
            MyTabBarController.ifLogin = false
            
            DataProcessing.RestoreFromFirebase(self,MyTabBarController.itemStore,MyTabBarController.favoriteStore,MyTabBarController.indexStore,MyTabBarController.emailName!)
            
            
            
            
        }

        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
    
        cell.titleLabel.text = itemStore.allItems[indexStore.SelectedIndex][indexPath.row].title
        cell.descriptionLabel.text = itemStore.allItems[indexStore.SelectedIndex][indexPath.row].desc
        //cell.authorLabel.text =  itemStore.allItems[indexPath.row].byline
        cell.authorLabel.text = itemStore.allItems[indexStore.SelectedIndex][indexPath.row].publishedate
        if itemStore.allItems[indexStore.SelectedIndex][indexPath.row].imageList.count > 0 {
            let imgUrl = itemStore.allItems[indexStore.SelectedIndex][indexPath.row].imageList[0].ImageUrl!
            
            if let image = imageStore.imageForKey(imgUrl) {
                print("get image from cache.")
                cell.newsImage.image = image
            }else{
                print("download from network: \(imgUrl)")
                cell.newsImage.downloadImage(from: imgUrl,to: imageStore)
              
            }
           
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("itemStore.allItems.count: \(itemStore.allItems.count)")
        if(itemStore.allItemsCount.count > 0){
            return itemStore.allItemsCount[indexStore.SelectedIndex]
        }
        
        return 0
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexStore.allItems.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IndexBarCollCell", for: indexPath) as! IndexBarCollCell
        cell.IndexName.text = indexStore.allItems[indexPath.row]
        
        if(indexStore.SelectedIndex == indexPath.row){
            cell.IndexName.textColor = UIColor.red
        }else{
            cell.layer.borderWidth = 0
            cell.IndexName.textColor = UIColor.black
        }
        cell.IndexImg.image = UIImage(named:indexStore.allItems[indexPath.row])  //
        
        
        //cell.awakeFromNib()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(indexStore.SelectedIndex != indexPath.row)
        {
            indexStore.SelectedIndex = indexPath.row
            
        }
        collectionView.reloadData()
        
        DispatchQueue.main.async{
            self.tableview.reloadData()
            
            
        }

    }
    
    
    
    // Asks the delegate for the actions to display in response to a swipe in the specified row.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let acRemove = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Favorite"){(action,indexPath)->Void in
            
            let title = "My Favorite"
            let message = "Do you want the news into My favorite?"
            
            //UIAlertController
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            //Cancel Action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            //Delete Action
            let favoriteAction = UIAlertAction(title: "Yes", style: .destructive, handler: {(favorite) -> Void in
                let item = self.itemStore.allItems[self.indexStore.SelectedIndex][indexPath.row]
                self.favoriteStore.append(item)
                
                self.tableview.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
            })
            ac.addAction(favoriteAction)
            self.present(ac, animated: true, completion: nil)
            
        }
        return [acRemove]
    }


    func collectionView(_ collectionView: UICollectionView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    
    
}



