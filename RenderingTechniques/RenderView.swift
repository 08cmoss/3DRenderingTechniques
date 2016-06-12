//
//  RenderView.swift
//  RenderingTechniques
//
//  Created by Drew Ingebretsen on 6/11/16.
//  Copyright © 2016 Drew Ingebretsen. All rights reserved.
//

import UIKit


struct Color8 {
    let a:UInt8;
    let r:UInt8;
    let g:UInt8;
    let b:UInt8;
}

class RenderView: UIView {
    
    var width:Int {
        return Int(bounds.size.width)
    }
    
    var height:Int {
        return Int(bounds.size.height)
    }
    
    
    var pixelBuffer:[Color8] = [Color8]()
    
    func clear(){
        pixelBuffer = Array<Color8>(count: width * height, repeatedValue: Color8(a: 255, r: 0, g: 0, b: 0))
    }
    
    func plot(x:Int, y:Int, color:Color8){
        if (x < 0 || y < 0 || x >= width || y >= height){
            return;
        }
        pixelBuffer[y * width + x] = color;
    }
    
    func render(){
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        let bitsPerComponent = 8
        let bitsPerPixel = 32
        
        var data = pixelBuffer // Copy to mutable []
        let providerRef = CGDataProviderCreateWithCFData(
            NSData(bytes: &data, length: data.count * sizeof(Color8))
        )
        
        layer.contents = CGImageCreate(
            width,
            height,
            bitsPerComponent,
            bitsPerPixel,
            width * Int(sizeof(Color8)),
            rgbColorSpace,
            bitmapInfo,
            providerRef,
            nil,
            true,
            .RenderingIntentDefault
        )
    }

}