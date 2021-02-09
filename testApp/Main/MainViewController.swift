//
//  MainViewController.swift
//  testApp
//
//  Created by RonchPonchPomkins on 1/12/2020.
//

import UIKit
import Foundation

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var startSearchLabel: UILabel!
    @IBOutlet weak var startSearchButton: UIButton!
    @IBOutlet weak var searchBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var startSearchLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var startSearchButtonConstraint: NSLayoutConstraint!
    
    var albums = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    @IBAction func startSearchButton(_ sender: Any) {
        startSearchLabel.isHidden = true
        startSearchButton.isHidden = true
        animationSearchBar()
    }
}

// MARK: - CollectionView methods

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as? AlbumCell {
            cell.updateCell(album: albums[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albums[indexPath.row]
        if let viewController = UIStoryboard(name: "Info", bundle: nil).instantiateViewController(withIdentifier: "InfoViewController") as? InfoViewController {
            if let navigator = navigationController {
                viewController.album = album
                if let cell = collectionView.cellForItem(at: indexPath) as? AlbumCell {
                    viewController.image = cell.albumImage.image
                }
                navigator.pushViewController(viewController, animated: true)
            }
        }
        searchBar.resignFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 12, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 8, right: 12)
    }
}

// MARK: - SearchBar methods

extension MainViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request = searchBar.text
        if englishAlphabet() {
            if request == nil || request == "" {
                albums.removeAll()
                self.collectionView.reloadData()
                self.getAlbumsActionStop()
                errorAlert(message: "Enter the search request")
            } else {
                self.getAlbumsAction()
                DataService.shared.getAlbums(request!) { (requestedAlbums) in
                    self.albums = requestedAlbums.sorted(by: {$0.collectionName ?? "" < $1.collectionName ?? ""})
                    DispatchQueue.main.async {
                        let resultCount = requestedAlbums.count
                        if resultCount == 0 {
                            self.errorAlert(message: "Not found")
                        }
                        self.getAlbumsActionStop()
                        self.collectionView.reloadData()
                    }
                }
                searchBar.resignFirstResponder()
            }
        } else {
            errorAlert(message: "English only")
        }
    }
    
    func errorAlert(message: String) {
        let archiveMenu = UIAlertController(title: nil, message: "\(message)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        archiveMenu.addAction(cancelAction)
        
        self.present(archiveMenu, animated: true, completion: nil)
    }
}

// MARK: - Configure

private extension MainViewController {
    
    func getAlbumsAction() {
        albums.removeAll()
        collectionView.reloadData()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func getAlbumsActionStop() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func animationSearchBar() {
        searchBarConstraint.constant = -1
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }
        )}
    
    func englishAlphabet() -> Bool {
        var ok = false
        let alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let name = searchBar.text!
        for i in alphabet {
            if name.hasSuffix(String(i)) {
                ok = true
            }
        }
        return ok
    }
}
