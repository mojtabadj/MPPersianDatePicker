//
//  ViewController.swift
//  MPPersianDatePicker
//
//  Created by Mojtaba Pourasghar on 07/14/2017.
//  Copyright (c) 2017 Mojtaba Pourasghar. All rights reserved.
//

import UIKit
import MPPersianDatePicker

class ViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func showDate(_ sender: Any) {
       // get tomarrow date
        let selectDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        MPPersianDatePicker.defaultDate = selectDate
        let _ = MPPersianDatePicker.show(on: self, handledBy: HandleDateDidChange)
    }
    
    func HandleDateDidChange(to newDate: MPDate?)
    {
        guard let date = newDate else
        {
            dateLabel.text = "nil"
            return
        }
        
        dateLabel.text = date.persianDate
        
    }
}

