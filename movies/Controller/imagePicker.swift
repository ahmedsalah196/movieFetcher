//
//  imagePicker.swift
//  movies
//
//  Created by Ahmed Salah on 12/19/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

import UIKit

class imagePicker: popOver, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    
    @IBOutlet weak var preview: UIImageView!

    @IBAction func toOverview(_ sender: Any) {
        let overViewPopUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "overViewId")as! OverviewPopUp
        overViewPopUp.tit = self.tit
        overViewPopUp.dat = self.dat
        let resizedImage = resizeImage(image: preview.image!, targetSize: CGSize(width: 300, height: 300))
        overViewPopUp.img = resizedImage
        overViewPopUp.tablecontroller = self.tablecontroller
        nextPop(popOverVC: overViewPopUp)
    }
    
    @IBAction func pickImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present( image, animated: true)
        {
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info [UIImagePickerControllerOriginalImage] as? UIImage
        {
            preview.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // calculating size wanted for the new image
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // creating rectangle for the resized image
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
