//
//  StringEXT.swift
//  WZQInstantSearch
//
//  Created by wu ziqi on 2017/12/30.
//  Copyright © 2017年 wu ziqi. All rights reserved.
//

import Foundation

extension String {
    subscript(index:Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
}
