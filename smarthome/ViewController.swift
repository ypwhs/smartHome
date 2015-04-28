//
//  ViewController.swift
//  smarthome
//
//  Created by 杨培文 on 15/4/28.
//  Copyright (c) 2015年 杨培文. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    var client = TCPClient(addr: "121.201.15.201", port: 8085)
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var connected: UIImageView!
    @IBAction func connect(sender: AnyObject) {
        out("连接中")
        var (success,error) = client.connect(timeout: 10)
        if !success{
            out(error)
            self.connected.image = UIImage(named: "notconnected")
        }else{
            out("连接成功")
            self.connected.image = UIImage(named: "connected")
        }
    }
    @IBAction func disconnect(sender: AnyObject) {
        
    }
    @IBAction func c1(sender: AnyObject) {
        send("1")
        read()
    }
    @IBAction func c2(sender: AnyObject) {
        send("2")
        read()
    }
    @IBAction func c3(sender: AnyObject) {
        send("3")
        read()
    }
    @IBOutlet weak var all: UIButton!
    @IBOutlet weak var wendu: UIButton!
    @IBAction func clearall(sender: AnyObject) {
        send("4")
        read()
    }
    @IBAction func askwendu(sender: AnyObject) {
        send("5")
        var wendustr = read()
        wendustr = wendustr.substringFromIndex(advance(wendustr.startIndex, 1))
        wendu.setTitle(wendustr, forState: UIControlState.Normal)
    }
    @IBAction func sendir(sender: AnyObject) {
        send("6")
        read()
    }
    
    func read()->String{
        var asdsa = ""
        if let re = client.read(1024*10){
            if let str = byteToString(re){
                asdsa = str
            }
            println("获取数据成功:\(asdsa)")
        }
        label.text = asdsa
        return asdsa
    }
    
    func send(str:String){
        println("开始发送数据:\(str)")
        let (succeed,error) = client.send(data: str.dataUsingEncoding(NSUTF8StringEncoding)!)
        if succeed{
            println("发送数据成功")
        }else{
            println("发送数据失败:\(error)")
        }
    }
    
    func byteToString(buf:[UInt8])->String?{
        return NSString(bytes: buf, length: buf.count, encoding: NSUTF8StringEncoding) as? String
    }
    
    func xiancheng(code:dispatch_block_t){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), code)
    }
    func ui(code:dispatch_block_t){
        dispatch_async(dispatch_get_main_queue(), code)
    }
    
    func out(str:String){
        label.text = str
        println(str)
    }
    @IBOutlet weak var label: UILabel!

}

