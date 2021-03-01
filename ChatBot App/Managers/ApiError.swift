//
//  ApiError.swift
//  ChatBot App
//
//  Created by RajeshKumar on 28/02/21.
//

import Foundation
import UIKit

class ApiError: NSObject {
    var code:Int
    var message:String
    
    init(code:Int, message:String) {
        self.code = code
        self.message = message
        super.init()
    }
}
