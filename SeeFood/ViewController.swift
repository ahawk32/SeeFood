//
//  ViewController.swift
//  SeeFood
//
//  Created by Abrar Hoque on 7/15/20.
//  Copyright © 2020 Abrar Hoque. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    func navBar()->UINavigationBar?{
        let navBar = self.navigationController?.navigationBar
        return navBar
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        
        
    }
    
    
    func setTNavBarTitleAsLabel(title: String, color: UIColor ){

        // removed some code..

        let navigationTitlelabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        navigationTitlelabel.numberOfLines = 1
        navigationTitlelabel.lineBreakMode = .byTruncatingTail

        navigationTitlelabel.adjustsFontSizeToFitWidth = true
        navigationTitlelabel.minimumScaleFactor = 0.1
        navigationTitlelabel.textAlignment = .center
        navigationTitlelabel.textColor  = color
        navigationTitlelabel.text = title

        if let navBar = navBar(){
            //was navBar.topItem?.title = title

            self.navBar()?.topItem?.titleView = navigationTitlelabel
            //navBar.titleTextAttributes = [.foregroundColor : color ?? .black]
        }
    }
    
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CI Image")
            }
            
            detect(image: ciimage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    
    func detect(image: CIImage){
        
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading coreMl model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model Failed to process image")
            }
            
            //print(results)
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog"){
//                    self.navigationItem.title = "My gullocks what a gargantuan GLizzy that is my good sir"
                    self.setTNavBarTitleAsLabel(title: "My gullocks what a gargantuan GLizzy that is my good sir", color: UIColor.white)
                    
                } else {
                    
                    self.setTNavBarTitleAsLabel(title: "Yooo that aint no glizzy, thats a \(firstResult.identifier)", color: UIColor.white)
                    
                    
                    
//                    self.navigationItem.title = "Yooo that aint no glizzy, thats a \(firstResult.identifier)"//"Not hotdog!" //change it to firstResult.identifier
                }
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([request])
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    
    
    


}

