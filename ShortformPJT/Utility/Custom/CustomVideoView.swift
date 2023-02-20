//
//  CustomVideoView.swift
//  ShortformPJT
//
//  Created by 김태현 on 2023/02/11.
//

import UIKit
import AVFoundation

class CustomVideoView: UIView {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        let layer = layer as! AVPlayerLayer
        layer.videoGravity = .resizeAspectFill
        return layer
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
}
