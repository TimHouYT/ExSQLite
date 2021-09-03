//
//  ViewController.swift
//  ExSQLite
//
//  Created by 侯彥廷 on 2021/9/1.
//

//SQlite 指令頁

import SQLite3
import UIKit

class ViewController: UIViewController {

    var db :SQLiteConnect? = nil

    let sqliteURL: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("db.sqlite")
        } catch {
            fatalError("Error getting file URL from document directory.")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 資料庫檔案的路徑
        let sqlitePath = sqliteURL.path
        
        // 印出儲存檔案的位置
        print(sqlitePath)
        
        // SQLite 資料庫
        db = SQLiteConnect(path: sqlitePath)
        
        if let mydb = db {
            
            // create table（建立資料表）
            let _ = mydb.createTable("students", columnsInfo: [
                "id integer primary key autoincrement",
                "name text",
                "height double"])
            
            // insert（加入資料）
            let _ = mydb.insert("students",
                                rowInfo: ["name":"'大小'","height":"178.2"])
          
            
            // select選擇（這個好像一定要開著）
           let statement = mydb.fetch("students", cond: "1 == 1", order: nil)
           while sqlite3_step(statement) == SQLITE_ROW{
                let id = sqlite3_column_int(statement, 0)
                let name = String(cString: sqlite3_column_text(statement, 1))
                let height = sqlite3_column_double(statement, 2)
                print("\(id). \(name) 身高： \(height)")
            }
            sqlite3_finalize(statement)
            
           //  update更新
           //  let _ = mydb.update(
           //     "students",
           //     cond: "id = 1",
           //     rowInfo: ["name":"'小強'","height":"176.8"])
            
            // delete刪除
            let _ = mydb.delete("students", cond: "id =1")
            
        }
    }

}
