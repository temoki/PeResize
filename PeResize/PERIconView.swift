//
//  PERIconView.swift
//  PeResize
//
//  Created by temoki on 2015/02/15.
//  Copyright (c) 2015 temoki. All rights reserved.
//

import UIKit

class PERIconView: UIView {
    
    private let CORNER_RATIO: CGFloat = 416.0 / 1920.0
    private let CIRCLE_RATIO: CGFloat = 1.0 / 1.618 // Golden ratio
    private let PARAM_X: CGFloat = 0.71
    private let PARAM_Y: CGFloat = 0.39
    private let DRAW_TEMPLATE: Bool = false;
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override init() {
        // icon@2x
        super.init(frame: CGRectMake(0, 0, 114, 114))
        setup()
    }
    
    func setup() {
        var square = self.frame
        square.size.width = min(frame.size.width, frame.size.height)
        square.size.height = square.size.width
        self.frame = square
        self.backgroundColor = UIColor.whiteColor()
        self.clipsToBounds = true;
        self.layer.cornerRadius = square.size.width * CORNER_RATIO;
    }
    
    override func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        drawIcon(context, rect:rect)
        if DRAW_TEMPLATE {
            drawTemplate(context, rect:rect)
        }
        CGContextRestoreGState(context)
    }
    
    func drawIcon(context: CGContextRef, rect: CGRect) {
        // background
        UIColor.whiteColor().setFill()
        CGContextFillRect(context, rect)

        // color
        let H: CGFloat = 255.0
        let R: [CGFloat] = [240/H, 250/H, 242/H, 179/H, 111/H, 119/H, 165/H, 217/H]
        let G: [CGFloat] = [111/H, 172/H, 226/H, 212/H, 192/H, 178/H, 144/H, 128/H]
        let B: [CGFloat] = [105/H,  65/H,  64/H,  98/H, 164/H, 223/H, 194/H, 161/H]
        
        // initial position
        let heightRatio: CGFloat = 2.0 / 3.0
        let length = min(rect.size.width, rect.size.height)
        var radius = (length * CORNER_RATIO) * PARAM_X
        var drawRect = rect
        drawRect.origin.x += length * ((1.0 - PARAM_X) * 0.5)
        drawRect.origin.y += length * ((1.0 - PARAM_X) * 0.5)
        drawRect.size.width = length * PARAM_X
        drawRect.size.height = drawRect.size.width * heightRatio
    
        // loop
        var margin = drawRect.origin.y - rect.origin.y
        NSLog("top margin    = \(margin)")
        for (var i = 0; i < 8; i++) {
            CGContextSetRGBFillColor(context, R[i], G[i], B[i], 0.8)
            margin = CGRectGetMaxY(rect) - CGRectGetMaxY(drawRect)
            drawRoundedRect(context, rect: drawRect, radius: radius, mode: kCGPathFill)
            drawRect.origin.x += radius * CIRCLE_RATIO
            drawRect.origin.y += drawRect.size.height * PARAM_Y
            drawRect.size.width -= radius * CIRCLE_RATIO * 2.0
            drawRect.size.height = drawRect.size.width * heightRatio
            radius *= PARAM_X
        }
        NSLog("bottom margin = \(margin)")
    }
    
    func drawTemplate(context: CGContextRef, rect:CGRect) {
        let minX = CGRectGetMinX(rect);
        let midX = CGRectGetMidX(rect);
        let maxX = CGRectGetMaxX(rect);
        let minY = CGRectGetMinY(rect);
        let midY = CGRectGetMidY(rect);
        let maxY = CGRectGetMaxY(rect);

        CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0)
        CGContextSetLineWidth(context, 0.5)

        let length = min(rect.size.width, rect.size.height)
        let cornerRadius = length * CORNER_RATIO
        let cornerPos: CGFloat = cornerRadius  * (1.0 - CGFloat(sin(Double(M_PI_4))))
        
        // Circles
        var diameter: CGFloat, radius: CGFloat, circle: CGRect
        diameter = rect.size.width - cornerPos * 2.0
        radius = diameter * 0.5
        circle = CGRectMake(minX + cornerPos, minY + cornerPos, diameter, diameter)
        CGContextStrokeEllipseInRect(context, circle)
        diameter = diameter * CIRCLE_RATIO
        radius = radius * CIRCLE_RATIO
        circle = CGRectMake(midX - radius, midY - radius, diameter, diameter)
        CGContextStrokeEllipseInRect(context, circle)
        radius = radius * CGFloat(sin(Double(M_PI_4)))
        diameter = radius * 2.0
        circle = CGRectMake(midX - radius, midY - radius, diameter, diameter)
        CGContextStrokeEllipseInRect(context, circle)

        // Lines
        CGContextMoveToPoint(   context, minX + cornerPos, minY)
        CGContextAddLineToPoint(context, minX + cornerPos, maxY)
        CGContextMoveToPoint(   context, minX, maxY - cornerPos)
        CGContextAddLineToPoint(context, maxX, maxY - cornerPos)
        CGContextMoveToPoint(   context, maxX - cornerPos, minY)
        CGContextAddLineToPoint(context, maxX - cornerPos, maxY)
        CGContextMoveToPoint(   context, minX, minY + cornerPos)
        CGContextAddLineToPoint(context, maxX, minY + cornerPos)
        CGContextMoveToPoint(   context, midX, minY)
        CGContextAddLineToPoint(context, midX, maxY)
        CGContextMoveToPoint(   context, minX, midY)
        CGContextAddLineToPoint(context, maxX, midY)
        CGContextMoveToPoint(   context, minX, minY)
        CGContextAddLineToPoint(context, maxX, maxY)
        CGContextMoveToPoint(   context, maxX, minY)
        CGContextAddLineToPoint(context, minX, maxY)
        CGContextMoveToPoint(   context, minX, midY - radius)
        CGContextAddLineToPoint(context, maxX, midY - radius)
        CGContextMoveToPoint(   context, minX, midY + radius)
        CGContextAddLineToPoint(context, maxX, midY + radius)
        CGContextMoveToPoint(   context, midX - radius, minY)
        CGContextAddLineToPoint(context, midX - radius, maxY)
        CGContextMoveToPoint(   context, midX + radius, minY)
        CGContextAddLineToPoint(context, midX + radius, maxY)
        CGContextStrokePath(context)
    }

    func drawRoundedRect(context: CGContextRef, rect: CGRect, radius: CGFloat, mode: CGPathDrawingMode) {
        let minX = CGRectGetMinX(rect);
        let midX = CGRectGetMidX(rect);
        let maxX = CGRectGetMaxX(rect);
        let minY = CGRectGetMinY(rect);
        let midY = CGRectGetMidY(rect);
        let maxY = CGRectGetMaxY(rect);
        CGContextMoveToPoint(context, minX, midY);
        CGContextAddArcToPoint(context, minX, minY, midX, minY, radius);
        CGContextAddArcToPoint(context, maxX, minY, maxX, midY, radius);
        CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, radius);
        CGContextAddArcToPoint(context, minX, maxY, minX, midY, radius);
        CGContextClosePath(context);
        CGContextDrawPath(context, mode);
    }

    func makeIconFiles() {
        self.makeIconFile(CGSizeMake(58, 58), name: "icon-29@2x.png")
        self.makeIconFile(CGSizeMake(87, 87), name: "icon-29@3x.png")
        self.makeIconFile(CGSizeMake(80, 80), name: "icon-40@2x.png")
        self.makeIconFile(CGSizeMake(120, 120), name: "icon-40@3x.png")
        self.makeIconFile(CGSizeMake(120, 120), name: "icon-60@2x.png")
        self.makeIconFile(CGSizeMake(180, 180), name: "icon-60@3x.png")
        self.makeIconFile(CGSizeMake(320, 320), name: "icon-forDefault@2x.png")
        self.makeIconFile(CGSizeMake(480, 480), name: "icon-forDefault@3x.png")
        self.makeIconFile(CGSizeMake(1024, 1024), name: "iTunesArtwork.png")
    }
    
    func makeIconFile(size: CGSize, name: String) {
        // Create image
        UIGraphicsBeginImageContext(size);
        var context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context)
        self.drawIcon(context, rect: CGRectMake(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        CGContextRestoreGState(context)
        UIGraphicsEndImageContext()

        // Create sub directory
        let fileManager = NSFileManager.defaultManager()
        let docDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let subDir = docDir.stringByAppendingPathComponent("Icons") as String
        if !fileManager.fileExistsAtPath(subDir) {
            var error: NSError?
            if !fileManager.createDirectoryAtPath(subDir, withIntermediateDirectories: true, attributes: nil, error: &error) {
                println("Unable to create directory: \(error)")
            }
        }

        // Write png file
        var filePath = subDir.stringByAppendingPathComponent(name)
        NSLog("file path = \(filePath)")
        let data = UIImagePNGRepresentation(image)
        let result = data.writeToFile(filePath, atomically: true)
        NSLog("result = \(result)")
    }
    
}