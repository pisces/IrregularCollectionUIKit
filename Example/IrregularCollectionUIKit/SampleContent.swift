//
//  SampleContent.swift
//  IrregularCollectionUIKit_Example
//
//  Created by pisces on 9/17/16.
//  Copyright © 2016 pisces. All rights reserved.
//

import Foundation

class SampleContent: NSObject, IrregularSizeObject {
    var commentCount: Int = 0
    var height: Int = 0
    var type: Int = 0
    var width: Int = 0
    var channelID: String?
    var contentID: String?
    var thumb: String?
    var url: String?
    var userID: String?
    var thumbHeaders: NSData?
    var urlHeaders: NSData?
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}
