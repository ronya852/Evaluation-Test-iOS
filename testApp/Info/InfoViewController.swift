//
//  InfoViewController.swift
//  testApp
//
//  Created by RonchPonchPomkins on 1/12/2020.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var album: Album!
    var image: UIImage!
    var tracks = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.title = album.artistName
        self.navigationController?.navigationBar.tintColor = .systemPink
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateLabels ()
        loadTracks()
    }
    
    func updateLabels() {
        albumNameLabel.text = album.collectionName
        artistNameLabel.text = album.artistName
        infoLabel.text = "\(album.primaryGenreName ?? "")⋅\(album.country ?? "")⋅\(album.releaseYear ?? "")"
        albumImage.image = image
    }
    
    func loadTracks() {
        DataService.shared.getAlbumTracks(collectionId: album.collectionId ?? 00) { (requestedTracks) in
            self.tracks = requestedTracks
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - TableView methods

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell {
            cell.updateCell(track: tracks[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
