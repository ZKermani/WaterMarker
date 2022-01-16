//
//  main.swift
//  WaterMarkerSwift
//
//  Created by Zahra Sadeghipoor on 1/13/22.
//

import Foundation
import AppKit

// Change the following lines to match your own directories
let rootPath = "/Users/Zahra/WaterMarkerSwift/"
let waterMarkHFile = rootPath + "ExampleLogoHorizontal.png"
let waterMarkVFile = rootPath + "ExampleLogoVertical.png"
let photoPath      = rootPath + "ExamplePhotos/"
let savePath       = rootPath + "WaterMarkedPhotos/"

let imgExtensions = ["JPG", "jpg", "jpeg", "HEIC"]

if let waterMarkH = NSImage(contentsOfFile: waterMarkHFile),
   let waterMarkV = NSImage(contentsOfFile: waterMarkVFile) {
    
    let waterMarkImgs = [waterMarkH, waterMarkV]

    let fileManager = FileManager()
    
    let savePathURL = URL(fileURLWithPath: savePath)
    do {
        try fileManager.createDirectory(at: savePathURL, withIntermediateDirectories: true)
    } catch {
        print(error)
    }
    
    let files = try! fileManager.contentsOfDirectory(atPath: photoPath)
    
    for file in files {
        var isImage = false
        for _extension in imgExtensions { // Check if the current file has a supported image format
            if file.hasSuffix(_extension) {
                isImage = true
                break
            }
        }
        
        if isImage {
            let inputImagePath  = photoPath + file
            let outputImagePath = savePath  + file
            print("Processing \(file)...")
            process(inputFilePath: inputImagePath, with: waterMarkImgs, to: outputImagePath)
        }
    }
    
} else {
    print("Cannot open watermark images")
}
