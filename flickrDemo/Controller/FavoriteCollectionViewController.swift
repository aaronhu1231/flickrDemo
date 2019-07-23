//
//  FavoriteCollectionViewController.swift
//  flickrDemo
//
//  Created by aaron on 2019/7/23.
//  Copyright © 2019 aaron. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "myCell"

class FavoriteCollectionViewController: UICollectionViewController,NSFetchedResultsControllerDelegate,UICollectionViewDelegateFlowLayout {

    var favorites = [Favorite]()
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的最愛"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(1)
        getFavoriteData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return favorites.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ResultCollectionViewCell
        cell.txtResult.text = favorites[indexPath.row].title
        cell.imgResult.image = nil
        if let data = favorites[indexPath.row].image{
            cell.imgResult.image = UIImage(data: data as Data)
        }
        cell.btnFavorite.addTarget(self, action: #selector(noFavorite), for: .touchUpInside)
        
    
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = (collectionView.bounds.width-10)/2
        let yourHeight = yourWidth
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    // MARK : - Custom Function
    
    @objc func noFavorite(sender:UIButton){
        let point = sender.convert(CGPoint.zero, to: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point){
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                context.delete(favorites[indexPath.row])
                appDelegate.saveContext()
                favorites.remove(at: indexPath.row)
                self.collectionView.reloadData()
            }
        }
    }
    func getFavoriteData(){
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            context = appDelegate.persistentContainer.viewContext
            do {
                favorites = try context.fetch(request)
                    self.collectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}
