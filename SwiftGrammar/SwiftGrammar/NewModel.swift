//
//  NewModel.swift
//  Swift语法
//
//  Created by Myfly on 17/9/2.
//  Copyright © 2017年 Myfly. All rights reserved.
//

import UIKit

class NewModel: NSObject {
    var title : String = ""
    var imgsrc : String = ""
    var source : String = ""
    var votecount : Int = 0
    
    class func newsModelWith(_ dict : [String : Any]) -> NewModel {
        
        let model = NewModel()
        model.setValuesForKeys(dict)
        return model
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
