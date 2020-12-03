//
//  TrackCell.swift
//  testApp
//
//  Created by RonchPonchPomkins on 1/12/2020.
//

import UIKit

class TrackCell: UITableViewCell {
    
    @IBOutlet weak var trackNumber: UILabel!
    @IBOutlet weak var trackName: UILabel!
    
    func updateCell(track: Track) {
        trackNumber.text = String(track.trackNumber ?? 00)
        trackName.text = track.trackName
    }
}
