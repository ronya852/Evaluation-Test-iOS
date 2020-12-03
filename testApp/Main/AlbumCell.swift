//
//  AlbumCell.swift
//  testApp
//
//  Created by RonchPonchPomkins on 1/12/2020.
//

import UIKit
import AlamofireImage
import Alamofire

class AlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumArtistLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImage.image = nil
        albumNameLabel.text = nil
        albumArtistLabel.text = nil
    }
    
    func updateCell(album: Album) {
        if let imageUrl = URL(string: album.artworkUrl100 ?? "") {
            albumImage.af.setImage(withURL: imageUrl)
        }
        albumNameLabel.text = album.collectionName
        albumArtistLabel.text = album.artistName
    }    
}
