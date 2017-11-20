//
//  IndexBarSel.swift
//  Project0410
//
//  Created by yipei zhu on 4/24/17.
//  Copyright © 2017 Syracuse University. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class IndexBarSelController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var collectionview: UICollectionView!
    
    var indexStore:IndexStore!
    
    var itemStore:NewsDataStore!
    var newsViewController:NewsViewController!
    
    var email:String!
    var favoriteStore:FavoriteStore!
    
    var ifSelectedStore = [Int:Bool]()
    
    
    @IBAction func LoginOutAction(button: UIButton){
        print("Login Out!")
        
        
        let alert = UIAlertController(title: "Log Out", message: "Do you want to log out?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes", style: .destructive, handler: {(action: UIAlertAction)->Void in
            if FIRAuth.auth()!.currentUser != nil{
                do{
                    try? FIRAuth.auth()!.signOut()
                    if FIRAuth.auth()?.currentUser == nil {
                        
                        
                        DataProcessing.SaveToFirebase(self.favoriteStore, self.indexStore, self.email)
                        MyTabBarController.emailName = nil
                        self.performSegue(withIdentifier: "Logout", sender: self)
                        
                    }
                    
                }
            }
        })
        alert.addAction(ok)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancel)
        
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func CategorySelectionAction(button: UIButton){
        print("CategorySelection!")
        var SelectionNum:Int = 0
        for (_, ifSelected) in self.ifSelectedStore{
            if(ifSelected){
                SelectionNum = SelectionNum + 1
            }
        }
        if(SelectionNum == 0){
            let alert = UIAlertController(title: "Category Selection", message: "Please select one category at least.", preferredStyle: .alert)
            let announce = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            alert.addAction(announce)
        
            present(alert, animated: true, completion: nil)
            return
            
        }
        
        let alert = UIAlertController(title: "Category Selection", message: "Do you want to refresh your categories and News?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .destructive, handler: {(action: UIAlertAction)->Void in
            self.refreshCategory()
        })
        alert.addAction(ok)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancel)
        
        
        present(alert, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionview.delegate = self
        collectionview.dataSource = self
        
        for index in 0..<DataProcessing.indexURL.count {
            if(indexStore.allItems.contains(DataProcessing.indexURL[index]!)){
                ifSelectedStore[index] = true
            }else{
                ifSelectedStore[index] = false
            }
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataProcessing.indexURL.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IndexBarSelCell", for: indexPath) as! IndexBarSelCell
        
        if(ifSelectedStore[indexPath.row]!)
        {
            ifSelectedStore[indexPath.row] = false
            //cell.IndexName.textColor = UIColor.black
            
        }else{
            ifSelectedStore[indexPath.row] = true
            //cell.IndexName.textColor = UIColor.red
        }
        
        
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IndexBarSelCell", for: indexPath) as! IndexBarSelCell
        
        cell.IndexName.text = DataProcessing.indexURL[indexPath.row]
        
        if(ifSelectedStore[indexPath.row]!){
            cell.IndexName.textColor = UIColor.red
            
        }else{
            cell.IndexName.textColor = UIColor.black
        }
        cell.IndexImg.image = UIImage(named: DataProcessing.indexURL[indexPath.row]!)  //
        //cell.awakeFromNib()
        return cell
    }
    
    
    func refreshCategory(){
        itemStore.clearAll()
        indexStore.clearAll()
        indexStore.SelectedIndex = 0
        for index in 0..<DataProcessing.indexURL.count {
            
            if(ifSelectedStore[index]!){
                indexStore.allItems.append(DataProcessing.indexURL[index]!)
            }
            
        }
        newsViewController.collectionview.reloadData()
        
        itemStore.setIndexNum(indexStore.allItems.count)
        
        for index in 0..<indexStore.allItems.count {
            
            DataProcessing.loadNewList(indexStore.allItems[index],itemStore,index,newsViewController)
        }

    }
    

}
