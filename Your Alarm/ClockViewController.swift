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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ClockViewController.update), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.clockView = EZClockView(frame: view.bounds)
        update()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func update(){
        let date = Date()
        let calendar = Calendar.current
        let hourProperty = calendar.component(.hour, from: date)
        let minuteProperty = calendar.component(.minute, from: date)
        let secondProperty = calendar.component(.second, from: date)
        print("\(hourProperty):\(minuteProperty):\(secondProperty)")
        clockView.hours = hourProperty
        clockView.seconds = secondProperty
        clockView.minutes = minuteProperty
        self.clockLabel.text = String.convertToTimer(time: hourProperty) + ":" + String.convertToTimer(time: minuteProperty) + ":" + String.convertToTimer(time: secondProperty)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
