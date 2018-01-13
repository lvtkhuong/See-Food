//
//  ViewController.swift
//  See Food
//
//  Created by Le Ngoc Lan Khue on 1/11/18.
//  Copyright © 2018 lvtkhuong. All rights reserved.
//

import UIKit
import VisualRecognitionV3

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let apiKey = ""
    let version = "2018-01-13"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    let imagePicker = UIImagePickerController()
    var classificationResults : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
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
                if self.classificationResults.contains("hotdog"){
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Hotdog !"
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Not Hotdog !"
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
    


}

