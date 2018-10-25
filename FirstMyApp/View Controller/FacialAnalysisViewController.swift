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
    
    @IBOutlet weak var blurredImageView: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!
    var selectedImage: UIImage? {
        didSet{
            self.selectedImageView.image = selectedImage
            self.blurredImageView.image = selectedImage
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let uiImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.selectedImage = uiImage
            self.removeRectangles()
            
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
            for face in faces{
                let w = face.boundingBox.size.width * imageRect.width
                let h = face.boundingBox.size.height * imageRect.height
                let x = face.boundingBox.origin.x * imageRect.width
                let y = imageRect.maxY - (face.boundingBox.origin.y * imageRect.height) - h
                let layer =  CAShapeLayer()
                layer.frame = CGRect(x:x, y:y, width:w, height:h)
                layer.borderColor = UIColor.red.cgColor
                layer.borderWidth = 1
                self.selectedImageView.layer.addSublayer(layer)
            }
        }
    }
    
    func removeRectangles(){
        if let sublayers = self.selectedImageView.layer.sublayers{
            for layer in sublayers{
                layer.removeFromSuperlayer()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
}
