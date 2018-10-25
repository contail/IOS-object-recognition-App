//
//  FacialAnalysisViewController.swift
//  FirstMyApp
//
//  Created by sangjin park on 2018. 10. 23..
//  Copyright © 2018년 Loguin. All rights reserved.
//

import UIKit

class FacialAnalysisViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var blurredImageView: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!
    var selectedImage: UIImage? {
        didSet{
            self.selectedImageView.image = selectedImage
            self.blurredImageView.image = selectedImage
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
