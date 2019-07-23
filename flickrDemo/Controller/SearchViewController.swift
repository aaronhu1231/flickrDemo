//
//  SearchViewController.swift
//  flickrDemo
//
//  Created by aaron on 2019/7/22.
//  Copyright © 2019 aaron. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var txtPerPage: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "輸入搜尋頁"
        // Do any additional setup after loading the view.
        txtSearch.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        txtSearch.addTarget(self, action: #selector(closeKeyboard), for: .editingDidEndOnExit)
        txtPerPage.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        txtPerPage.addTarget(self, action: #selector(closeKeyboard), for: .editingDidEndOnExit)
       
    }
    
    @objc func textFieldChange() {
        if self.txtSearch.text != "" && self.txtPerPage.text != "" {
            btnSearch.backgroundColor = UIColor(displayP3Red: 0, green: 0.5, blue: 1, alpha: 1)
            btnSearch.isEnabled = true
        } else {
            btnSearch.backgroundColor = UIColor(displayP3Red: 0.74, green: 0.74, blue: 0.74, alpha: 1)
            btnSearch.isEnabled = false
        }
    }
    
    @objc func closeKeyboard() {
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultView = segue.destination as! ResultCollectionViewController
        resultView.text = txtSearch.text ?? ""
        resultView.perPage = Int(txtPerPage.text ?? "") ?? 10
    }
}

