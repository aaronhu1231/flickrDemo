//
//  ResultCollectionViewController.swift
//  flickrDemo
//
//  Created by aaron on 2019/7/22.
//  Copyright © 2019 aaron. All rights reserved.
//

import UIKit
import CoreData
private let reuseIdentifier = "myCell"

class ResultCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout{
    var photos = [photoData]()
    var text = ""
    var perPage = 20
    var pageNumber = 1
    let apiKey = "b9304f4a215eb9c8a1cbffef08eae0e7"
    var inFavoritesID = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "搜尋結果 \(text)"
        
        text = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        getData()
        getFavoriteData()
    }
    
    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ResultCollectionViewCell
        cell.txtResult.text = photos[indexPath.row].title
        cell.imgResult.image = nil
        if inFavoritesID.contains(photos[indexPath.row].id){
                cell.btnFavorite.isEnabled = false
        } else {
            cell.btnFavorite.isEnabled = true
        }
        cell.btnFavorite.addTarget(self, action: #selector(favorite), for: .touchUpInside)
        let task = URLSession.shared.dataTask(with: self.photos[indexPath.row].imageUrl) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.imgResult.image = image
                }
            } 
        }
        task.resume()

        return cell
    }
    
    //MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.photos.count - 1{
            self.pageNumber += 1
            self.getData()
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = (collectionView.bounds.width-10)/2
        let yourHeight = yourWidth
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    // MARK: - Custom Function
    
    func getData() {
        if let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(text)&per_page=\(perPage)&format=json&nojsoncallback=1&page=\(pageNumber)"){
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                let decoder = JSONDecoder()
                if let data = data, let results = try?
                    decoder.decode(ResultData.self, from: data)
                {
                    for photo in results.photos.photo {
                        self.photos.append(photo)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } else {
                    print("error")
                }
            })
            task.resume()
        }
    }
    
    func getFavoriteData(){
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
            let context = appDelegate.persistentContainer.viewContext
            do {
                let favorites = try context.fetch(request)
                for favorite in favorites{
                    inFavoritesID.append(favorite.id ?? "")
                }
            } catch {
                print(error)
            }
        }
    }
    
    @objc func favorite(sender:UIButton){
        sender.isEnabled = false
        
        let point = sender.convert(CGPoint.zero, to: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point){
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                
                let favorite = Favorite(context: appDelegate.persistentContainer.viewContext)
                favorite.id = photos[indexPath.row].id
                favorite.title = photos[indexPath.row].title
                favorite.image = nil
                let task = URLSession.shared.dataTask(with: self.photos[indexPath.row].imageUrl) { (data, response, error) in
                    if let data = data {
                        favorite.image = NSData(data: data)
                        self.inFavoritesID.append(self.photos[indexPath.row].id)
                    } else {
                        print("error")
                    }
                }
                DispatchQueue.main.async {
                    task.resume()
                }
                appDelegate.saveContext()
            }
        }
    }
}
