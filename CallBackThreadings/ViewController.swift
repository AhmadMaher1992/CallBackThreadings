//
//  ViewController.swift
//  CallBackThreadings
//
//  Created by Ahmad Eisa on 3/12/20.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var usersNames = [String]()

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getUsers(completion: {(success , response , error) in
            if success {
                print("GetUser Block Called")
                guard let names = response as? [String] else { return }
                self.usersNames = names
                self.tableView.reloadData()
                print("Mission Done")
            }else{
                if let error = error {
                    print(error)
                }
            }
            
        })
        
    }
    // escaping mean all call back code run later after this fuction closed up
    func getUsers(completion: @escaping (Bool , Any? , Error?)-> Void){
        print("GetUser Function Start")
        DispatchQueue.global().asyncAfter(deadline: .now() + 2){
            guard  let path = Bundle.main.path(forResource: "eisa", ofType: "json") else { return }
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                guard let array = json as? [[String: Any]] else { return }
                var names = [String]()
                for user in array {
                    guard let name = user["name"] as? String else {
                        return
                    }
                    names.append(name)
                    
                }
                DispatchQueue.main.async {
                    print("Go From Back Ground Thread To Main Thread")
                    completion(true , names , nil)
                }
                
                
            } catch  {
                print("There Is Error")
                DispatchQueue.main.async {
                    completion(false , nil , error)
                }
                
            }
        }
        print("Dispatch Finished")
        }
      


}

extension ViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = usersNames[indexPath.row]
        return cell
        
    }
    
    
}
