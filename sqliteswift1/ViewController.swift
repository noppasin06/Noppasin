//
//  ViewController.swift
//  sqliteswift1
//
//  Created by Noppasin Tanomsakoran on 9/11/2569 BE.
//

import UIKit
import SQLite

class ViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtRepass: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtMemname: UITextField!
    @IBOutlet weak var txtMemid: UITextField!


    @objc func tap(sender: UITapGestureRecognizer){
               print("tapped")
               view.endEditing(true)
       }
       
       @IBAction func txtEmail(_ sender: Any) {
           if (txtEmail.text?.isValidEmail())! == false{
               alertWithTitle(title: "EMAIL ERROR!", message: "Email ไม่ถูกรูปแบบ!")
           }
       }
       
       override func viewDidLoad() {
           super.viewDidLoad()
           // Do any additional setup after loading the view.
           self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
           
           readDB4memberID()
       }

       func alertWithTitle(title: String!, message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
               if title=="EMAIL ERROR!"{
                   self.txtEmail.becomeFirstResponder()
               }
               else if title=="MEMID ERROR!"{
                       self.txtMemid.becomeFirstResponder()
               }
               else if title=="MEMNAME ERROR!"{
                       self.txtMemname.becomeFirstResponder()
               }
               else if title=="PASSWORD ERROR!"{
                       self.txtPass.becomeFirstResponder()
               }
               else if title=="REPASSWORD ERROR!"{
                       self.txtPass.becomeFirstResponder()
               }
               else{
   //                self.txtRepass.becomeFirstResponder()
               }
           });
           alert.addAction(action)
           self.present(alert, animated: true, completion:nil)
       }
       
       @IBAction func txtRepass(_ sender: Any) {
           if txtPass.text != txtRepass.text{
               alertWithTitle(title: "REPASSWORD ERROR!", message: "รหัสผ่านไม่ตรง")
           }
       }
       
       func fieldsAreValid() -> Bool {
           if txtMemid.text!.isEmpty {
               alertWithTitle(title: "MEMID ERROR!", message: "ไม่ใส่รหัสสมาชิก")
               return false
           }
           else if txtMemname.text!.isEmpty {
               alertWithTitle(title: "MEMNAME ERROR!", message: "ไม่ใส่ชื่อสมาชิก")
               return false
           }
           else if txtPass.text!.isEmpty {
               alertWithTitle(title: "PASSWORD ERROR!", message: "ไม่ใส่รหัสผ่าน")
               return false
           }
           else if txtRepass.text!.isEmpty {
               alertWithTitle(title: "REPASSWORD ERROR!", message: "รหัสผ่านไม่ตรง")
               return false
           }
           else if txtEmail.text!.isEmpty {
               alertWithTitle(title: "EMAIL ERROR!", message: "ไม่ใส่อีเมล")
               return false
           }
           guard txtPass.text == txtRepass.text else {
               alertWithTitle(title: "REPASSWORD ERROR!", message: "รหัสผ่านไม่ตรง")
               return false
           }
           guard txtEmail.text?.isValidEmail() == true else {
               alertWithTitle(title: "EMAIL ERROR!", message: "Email ไม่ถูกรูปแบบ!")
               return false
           }
           return true
       }

       @IBAction func btnRegist(_ sender: Any) {
           guard fieldsAreValid(), let id = Int64(txtMemid.text ?? ""),
                 let name = txtMemname.text, let password = txtPass.text,
                 let email = txtEmail.text else { return }
           do {
               let db = try AppDatabase.open()
               try db.transaction {
                   try db.run("INSERT INTO register (member_id, member_name, mem_passw, email, active) VALUES (?, ?, ?, ?, 1)",
                              id, name, password, email)
                   try db.run("UPDATE masterctrl SET member_id = member_id + 1 WHERE member_id = ?", id)
               }
               readDB4memberID()
               alertWithTitle(title: "บันทึกข้อมูลการลงทะเบียนเรียบร้อย", message: "สำเร็จ")
           } catch {
               alertWithTitle(title: "ERROR", message: error.localizedDescription)
           }
       }

       func readDB4memberID() {
           do {
               let db = try AppDatabase.open(readonly: true)
               if let id = try db.scalar("SELECT member_id FROM masterctrl") as? Int64 {
                   txtMemid.text = String(id)
               }
           } catch {
               alertWithTitle(title: "ERROR", message: error.localizedDescription)
           }
       }
   } // end class

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
