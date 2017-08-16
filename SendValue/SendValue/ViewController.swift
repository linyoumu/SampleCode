//
//  ViewController.swift
//  SendValue
//
//  Created by lisonglin on 14/04/2017.
//  Copyright © 2017 lisonglin. All rights reserved.
//

import UIKit


class ViewController: UIViewController, GetMessageDelegate{

    var textField: UITextField = UITextField()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "SendValue"
        
        self.view.backgroundColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.notification), name: NSNotification.Name(rawValue: "NotificationName"), object: nil)
        
        //initial textField
        textField = UITextField.init(frame: CGRect(x:0,y:0,width:200,height:30))
        textField.center = CGPoint.init(x: self.view.center.x, y: 200)
        textField.textColor = UIColor.red
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholder = "请输入内容"
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 5
        self.view.addSubview(textField)
        
        //initial button
        let sendBtn = UIButton.init(frame: CGRect(x:0,y:0,width:100,height:30))
        sendBtn.backgroundColor = UIColor.orange
        sendBtn.setTitle("点我跳转", for: UIControlState.normal)
        sendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        sendBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        sendBtn.center = CGPoint.init(x: self.view.center.x, y: 280)
        sendBtn.addTarget(self, action: #selector(ViewController.sendBtnClick), for: UIControlEvents.touchUpInside)
        self.view .addSubview(sendBtn)
    }
    
    
    //按钮点击事件
    func sendBtnClick()  {
        
        let vc = DetailViewController()
        
        //属性传值
//        vc.text = self.textField.text!
        
//        vc.delegate = self
        
        
        //闭包传值
//        vc.myColsure = {
//            (backStr: String) -> Void in
//        
//            self.textField.text = backStr
//        
//        }

        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func getMssage(string: String) {
        print(string)
        self.textField.text = string
    }
    
    //通知传值
    func notification(obj:NSNotification)  {

        self.textField.text = obj.userInfo?["value"] as? String
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue:"NotificationName"), object: nil)
    }

}

