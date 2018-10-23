//
//  RealTimeDetectionViewController.swift
//  FirstMyApp
//
//  Created by sangjin park on 2018. 10. 23..
//  Copyright © 2018년 Loguin. All rights reserved.
//

import UIKit

class RealTimeDetectionViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    var videoCapture : VideoCapture!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spec = VideoSpec(fps :3, size : CGSize(width: 1280, height: 720))
        self.videoCapture = VideoCapture(cameraType: .back, preferredSpec: spec, previewContainer: self.cameraView.layer)
        
        self.videoCapture.imageBufferHandler = {(imageBuffer, timestamp, outputBuffer) in
        
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let videoCapture = self.videoCapture {
            videoCapture.startCapture()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let videoCapture = self.videoCapture {
            videoCapture.stopCapture()
        }
    }
}
