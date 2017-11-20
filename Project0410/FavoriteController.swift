//
//  FavoriteController.swift
//  Project0410
//
//  Created by yipei zhu on 4/27/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import UIKit



class FavoriteController:UITableViewController{
    
    var favoriteStore: FavoriteStore!
    

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
    
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //self.performSegue(withIdentifier: "NewsDetail", sender: self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favoriteStore.allItems.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        
        
        cell.NewsTitle.text = self.favoriteStore.allItems[indexPath.row].title
        
        return cell
    }

    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let acRemove = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete"){(action,indexPath)->Void in
            
            let title = "Delete"
            let message = "Do you want to delete the news into My favorite?"
            
            //UIAlertController
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            //Cancel Action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            //Delete Action
            let favoriteAction = UIAlertAction(title: "Yes", style: .destructive, handler: {(favorite) -> Void in
                
                self.favoriteStore.remove(indexPath.row)
                self.tableView.reloadData()
                
                
            })
            ac.addAction(favoriteAction)
            self.present(ac, animated: true, completion: nil)
            
        }
        return [acRemove]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Segue invoked.")
        
        if segue.identifier == "WebView2" {
            print("go to webpage")
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = favoriteStore.allItems[row]
                
                let destinationController = segue.destination as! NewsWebController2
                destinationController.url = item.url
            }
            
            
        }
    }

    
}
