//
//  utilities.swift
//  WaterMarkerSwift
//
//  Created by Zahra Sadeghipoor on 1/16/22.
//

import AppKit

// TODO: Maybe a watermark class instead

func process(inputFilePath: String, with waterMarkImages: [NSImage], to outputFilePath: String) {

    if let inImg = NSImage(contentsOfFile: inputFilePath) {
        
        // Choose the watermark image that matches the input image's orientation
        let waterMarkH = waterMarkImages[0]
        let waterMarkV = waterMarkImages[1]
        var waterMark = waterMarkH
        if inImg.size.width < inImg.size.height { // orgImg in portrait orientation
            waterMark = waterMarkV
        }

        // Watermark the image
        waterMarkImg(img: inImg, with: waterMark)
        
        // Resize and dump the watermarked image
        let outputFileURL = URL(fileURLWithPath: outputFilePath)
        if let outImg = inImg.resize(withSize: inImg.size) {
            outImg.jpgWrite(to: outputFileURL)
        }
    }

}

func waterMarkImg(img: NSImage, with waterMark: NSImage) {
    
    img.lockFocus()
    waterMark.draw(in: NSRect(x: 0.0, y: 0.0, width: img.size.width, height:  img.size.height), from: NSZeroRect, operation: NSCompositingOperation.sourceOver, fraction: 1.0)
    img.unlockFocus()

}

extension NSImage {

    // Following code modified from the 1st response in https://stackoverflow.com/questions/39925248/swift-on-macos-how-to-save-nsimage-to-disk
    var jpgData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .jpeg, properties: [:])
    }
    func jpgWrite(to url: URL, options: Data.WritingOptions = .atomic) {
        do {
            try jpgData?.write(to: url, options: options)
        } catch {
            print(error)
        }
    }
    
    // Following code from https://gist.github.com/raphaelhanneken/cb924aa280f4b9dbb480
    // MARK: Resizing
    /// Resize the image to the given size.
    ///
    /// - Parameter size: The size to resize the image to.
    /// - Returns: The resized image.
    func resize(withSize targetSize: NSSize) -> NSImage? {
        let frame = NSRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        guard let representation = self.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }
        let image = NSImage(size: targetSize, flipped: false, drawingHandler: { (_) -> Bool in
            return representation.draw(in: frame)
        })
        return image
    }

}
