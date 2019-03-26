//
//  BiometricTest.swift
//  Flash Chat
//
//  Created by Marcos Lee on 3/26/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation
import LocalAuthentication

var biometricType: LABiometryType {
    let authContext = LAContext()
    return authContext.biometryType
}
