//
//  MainViewController.swift
//  FirstMyApp
//
//  Created by sangjin park on 2018. 9. 3..
//  Copyright © 2018년 Loguin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let dataArray = ["1","2","3","4","5"];
    let sampleData = SampleData()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sampleData.samples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "numberFeatureCell", for: indexPath) as! MainFeatureCell
        let sample = self.sampleData.samples[indexPath.row]
        cell.titleLabel.text = sample.title
        cell.subLabel.text = sample.descrtipion
        cell.featureImageView.image = UIImage(named: sample.image)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0: self.performSegue(withIdentifier: "photoObjectDection", sender: nil)
        case 1: self.performSegue(withIdentifier: "realTimeObjectDection", sender: nil)
        case 2: self.performSegue(withIdentifier: "facialAnalysis", sender: nil)
           
        default:
            return

        }
    }
    

}
