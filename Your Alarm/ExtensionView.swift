//
//  ExtensionView.swift
//  Your Alarm
//
//  Created by ThaiDuong on 3/6/17.
//  Copyright © 2017 Thai Duong. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    func makeViewCircle() {
        self.layer.cornerRadius = self.frame.size.width / 2 
        self.clipsToBounds = true
    }
}
