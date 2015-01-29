//
//  ColorFormatting.h
//  swiftrsrc
//
//  Created by Indragie on 1/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// Have to use Objective-C for formatting strings with floating point numbers
// because Swift fails at it. Calling -[NSString stringWithFormat:] from Swift
// results in all of the floats being formatted as 0.

NSString * UIColorStringForColor(NSColor *color);
