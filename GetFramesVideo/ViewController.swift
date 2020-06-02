//
//  ViewController.swift
//  GetFramesVideo
//
//  Created by NDPhu on 8/18/19.
//  Copyright © 2019 iosDVL. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frames.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.frameImg.image = frames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let path = Bundle.main.path(forResource: "jumani", ofType: "mp4") else {
            return
        }
        self.videoUrl = URL(fileURLWithPath: path)
        getAllFrames()
        
    }

    var videoUrl:URL? // use your own url
    var frames:[UIImage] = []
    private var generator:AVAssetImageGenerator!
    
    func getAllFrames() {
        let asset:AVAsset = AVAsset(url:self.videoUrl!)
        let duration:Float64 = CMTimeGetSeconds(asset.duration)
        self.generator = AVAssetImageGenerator(asset:asset)
        self.generator.appliesPreferredTrackTransform = true
        self.frames = []
        for index:Int in 0 ..< Int(duration) {
            self.getFrame(fromTime:Float64(index))
        }
        self.generator = nil
    }
    
    private func getFrame(fromTime:Float64) {
        let time:CMTime = CMTimeMakeWithSeconds(fromTime, preferredTimescale:5000)
        let image:CGImage
        do {
            try image = self.generator.copyCGImage(at:time, actualTime:nil)
        } catch {
            return
        }
        self.frames.append(UIImage(cgImage:image))
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

