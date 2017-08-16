//
//  DetailViewController.swift
//  SendValue
//
//  Created by lisonglin on 14/04/2017.
//  Copyright © 2017 lisonglin. All rights reserved.
//

import UIKit

//定义闭包
typealias MyColsure = (_ str: String) -> Void

//协议传值
protocol GetMessageDelegate: NSObjectProtocol {
    func getMssage(string: String)
}

class DetailViewController: UIViewController {

    var delegate: GetMessageDelegate?

    //属性传值
    var text: String = ""
    
    var textField: UITextField = UITextField()
    
    var myColsure: MyColsure?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.title = "DetailVC"
        

        
        //initTextField
        textField.frame = CGRect(x:0,y:0,width:200,height:30)
        textField.center = CGPoint.init(x: self.view.center.x, y: 200)
        textField.textAlignment = NSTextAlignment.center
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.5
        self.view.addSubview(textField)
        textField.text = text
        
        
        //button
        let backBtn = UIButton.init(frame: CGRect(x:0,y:0,width:100,height:30))
        backBtn.backgroundColor = UIColor.green
        backBtn.setTitle("BACK", for: UIControlState.normal)
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        backBtn.center = CGPoint.init(x: self.view.center.x, y: 280)
        self.view.addSubview(backBtn)
        backBtn.addTarget(self, action: #selector(DetailViewController.backBtnClick), for: UIControlEvents.touchUpInside)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func backBtnClick()  {
        
        //代理
//        if delegate != nil {
//            delegate?.getMssage(string: self.textField.text!)
//            _ = self.navigationController?.popViewController(animated: true)
//
//        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"NotificationName"), object: nil, userInfo: ["value":self.textField.text ?? "i am a default Value"])
        
//        if self.myColsure != nil {
//            self.myColsure!(self.textField.text!)
//        }
        
        
        _ = self.navigationController?.popViewController(animated: true)
    }
  
    func getMssage(string: String) {
        print(string)
    }
    
    

}
