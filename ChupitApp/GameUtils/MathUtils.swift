//
//  MathUtils.swift
//  ChupitApp
//
//  Created by Alessandro Minopoli on 16/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import Foundation
import CoreGraphics

let DegreesPerRadians = Float(Double.pi/180)
let RadiansPerDegrees = Float(180/Double.pi)

func convertToRadians(angle:Float) -> Float {
    return angle * DegreesPerRadians
}

func convertToRadians(angle:CGFloat) -> CGFloat {
    return CGFloat(CGFloat(angle) * CGFloat(DegreesPerRadians))
}

func convertToDegrees(angle:Float) -> Float {
    return angle * RadiansPerDegrees
}

func convertToDegrees(angle:CGFloat) -> CGFloat {
    return CGFloat(CGFloat(angle) * CGFloat(RadiansPerDegrees))
}

public extension Float {
    public static func random(min: Float, max: Float) -> Float {
        let r32 = Float(arc4random(UInt32.self)) / Float(UInt32.max)
        return (r32 * (max - min)) + min
    }
}

public func arc4random <T: ExpressibleByIntegerLiteral> (_ type: T.Type) -> T {
    var r: T = 0
    arc4random_buf(&r, Int(MemoryLayout<T>.size))
    return r
}

