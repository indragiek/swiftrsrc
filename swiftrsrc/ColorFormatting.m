//
//  ColorFormatting.m
//  swiftrsrc
//
//  Created by Indragie on 1/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

#import "ColorFormatting.h"

NSString * UIColorStringForColor(NSColor *color) {
    NSColor *srgbColor = [color colorUsingColorSpace:NSColorSpace.sRGBColorSpace];
    return [NSString stringWithFormat:@"UIColor(red: %.3f, green: %.3f, blue: %.3f, alpha: %.3f)", srgbColor.redComponent, srgbColor.greenComponent, srgbColor.blueComponent, srgbColor.alphaComponent];
}
