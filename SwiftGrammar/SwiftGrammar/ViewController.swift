//
//  ViewController.swift
//  Swift语法
//
//  Created by Myfly on 17/8/31.
//  Copyright © 2017年 Myfly. All rights reserved.
//  http://blog.csdn.net/shenhaifeiniao/article/details/54923417

import UIKit

import Alamofire
import MJExtension
enum requestType {
    case get
    case post
}

class ViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    var modelArray : [NewModel]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //stringDemo()
        
        //arrayDemo()
        self.mainTableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.modelArray = Array()
        
        netWorkTest()
    }
    
    @IBAction func loadData(_ sender: Any) {
        netWorkTest()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension ViewController{
    func stringDemo() {
        //1.字符串转数值类型(Int/Long/Float/Double/Bool)
        // 因为Swift中没有直接可以使字符串直接转换成数值类型的方法，所以要将String类型的字符串转换成NSString类型的（str as NSString），直接调用OC中的方法进行转换即可。
        let strToValue = "100"
        let intValue = (strToValue as NSString).intValue
        print(intValue)
        
        // 2.字符串的替换
        var strReplace = "hello Tom"
        strReplace = strReplace.replacingOccurrences(of: "Tom", with: "World")
        print(strReplace)
        
        //let strTemp = strReplace[strReplace.startIndex...strReplace.index(strReplace.startIndex, offsetBy: 5)]
        //let strTemp = strReplace[strReplace.index(strReplace.endIndex, offsetBy: -5)..<strReplace.endIndex]
        
        //3.替换指定范围字符串
        // 字符串开始位置
        let start = strReplace.index(strReplace.startIndex, offsetBy: 6)
        // 字符串结束位置
        let end = strReplace.index(strReplace.startIndex, offsetBy: 7)
        //
        let range = start..<end
        strReplace = strReplace.replacingCharacters(in: range, with: "123456")
        print(strReplace)
        
        var students = ["Ben", "Ivy", "Jordell", "Maxime"]
        if let i = students.index(of: "Maxime") {
            students[i] = "Max"
        }
        print(students)
        // Prints "["Ben", "Ivy", "Jordell", "Max"]"
        
        //        删除前后多余的空格
        let string = "  good god    "
        let string2 = string.trimmingCharacters(in: .whitespaces)
        print(string2)
        
        //删除前后指定的字符
        let str = "<<my name is god>>"
        let charSet = CharacterSet(charactersIn: "<>")
        var str2 = str.trimmingCharacters(in: charSet)
        print(str2)
        
        //判断字符是否存在；存在则返回字符第一次出现的位置，否则返回nil
        if let index = str2.characters.index(of: "m"){
            print(index as Any)
        }
        
        
        //判断字符串是否包含子串；存在则返回子串的范围，否则返回nil
        if let range = str2.range(of: "name"){
            print(range)
        }
        
        // 拼接字符串
        var str3 = "你好，\(str2) 世界"
        print(str3)
        //在后面添加字符／字符串
        str3.append("!")
        print(str3)
        //+=：用于在后面添加同类型的
        str3 += "666"
        //        let char : Character = "!"
        //        str3 += char
        print(str3)
        
        // 插入一组字符
        //insert<S : Collection where S.Iterator.Element == Character>(contentsOf newElements: S, at i: String.Index)
        //集合中只能存放单个字符
        str3.insert(contentsOf: ["h", "e"], at: str3.index(str3.startIndex, offsetBy:2))
        print(str3)
        
        // 插入字符串
        let name = "Lin"
        str3.insert(contentsOf: name.characters, at: str3.startIndex)
        print(str3)
        
        // 截取字符串
        let range1 = str3.range(of: "my")
        str3 = str3.substring(to: (range1?.upperBound)!)
        print(str3)
    }
    
    func arrayDemo() {
        var array = ["10","20","0","2.5","3","2.5","4"]
        let index = array.index(of: "2.5")
        print(index!)
        
        //修改数组中的一组数据
        array[0...3] = ["12", "88"]
        print(array)
        
        // 插入数据
        array.insert("99", at: 1)
        print(array)
        
        //删除元素
        array.remove(at: 3)
        print(array)
        
        for item in array {
            print(item)
        }
        
        
    }
    
    func setDemo() {
        
        let set : Set = [1, 2, 3, 4, 5, 6]
        let set1 : Set = [4, 5, 6, 7, 8]
        
        //交集
        let setBoth = set1.intersection(set)
        print(setBoth)
        
    }
    
    func dictionaryDemo() {
        var dic:[Int:String] = [1:"One",2:"Two",3:"Three",4:"Four"]
        //updateValue 方法将更新一个键值 如果此键存在 则更新键值 并且将旧的键值返回 如果此键不存在 则添加键值 返回nil 其返回的为一个Optional类型值 可以使用if let进行处理
        dic.updateValue("9", forKey: 1)
        
        //如果有此键，则返回其值，并移除键值对,没有则返回nil
        dic.removeValue(forKey: 0) //没有此键，忽略
        dic.removeValue(forKey: 1)
    }
    
    //网络请求数据
    func netWorkTest() {

        Alamofire.request("http://c.m.163.com/nc/article/list/T1348649079062/0-20.html", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            //校验数据是否有值
            guard let result = response.result.value else{
                
                guard let error = response.result.error else{
                    return
                }
                print(error)
                return
            }
            
            //有数据就做相应处理
            var tempArr : [NewModel] = Array()
            //转换字典
            guard let dataDict = result as? [String : Any] else{return}
            //取出字典中的数组
            guard let dataArr = dataDict["T1348649079062"] as? [Any] else{return}
            
            for dict in dataArr{
                guard let dict = dict as? [String : Any] else{continue}
                tempArr.append(NewModel.newsModelWith(dict))
            }
            //print(tempArr)
            self.modelArray = tempArr
            
            self.mainTableView.reloadData()

            //            for model in tempArr{
//                print(model.title)
//                print(model.imgsrc)
//            }
        }

        
    }
    
}


extension ViewController:UITableViewDelegate,UITableViewDataSource{
    // 返回多少行cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.modelArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsCell
        let model = self.modelArray?[indexPath.row]
        cell.homeCellWith(cellModel: model!)
        
        return cell
    }
    
    // 返回cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
