//
//  DatabaseRepresentation.swift
//  KeepChild
//
//  Created by Clément Martin on 10/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation

protocol DatabaseRepresentation {
    var representation: [String: Any] { get }
}
