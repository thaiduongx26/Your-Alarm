//
//  ClockViewController.swift
//  Your Alarm
//
//  Created by Thai Duong on 3/5/17.
//  Copyright © 2017 Thai Duong. All rights reserved.
//

import UIKit
import EZClockView
class ClockViewController: UIViewController {
    var timer : Timer?
    
    @IBOutlet weak var clockView: EZClockView!
    @IBOutlet weak var clockLabel: UILabel!
    
    @IBOutlet weak var showListButton: UIButton!
    @IBOutlet weak var alarmButton: UIButton!
    @IBOutlet weak var listHistoryButton: UIButton!
    
    private var countForShowListbutton : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        update()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setupButtonForTest()
        self.showListButton.center = CGPoint(x: 100, y: 200)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
    func update(){
        let date = Date()
        let calendar = Calendar.current
//        print(calendar.component(., from: date))
        let hourProperty = calendar.component(.hour, from: date)
        let minuteProperty = calendar.component(.minute, from: date)
        let secondProperty = calendar.component(.second, from: date)
        print("\(hourProperty):\(minuteProperty):\(secondProperty)")
        clockView.hours = hourProperty
        clockView.seconds = secondProperty
        clockView.minutes = minuteProperty
        self.clockLabel.text = String.convertToTimer(time: hourProperty) + ":" + String.convertToTimer(time: minuteProperty)
        
//        if hourProperty < 12 {
//            self.clockLabel.text = self.clockLabel.text! + "AM"
//        } else {
//            self.clockLabel.text = self.clockLabel.text! + "PM"
//        }
    }

    func setupButtonForTest(){
        self.showListButton.backgroundColor = UIColor(hex:"E0696F")
        self.alarmButton.backgroundColor = UIColor.green
        self.listHistoryButton.backgroundColor = UIColor.green
        self.showListButton.makeViewCircle()
        self.alarmButton.makeViewCircle()
        self.listHistoryButton.makeViewCircle()
    }

    @IBAction func showListButtonDidTap(_ sender: UIButton) {
        if countForShowListbutton == 0 {
            UIView.animate(withDuration: 0.5, animations: { 
                //self.showListButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI / 4))
                self.showListButton.center = CGPoint(x: 100,y: 300)
//                UIView.animate(withDuration: 0.5, animations: { 
//                    self.alarmButton.center = CGPoint(x: sender.center.x - 50, y: sender.center.y - 50)
//                })
//                self.listHistoryButton.center = CGPoint(x: sender.center.x + 50 , y : sender.center.y - 50)
            }, completion: { (true) in
                self.countForShowListbutton = 1
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: { 
                self.showListButton.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            }, completion: { (true) in
                self.countForShowListbutton = 0
            })
        }
        
    }
}
