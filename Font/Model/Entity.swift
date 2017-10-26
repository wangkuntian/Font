//
//  Entity.swift
//  Font
//
//  Created by 王坤田 on 2017/10/25.
//  Copyright © 2017年 王坤田. All rights reserved.
//

import Foundation

struct Font {
    
    var fontName : String = ""
    var isFavorite : Bool = false
    
    init() {
        
    }
    
    init(fontName : String) {
        
        self.fontName = fontName
        
    }
    
    init(fontName : String, isFavorite : Bool) {
        
        self.fontName = fontName
        self.isFavorite = isFavorite
        
    }
}

