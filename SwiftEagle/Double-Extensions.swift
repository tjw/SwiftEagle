//
//  Double-Extensions.swift
//  PCBModel
//
//  Created by Timothy J. Wood on 12/5/14.
//  Copyright (c) 2014 Cocoatoa. All rights reserved.
//

import Foundation

extension Double {
    func snapUp(by by:Double) -> Double {
        if (self < 0) {
            return -((-self).snapDown(by:by))
        }
        
        let remainder = fmod(self, by)
        if (remainder == 0) {
            // 10.snapUp(by:10) should be 10
            return self
        }
        return self + (by - remainder)
    }
    func snapDown(by by:Double) -> Double {
        if (self < 0) {
            return -((-self).snapUp(by:by))
        }
        let remainder = fmod(self, by)
        return self - remainder
    }
}
