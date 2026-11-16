//
//  LoginVCViewController.swift
//  sqliteswift1
//
//  Created by Noppasin Tanomsakoran on 9/11/2569 BE.
//

import UIKit
import SQLite

class LoginVCViewController: UIViewController, UITextFieldDelegate {

    @IBAction func btnSignin(_ sender: Any) {
        guard let id = Int64(txtmemid.text ?? "") else {
            alertWithTitle(title: "ERROR", message: "Password is Incorrect")
            return
        }
    }
    @IBOutlet weak var txtmemid: UITextField!
    @IBOutlet weak var txtPassw: UITextField!
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string:String) -> Bool {
        let allowedCharacters = NSCharacterSet.decimalDigits
        let characterSet = NSCharacterSet(charactersIn: string)
        
        if allowedCharacters.isSuperset(of: characterSet as CharacterSet) {
            return true
        } else {
            return false
        }
    }
    
    
    func alertWithTitle(title:String!, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {_ in
                if title=="ERROR"{
                    self.txtPassw.becomeFirstResponder()
                }
            });
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    
    func readDB4memberID(memid: Int64, mempass: String) {
        do {
            let db = try AppDatabase.open(readonly: true)
            let member = Table("register")
            let id = SQLite.Expression<Int64>("member_id")
            let name = SQLite.Expression<String>("member_name")
            let password = SQLite.Expression<String>("mem_passw")
            let active = SQLite.Expression<Int64>("active")
            guard let member = try db.pluck(member.filter(id == memid && active == 1)) else {
                alertWithTitle(title: "ERROR", message: "Member ID is Incorrect")
                return
            }
            guard member[password] == mempass else {
                alertWithTitle(title: "ERROR", message: "Password is Incorrect")
                return
            }
            UserDefaults.standard.set([String(memid), member[name]], forKey: "savedUser",
            view.window?.rootViewController = (storyboard?.instantiateViewController(withIdentifier: "MainNC")))
        } catch {
            alertWithTitle(title: "ERROR", message: error.localizedDescription)
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
