//
//  DataService.swift
//  testApp
//
//  Created by RonchPonchPomkins on 1/12/2020.
//

import Foundation
import UIKit

let BASE_URL = "https://itunes.apple.com/search?entity=album&attribute=albumTerm&offset=0&limit=100&term="
let ALBUM_SONGS_URL = "https://itunes.apple.com/lookup?entity=song&id="

class DataService {
    
    static let shared = DataService()
    
    func getRequest(path: String?, closure: ((_ data: Data?)->())?) {
        
        guard let path = path, let url = URL(string: path) else {
            closure?(nil)
            return
        }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            closure?(data)
        }.resume()
    }
    
    func getAlbums(_ searchRequest: String, complition: @escaping ([Album])->()) {
        
        var albums = [Album]()
        let searchString = searchRequest.replacingOccurrences(of: " ", with: "+")
        let path = "\(BASE_URL)\(searchString)"
        
        getRequest(path: path) { (data) in
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    if let albumsResults = json["results"] as? NSArray {
                        for album in albumsResults {
                            if let albumInfo = album as? [String: AnyObject] {
                                let albumInstance = Album(data: albumInfo)
                                albums.append(albumInstance)
                            }
                        }
                        complition(albums)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getAlbumTracks(collectionId: Int, complition: @escaping ([Track]) -> ()) {
        
        var tracks = [Track]()
        let path = "\(ALBUM_SONGS_URL)\(collectionId)"
        
        getRequest(path: path) { (data) in
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    if let trackResults = json["results"] as? NSArray {
                        for song in trackResults {
                            if trackResults.index(of: song) != 0 {
                                if let songInfo = song as? [String: AnyObject] {
                                    let track = Track(data: songInfo)
                                    tracks.append(track)
                                }
                            }
                        }
                        complition(tracks)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

