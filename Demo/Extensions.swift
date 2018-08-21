//
//  Extensions.swift
//  Demo
//
//  Created by Globallogic on 22/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String{
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: "", comment: "")
    }
}
