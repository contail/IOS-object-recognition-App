//
//  RealTimeDetectionViewController.swift
//  FirstMyApp
//
//  Created by sangjin park on 2018. 10. 23..
//  Copyright © 2018년 Loguin. All rights reserved.
//

import UIKit
import Vision
class RealTimeDetectionViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var categoryView: UILabel!
    @IBOutlet weak var confidenceView: UILabel!
    var videoCapture : VideoCapture!
    let visonRequestHanlder = VNSequenceRequestHandler()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryView.text = ""
        self.confidenceView.text = ""
        
        let spec = VideoSpec(fps :3, size : CGSize(width: 1280, height: 720))
        self.videoCapture = VideoCapture(cameraType: .back, preferredSpec: spec, previewContainer: self.cameraView.layer)
        
        self.videoCapture.imageBufferHandler = {(imageBuffer, timestamp, outputBuffer) in
        self.detectObject(image: imageBuffer)
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
    
    func detectObject(image: CVImageBuffer){
        
            do{
                let vnCoreMLModel = try VNCoreMLModel(for: Inceptionv3().model)
                let request = VNCoreMLRequest(model: vnCoreMLModel, completionHandler: handleObjectDection)
                request.imageCropAndScaleOption = .centerCrop
                try self.visonRequestHanlder.perform([request], on: image)
            }
            catch{
                print(error)
            }
            
        
    }
    
    func handleObjectDection(request: VNRequest, error: Error?) {
        if let result = request.results?.first as? VNClassificationObservation {
            print("\(result.identifier) :  \(result.confidence)")
        }
    }
}
