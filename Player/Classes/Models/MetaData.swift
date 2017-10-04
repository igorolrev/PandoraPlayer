//
//  MetaData.swift
//  Player
//
//  Created by Boris Bondarenko on 6/2/17.
//  Copyright © 2017 Applikey Solutions. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class MetaData {
    var title: String? = "Unknown"
    var creationDate = Date()
    var artwork: UIImage? = UIImage(named: "default_cover")
    var albumName: String? = "Unknown"
    var artist: String? = "Unknown"
    var duration: Float64 = 0
    
    init?(withAVPlayerItem item: AVPlayerItem?) {
        
        guard let playerItem = item else { return }
        let commonMetadata = playerItem.asset.commonMetadata
        duration = CMTimeGetSeconds(playerItem.asset.duration)
        
        for metadataItem in commonMetadata {
            switch metadataItem.commonKey! {
            case AVMetadataKey.commonKeyTitle:
                title = metadataItem.stringValue
            case AVMetadataKey.commonKeyCreationDate:
                break
            case AVMetadataKey.commonKeyArtwork:
                if let imageData = metadataItem.value as? Data {
                    artwork = UIImage(data: imageData)
                }
            case AVMetadataKey.commonKeyAlbumName:
                albumName = metadataItem.stringValue
            case AVMetadataKey.commonKeyArtist:
                artist = metadataItem.stringValue
            default: break
            }
        }
        updateNowPlaying()
    }
    
    init?(withMPMediaItem item: MPMediaItem?) {
        guard let playerItem = item else { return }
        title = playerItem.title
        artwork = playerItem.artwork?.image(at: CGSize(width: 100, height: 100))
        albumName = playerItem.albumTitle
        artist = playerItem.artist
        duration = playerItem.playbackDuration
        updateNowPlaying()
    }
    
    fileprivate func updateNowPlaying() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: title ?? "",
            MPMediaItemPropertyAlbumTitle: albumName ?? "",
            MPMediaItemPropertyArtist: albumName ?? "",
            MPMediaItemPropertyPlaybackDuration: duration
        ]
        if let art = artwork {
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: art)
        }
    }
}
