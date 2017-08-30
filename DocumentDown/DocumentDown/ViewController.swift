//
//  ViewController.swift
//  DocumentDown
//
//  Created by Myfly on 16/11/30.
//  Copyright © 2017年 Myfly. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    
    @IBOutlet weak var progressLbel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var downBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    
    var destination:DownloadRequest.DownloadFileDestination!
    var cancelledData: Data?
    var downloadRequest:DownloadRequest!
    let url:String = "http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"
    var progressValue:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressSlider.value = 0.0;
        
        self.downBtn.isEnabled = true
        self.stopBtn.isEnabled = false
        self.continueBtn.isEnabled = false
        
        // 设置下载文件存放路径， 下载完成调用
        self.destination = { _, response in
            
            self.downBtn.isEnabled = true
            self.stopBtn.isEnabled = false
            self.continueBtn.isEnabled = false
            
            //设置文件夹路径
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            //拼接上文件名
            let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
    }

    @IBAction func downAction(_ sender: Any) {
        
        self.downBtn.isEnabled = false
        self.stopBtn.isEnabled = true
        self.continueBtn.isEnabled = true

        self.downloadRequest = Alamofire.download(url, to: self.destination)
        
        self.downloadRequest.downloadProgress(queue: DispatchQueue.main, closure: downloadProgress)
        
        self.downloadRequest.responseData(completionHandler: downloadResponse)
        
    }
    
    @IBAction func stopDownload(_ sender: Any) {
        self.downloadRequest.cancel()
        self.stopBtn.isEnabled = false
        self.continueBtn.isEnabled = true
    }
    
    @IBAction func continueDownload(_ sender: Any) {
        
        if let cancelledData = self.cancelledData {
            
            self.downloadRequest = Alamofire.download(resumingWith: cancelledData, to: destination)
            
            self.downloadRequest.downloadProgress(queue: DispatchQueue.main, closure: downloadProgress)
        
            self.downloadRequest.responseData(completionHandler: downloadResponse)
            
            self.stopBtn.isEnabled = true
            self.continueBtn.isEnabled = false
            
        }
    }
    
    
    //下载过程中改变进度条
    func downloadProgress(progress: Progress) {
        //进度条更新
        print("当前进度：\(progress.fractionCompleted * 100)")
        self.progressSlider.value = Float(progress.fractionCompleted)
        self.progressValue = Int(progress.fractionCompleted * 100)
        self.progressLbel.text = "当前进度：\(self.progressValue)"
    }
    
    //下载停止响应（不管成功或者失败）
    func downloadResponse(response: DownloadResponse<Data>) {
        switch response.result{
        case .success:
            print("文件下载完成\(response)")
        case .failure:
            print("暂停下载")
            self.cancelledData = response.resumeData
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}

// MARK:- SessionDelegate
//extension ViewController: SessionDelegate{
//    
//}
