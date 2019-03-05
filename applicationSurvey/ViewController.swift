//
//  ViewController.swift
//  applicationSurvey
//
//  Created by Admin on 5/3/2562 BE.
//  Copyright © 2562 Admin. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBAction func deleteSurvey(_ sender: Any) {
        let alert = UIAlertController(
            title: "Delete",
            message: "ใส่ ID ของแถวที่ต้องการลบ",
            preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { tf in
            tf.placeholder = "ID ของแถวที่ต้องการลบ"
            tf.font = UIFont.systemFont(ofSize: 18)
            tf.keyboardType = .numberPad
        })
        
        let btCancel = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil)
        
        let btOK = UIAlertAction(title: "OK",
                                 style: .default,
                                 handler: { _ in
                                    
                                    guard let id = Int32(alert.textFields!.first!.text!) else {
                                        return
                                    }
                                    self.sql = "DELETE FROM people WHERE id = \(id)"
                                    sqlite3_exec(self.db, self.sql, nil, nil, nil)
                                    self.select()
        })
        
        alert.addAction(btCancel)
        alert.addAction(btOK)
        present(alert, animated: true, completion: nil)
    }
    
    let fileName = "db.sqlite"
    let fileManager = FileManager .default
    var dbPath = String()
    var sql = String()
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    var pointer: OpaquePointer?
    var datePicker:UIDatePicker = UIDatePicker()
    let toolBar = UIToolbar()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        sql = "CREATE TABLE IF NOT EXISTS people " +
            "(id INTEGER PRIMARY KEY AUTOINCREMENT, " +
            "name TEXT, " +
            "nameProduct TEXT, " +
            "place TEXT, " +
            "survey TEXT, " +
        "date TEXT)"
        let createTb = sqlite3_exec(db, sql, nil, nil, nil)
        if createTb != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db))
            print(err)
        }
        
        sql = "INSERT INTO people (id, name, nameProduct, place, survey, date) VALUES " +
            "('1', 'สมชาย พายเรือ','โดนัท', 'โรบินสัน', '3', '04/03/2019'), " +
        "('2', 'สมกด ตีเรือ', 'ซาลาเปา', 'โลตัส', '1', '05/03/2019')"
        sqlite3_exec(db, sql, nil, nil, nil)
        select()
    }
    func select() {
        sql = "SELECT * FROM people"
        sqlite3_prepare(db, sql, -1, &pointer, nil)
        textView.text = ""
        var id: Int32
        var name: String
        var nameProduct: String
        var place: String
        var survey: String
        var date: String
        
        while(sqlite3_step(pointer) == SQLITE_ROW) {
            id = sqlite3_column_int(pointer, 0)
            textView.text?.append("id: \(id)\n")
            
            name = String(cString: sqlite3_column_text(pointer, 1))
            textView.text?.append("name: \(name)\n")
            
            nameProduct = String(cString: sqlite3_column_text(pointer, 2))
            textView.text?.append("nameProduct: \(nameProduct)\n")
            
            place = String(cString: sqlite3_column_text(pointer, 3))
            textView.text?.append("place: \(place)\n")
            
            survey = String(cString: sqlite3_column_text(pointer, 4))
            textView.text?.append("survey: \(survey)\n")
            
            date = String(cString: sqlite3_column_text(pointer, 5))
            textView.text?.append("date: \(date)\n\n")
        }
    }
}

