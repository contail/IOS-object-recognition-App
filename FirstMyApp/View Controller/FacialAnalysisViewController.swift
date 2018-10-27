//
//  FacialAnalysisViewController.swift
//  FirstMyApp
//
//  Created by sangjin park on 2018. 10. 23..
//  Copyright © 2018년 Loguin. All rights reserved.
//

import UIKit
import Vision
import AVFoundation
class FacialAnalysisViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var facesScrollView: UIScrollView!
    @IBOutlet weak var blurredImageView: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var genderLable: UILabel!
    @IBOutlet weak var genderIdentifierLable: UILabel!
    @IBOutlet weak var genderConfidenceLable: UILabel!
    
    @IBOutlet weak var ageLable: UILabel!
    @IBOutlet weak var ageIdentifierLable: UILabel!
    @IBOutlet weak var ageConfidenceLable: UILabel!
    @IBOutlet weak var emotionLable: UILabel!
    @IBOutlet weak var emotionIdentifierLable: UILabel!
    @IBOutlet weak var emotionConfidenceLable: UILabel!
    
    let emotionDic = [
        "Sad" : "슬픔",
        "Happy" : "행복",
        "Neutral" : "보통",
        "Fear" : "두려움",
        "Disgust" : "싫음",
        "Suprise" : "놀람",
        "Angry" : "화남",
    ]
    
    let genderDic = [
        "Male" : "남성",
        "Female" : "여성",
        
    ]
    
    var faceImageViews = [UIImageView]()
    var requests = [VNRequest]()
    var selectedImage: UIImage? {
        didSet{
            self.selectedImageView.image = selectedImage
            self.blurredImageView.image = selectedImage
        }
    }
    
    var selectedFace: UIImage?{
        didSet{
            if let selectedFace = self.selectedFace{
                DispatchQueue.global(qos: .userInitiated).async {
                    self.performFaceAnlaysis(on: selectedFace)
                }
            }
        }
    }
    
    var seletedCiImage: CIImage? {
        get {
            if let selectedImage = self.selectedImage{
                return CIImage(image : selectedImage)
            }
            else{
                return nil
            }
        }
    }
    
    
    @IBAction func addPhto(_ sender: UIBarButtonItem) {
        
        let actionSheet =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let importFromAlbum = UIAlertAction(title: "앨범에서 가져오기", style: .default) { _ in
            let picker = UIImagePickerController()
            picker.sourceType = .savedPhotosAlbum
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        let takePhoto = UIAlertAction(title: "카메라 찍기", style: .default) { _ in
            let picker = UIImagePickerController()
            picker.cameraCaptureMode = .photo
            picker.delegate = self
            picker.sourceType = .camera
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(importFromAlbum)
        actionSheet.addAction(takePhoto)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            let genderModel = try VNCoreMLModel(for: GenderNet().model)
            self.requests.append(VNCoreMLRequest(model: genderModel, completionHandler: handleGenderClassification))
            
            let ageModel = try VNCoreMLModel(for: AgeNet().model)
            self.requests.append(VNCoreMLRequest(model: ageModel, completionHandler: handleAgeClassification))
            
            let emotionModel = try VNCoreMLModel(for: CNNEmotions().model)
            self.requests.append(VNCoreMLRequest(model: emotionModel, completionHandler: handleEmotionClassification))
            
        }catch{
            print(error)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let uiImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.selectedImage = uiImage
            self.removeRectangles()
            self.removeFaceImageViews()
            self.hideAllLables()
            DispatchQueue.global(qos: .userInitiated).async {
                self.detectedFaces()
            }
            
        }
    }
    
    func detectedFaces(){
        if let ciImage = self.seletedCiImage{
            let detectFaceRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaces)
            let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            
            do{
                try requestHandler.perform([detectFaceRequest])
            }catch{
                print(error)
            }
        }
    }
    
    func handleFaces(requset: VNRequest, error: Error?){
        if let faces = requset.results as? [VNFaceObservation]{
            DispatchQueue.main.async {
                self.displayUI(for: faces)
            }
            
        }
    }
    
    func displayUI(for faces : [VNFaceObservation]){
        if let faceImage = self.selectedImage {
            let imageRect = AVMakeRect(aspectRatio: faceImage.size, insideRect: self.selectedImageView.bounds)
            for (index, face) in faces.enumerated(){
                let w = face.boundingBox.size.width * imageRect.width
                let h = face.boundingBox.size.height * imageRect.height
                let x = face.boundingBox.origin.x * imageRect.width
                let y = imageRect.maxY - (face.boundingBox.origin.y * imageRect.height) - h
                let layer =  CAShapeLayer()
                layer.frame = CGRect(x:x, y:y, width:w, height:h)
                layer.borderColor = UIColor.red.cgColor
                layer.borderWidth = 1
                self.selectedImageView.layer.addSublayer(layer)
                
                let w2 = face.boundingBox.size.width * faceImage.size.width
                let h2 = face.boundingBox.size.height * faceImage.size.height
                let x2 = face.boundingBox.origin.x * faceImage.size.width
                let y2 = (1-face.boundingBox.origin.y) *    faceImage.size.height - h2
                
                let cropRect = CGRect(x: x2 * faceImage.scale, y: y2 * faceImage.scale, width: w2 * faceImage.scale, height: h2 * faceImage.scale)
                
                if let faceCIImage = faceImage.cgImage?.cropping(to: cropRect) {
                    let faceUIImage = UIImage(cgImage: faceCIImage, scale: faceImage.scale, orientation: .up)
                    let faceImageView = UIImageView(frame: CGRect(x: 90*index, y: 0, width: 80, height: 80 ))
                    faceImageView.image = faceUIImage
                    faceImageView.isUserInteractionEnabled = true
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(FacialAnalysisViewController.handleFaceImageViewTap(_:)))
                    faceImageView.addGestureRecognizer(tap)
                    
                    self.facesScrollView.addSubview(faceImageView)
                    self.faceImageViews.append(faceImageView)
                }
            }
            
            self.facesScrollView.contentSize = CGSize(width: 90*faces.count-10, height: 80)
        }
    }
    
    func removeRectangles(){
        if let sublayers = self.selectedImageView.layer.sublayers{
            for layer in sublayers{
                layer.removeFromSuperlayer()
            }
        }
    }
    
    func removeFaceImageViews(){
        for faceImageView in self.faceImageViews {
            faceImageView.removeFromSuperview()
        }
        self.faceImageViews.removeAll()
    }
    
    
    
    @objc func handleFaceImageViewTap(_ sender: UITapGestureRecognizer){
        if let tappedImageView = sender.view as? UIImageView {
            
            for faceImageView in self.faceImageViews {
                faceImageView.layer.borderWidth = 0
                faceImageView.layer.borderColor = UIColor.clear.cgColor
                
            }
            tappedImageView.layer.borderWidth = 3
            tappedImageView.layer.borderColor = UIColor.blue.cgColor
            self.selectedFace = tappedImageView.image
        }
    }
    
    func performFaceAnlaysis(on image: UIImage){
        do{
            for request in self.requests {
                let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
                try handler.perform([request])
            }
        }catch{
            print(error)
        }
    }
    
    func handleGenderClassification(request: VNRequest, error: Error?){
        if let genderObservation = request.results?.first as? VNClassificationObservation {
            DispatchQueue.main.async {
                self.showGenderLable(identifier: self.genderDic[genderObservation.identifier]!, confidence: genderObservation.confidence)
            }
            print("gender: \(genderObservation.identifier), confidence : \(genderObservation.confidence)")
        }
    }
    func handleAgeClassification(request: VNRequest, error: Error?){
        if let ageObservation = request.results?.first as? VNClassificationObservation {
            DispatchQueue.main.async {
                
                self.showAgeLable(identifier: ageObservation.identifier, confidence: ageObservation.confidence)
            }
            print("age: \(ageObservation.identifier), confidence : \(ageObservation.confidence)")
        }
    }
    func handleEmotionClassification(request: VNRequest, error: Error?){
        
        if let results = request.results as? [VNClassificationObservation]{
            for result in results{
                print("Emotion : \(result.identifier), conf : \(result.confidence)")
            }
        }
        if let emotionObservation = request.results?.first as? VNClassificationObservation {
            DispatchQueue.main.async {
                self.showEmotionLable(identifier: emotionObservation.identifier, confidence: emotionObservation.confidence)
            }
            print("emotion: \(emotionObservation.identifier), confidence : \(emotionObservation.confidence)")
        }
    }
    
    func hideGenderLable(){
        self.genderLable.isHidden = true
        self.genderIdentifierLable.isHidden = true
        self.genderConfidenceLable.isHidden = true
    }
    
    func showGenderLable(identifier: String, confidence: Float){
        self.genderIdentifierLable.text = identifier
        self.genderConfidenceLable.text = "\(String(format: "%.1f", confidence * 100)) %"
        self.genderLable.isHidden = false
        self.genderIdentifierLable.isHidden = false
        self.genderConfidenceLable.isHidden = false
    }
    
    func hideAgeLable(){
        self.ageLable.isHidden = true
        self.ageIdentifierLable.isHidden = true
        self.ageConfidenceLable.isHidden = true
    }
    
    func showAgeLable(identifier: String, confidence: Float){
        self.ageIdentifierLable.text = identifier
        self.ageConfidenceLable.text = "\(String(format: "%.1f", confidence * 100)) %"
        self.ageLable.isHidden = false
        self.ageIdentifierLable.isHidden = false
        self.ageConfidenceLable.isHidden = false
    }
    
    func hideEmotionLable(){
        self.emotionLable.isHidden = true
        self.emotionIdentifierLable.isHidden = true
        self.emotionConfidenceLable.isHidden = true
    }
    
    func showEmotionLable(identifier: String, confidence: Float){
        self.emotionIdentifierLable.text = emotionDic[identifier]
        self.emotionConfidenceLable.text = "\(String(format: "%.1f", confidence * 100)) %"
        self.emotionLable.isHidden = false
        self.emotionIdentifierLable.isHidden = false
        self.emotionConfidenceLable.isHidden = false
    }
    
    func hideAllLables(){
        self.hideAgeLable()
        self.hideGenderLable()
        self.hideEmotionLable()
    }
    
//    func showAllLables(){
//        self.showAgeLable()
//        self.showGenderLable()
//        self.showEmotionLable()
//    }
    
    
    
}
