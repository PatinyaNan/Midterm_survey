//
//  AddViewController.swift
//  applicationSurvey
//
//  Created by Admin on 5/3/2562 BE.
//  Copyright © 2562 Admin. All rights reserved.
//

import UIKit
import SQLite3

class AddViewController: UIViewController {

    @IBOutlet weak var datePickAdd: UIDatePicker!
    @IBOutlet weak var nameAdd: UITextField!
    @IBOutlet weak var nameProductAdd: UITextField!
    @IBOutlet weak var placeAdd: UITextField!
    @IBOutlet weak var surveyAdd: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    @IBAction func mySurvey(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            textLabel.text = "พอใจ"
        case 1:
            textLabel.text = "ปานกลาง"
        default:
            textLabel.text = "ไม่พอใจ"
            break
        }
    }
    @IBAction func addData(_ sender: Any) {
        let name = nameAdd.text! as NSString
        //let name = nameAdd.text! as NSString
        let nameProduct = nameProductAdd.text! as NSString
        let place = placeAdd.text! as NSString
        let survey = textLabel.text! as NSString
        let currentDate = datePickAdd.date
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "dd/MM/YYYY"
        let thaiLocale = NSLocale(localeIdentifier: "TH_th")
        myFormatter.locale = thaiLocale as Locale!
        let currentDateText = myFormatter.string(from: currentDate)
        //        showDate.text = currentDateText
        self.sql = "INSERT INTO people VALUES (null, ?, ?, ?, ?, ?)"
        sqlite3_prepare(self.db, self.sql, -1, &self.stmt, nil)
        sqlite3_bind_text(self.stmt, 1, name.utf8String, -1, nil)
        sqlite3_bind_text(self.stmt, 2, nameProduct.utf8String, -1, nil)
        sqlite3_bind_text(self.stmt, 3, place.utf8String, -1, nil)
        sqlite3_bind_text(self.stmt, 4, survey.utf8String, -1, nil)
        sqlite3_bind_text(self.stmt, 5, currentDateText, -1, nil)
        sqlite3_step(self.stmt)
    }
    let fileName = "db.sqlite"
    let fileManager = FileManager .default
    var dbPath = String()
    var sql = String()
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    var pointer: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let dbURL = try! fileManager .url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)
            .appendingPathComponent(fileName)
        
        let opendb = sqlite3_open(dbURL.path, &db)
        if opendb != SQLITE_OK {
            print("Opening Database Error")
            return
        }
        else {
            print("Opening Database")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
