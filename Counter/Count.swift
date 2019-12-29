//
//  Data.swift
//  Counter
//
//  Created by Pragya Goel on 12/26/19.
//  Copyright © 2019 GenericGenome. All rights reserved.
//

import Foundation
import SwiftUI

struct Count : Hashable, Codable, Identifiable  {
    var id: UUID
    var title : String
    var value : Int
}
