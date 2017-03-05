//
//  ExtensionString.swift
//  Your Alarm
//
//  Created by Thai Duong on 3/5/17.
//  Copyright © 2017 Thai Duong. All rights reserved.
//

import Foundation
extension String {
    static func convertToTimer(time : Int) -> String {
        if time < 10 {
            return "0" + String(time)
        }
        return String(time)
    }
}
