//
//  PreviewPlaylistVC - Collection.swift
//  Ditto
//
//  Created by Candace Chiang on 4/11/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

extension PreviewPlaylistViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scrollCell", for: indexPath)
            as! ProfileCell
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        cell.awakeFromNib()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.height/16, height: view.frame.height/16)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let scrollCell = cell as! ProfileCell
        scrollCell.profilePic.image = UIImage(named: "profilepicdefault")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //selected = pokemonArray[indexPath.item]
        //performSegue(withIdentifier: "select", sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}


