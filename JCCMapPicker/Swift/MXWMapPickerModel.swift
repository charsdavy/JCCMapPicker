//
//  MXWLocationModel.swift
//  UrawaSwift
//
//  Created by CHARS on 2019/4/1.
//  Copyright © 2019 chars. All rights reserved.
//

import UIKit

class MXWLocationModel: Decodable {
    /// 省份名称
    public var province: String!
    /// 城市名称
    public var city: String!
    /// 城市区名称
    public var district: String!
    
    public func string() -> String{
        var strings: String = ""
        if let p = province {
            strings.append(p)
        }
        if let c = city {
            strings.append(c)
        }
        if let d = district {
            strings.append(d)
        }
        return strings
    }
}

/// 城市区行政
class MXWDistrict: Decodable {
    public var name: String!
    public var code: String!
}

/// 城市
class MXWCity: Decodable {
    public var name: String!
    public var code: String!
    public var districts: [MXWDistrict]!
    
    enum CodingKeys: String, CodingKey {
        case name
        case code
        case districts = "children"
    }
}

/// 省份
class MXWProvince: Decodable {
    public var name: String!
    public var code: String!
    public var cities: [MXWCity]!
    
    enum CodingKeys: String, CodingKey {
        case name
        case code
        case cities = "children"
    }
}
