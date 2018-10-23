//
//  ObjectDetectionViewController.swift
//  FirstMyApp
//
//  Created by sangjin park on 2018. 9. 4..
//  Copyright © 2018년 Loguin. All rights reserved.
//

import UIKit
import Vision
class ObjectDetectionViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryLable.text=""
        self.confidenceLable.text=""
        self.activityIndicatorView.hidesWhenStopped = true;
        self.activityIndicatorView.stopAnimating()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var categoryLable: UILabel!
    @IBOutlet weak var confidenceLable: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    //옵저버 역할하기.
    var selectedImage: UIImage?{
        
        //값이 변화하면 이미지뷰를 여기다가 넣어주기 (옵저버)
        didSet{
            self.selectedImageView.image = selectedImage
        }
    }
    
    var selectedciImage: CIImage?{
        
        get{
            if let selectedImage = self.selectedImage{
                return CIImage(image: selectedImage)
            }
            else{
                return nil
            }
            
        }
        
        set{
            
        }
        
    }
    @IBAction func addPhoto(_ sender: UIBarButtonItem) {
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
        picker.dismiss(animated: true)
        if let uiImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            //self.selectedImageView.image = uiImage
            self.selectedImage = uiImage
            self.categoryLable.text = ""
            self.confidenceLable.text = ""
            self.activityIndicatorView.startAnimating()
            //async로 비동기화 시켜주기 => ML과정중에 perform 실행시간이 길 수가 있어서 비동기화로..
            DispatchQueue.global(qos: .userInitiated).async {
                self.detectObject()
            }
        }
    }
    
    func detectObject(){
        
        if let ciImage = self.selectedciImage {
            do{
                let vnCoreMLModel = try VNCoreMLModel(for: Inceptionv3().model)
                let request = VNCoreMLRequest(model: vnCoreMLModel, completionHandler: handleObjectDection)
                request.imageCropAndScaleOption = .centerCrop
                let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
                try requestHandler.perform([request])
            }
            catch{
                print(error)
            }
            
        }
    }
    
    func handleObjectDection(request: VNRequest, error:Error?){
        
        if let result = request.results?.first as? VNClassificationObservation {
            //UI를 바꾸는 작업은 main thread에서 실행하기
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.categoryLable.text = result.identifier
                self.confidenceLable.text = "\(String(format: "%.1f", result.confidence * 100)) %"
            }
        }
    }
   

}
