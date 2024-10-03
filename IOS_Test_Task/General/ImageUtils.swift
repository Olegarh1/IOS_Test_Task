//
//  ImageUtils.swift
//  IOS_Test_Task
//
//  Created by Oleg Zakladnyi on 03.10.2024.
//

import UIKit

class ImageUtils {
    
    class func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        let newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UIImage {
    
    class func textEmbededImage(image: UIImage, string: String, color: UIColor, imageAlignment: Int = 0, segFont: UIFont? = nil) -> UIImage {
        let font = segFont ?? UIFont(name: "Inter-SemiBold", size: 13.0) ?? UIFont.systemFont(ofSize: 16.0)
        let expectedTextSize: CGSize = (string as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
        let width: CGFloat = expectedTextSize.width + image.size.width + 5.0
        let height: CGFloat = max(expectedTextSize.height, image.size.height)
        let size: CGSize = CGSize(width: width, height: height)

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)

        let fontTopPosition: CGFloat = (height - expectedTextSize.height) / 2.0
        let textOrigin: CGFloat = (imageAlignment == 0) ? image.size.width + 5 : 0
        let textPoint: CGPoint = CGPoint(x: textOrigin, y: fontTopPosition)
        
        
        string.draw(at: textPoint, withAttributes: [NSAttributedString.Key.font: font])
        
        let flipVertical: CGAffineTransform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height)
        context.concatenate(flipVertical)
        let alignment: CGFloat = (imageAlignment == 0) ? 0.0 : expectedTextSize.width + 5.0
        context.draw(image.cgImage!, in: CGRect(x: alignment, y: ((height - image.size.height) / 2.0), width: image.size.width, height: image.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
