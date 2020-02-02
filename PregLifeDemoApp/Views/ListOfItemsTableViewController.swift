//
//  ListOfItemsTableViewController.swift
//  PregLifeDemoApp
//
//  Created by Hubert Kuzioła on 28/11/2019.
//  Copyright © 2019 HubertApps. All rights reserved.
//

import UIKit

class ListOfItemsTableViewController: UITableViewController {

    //var refreshControl: UIRefreshControl!
    internal var itemsListVM: ItemsTableViewVM!
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        // MARK: VM
           itemsListVM = ItemsTableViewVM()
           itemsListVM.refresh = {
               DispatchQueue.main.async { [weak self] in
                   self?.dataDidRefresh()
               }
           }

        if(self.refreshControl == nil){
            refreshControl = UIRefreshControl()
            self.refreshControl!.attributedTitle = NSAttributedString(string: "Odświeżanie danych")
            self.refreshControl?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
            tableView?.addSubview(refreshControl!)

        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    func dataDidRefresh() -> Void {

        tableView.reloadData()
        
    }
    @objc func refresh(sender:AnyObject) {
        refreshData()
    }
    @objc func refreshData()  {
        
        
        LoadDataFacade().getListOfAudioAndVideo(completionHandler:  { error, finish in
            print("Refresh ")
            
            
            DispatchQueue.main.async {
               self.tableView?.reloadData()
                self.refreshControl!.endRefreshing()
            }
            
            
        })
      
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemsListVM.numberOfItems
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCellIdentifier", for: indexPath) as! VideoAudioTableViewCell
        cell.fill(by: itemsListVM.getVMForItem(atIndex: indexPath.row))
        self.tableView.allowsSelection = true
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? VideoAudioTableViewCell
        {
            cell.didSelected()
            
            self.tableView.reloadData()
        }
        performSegue(withIdentifier: "audioSegue", sender: (itemsListVM.getModel(forIndex: indexPath.row))?.url)
        
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         if segue.identifier == "audioSegue" {
            (segue.destination as! ViewController).audioUrl = sender as? String
         }
         
     }



}
