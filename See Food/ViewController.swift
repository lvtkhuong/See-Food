//
//  ViewController.swift
//  See Food
//
//  Created by Le Ngoc Lan Khue on 1/11/18.
//  Copyright © 2018 lvtkhuong. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import SVProgressHUD
import Social

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let apiKey = "fbcd915e6875571676ce33843a6acc6f59db0e28"
    let version = "2018-01-13"

    @IBOutlet weak var topBarImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    let imagePicker = UIImagePickerController()
    var classificationResults : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isHidden = true
        imagePicker.delegate = self
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        SVProgressHUD.show()
        navigationItem.title = ""
        topBarImageView.isHidden = true
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            cameraButton.isEnabled = false
            let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
            let imageData = UIImageJPEGRepresentation(image, 0.01)
            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentURL.appendingPathComponent("tempImage.jpg")
            try? imageData?.write(to: fileURL, options: [])
            visualRecognition.classify(imageFile: fileURL, success: { (classifiedImages) in
                let classes = classifiedImages.images.first!.classifiers.first!.classes
                self.classificationResults = []
                for index in 0..<classes.count {
                    self.classificationResults.append(classes[index].classification)
                }
                DispatchQueue.main.async {
                    self.cameraButton.isEnabled = true
                    SVProgressHUD.dismiss()
                    self.shareButton.isHidden = false
                }
                if self.classificationResults.contains("hotdog"){
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Hotdog !"
                        self.navigationController?.navigationBar.barTintColor = UIColor.green
                        self.navigationController?.navigationBar.isTranslucent = false
                        self.topBarImageView.isHidden = false
                        self.topBarImageView.image = UIImage(named: "hotdog")
                        
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Not Hotdog !"
                        self.navigationController?.navigationBar.barTintColor = UIColor.red
                        self.navigationController?.navigationBar.isTranslucent = false
                        self.topBarImageView.isHidden = false
                        self.topBarImageView.image = UIImage(named: "not-hotdog")
                    }
                    
                }
                
            })
        } else {
            print("There was an error while taking image from camera")
        }
        
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
            vc.setInitialText("My food is \(navigationItem.title)")
            vc.add(#imageLiteral(resourceName: "hotdogBackground"))
            present(vc, animated: true, completion: nil)
        } else {
            self.navigationItem.title = "Please log in to Twitter"
        }
        
            
    }
    

}

