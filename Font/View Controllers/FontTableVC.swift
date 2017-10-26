//
//  FontTableVC.swift
//  Font
//
//  Created by 王坤田 on 2017/10/25.
//  Copyright © 2017年 王坤田. All rights reserved.
//

import UIKit
import SnapKit
import CoreData

class FontTableVC: UITableViewController {
    
    var fonts : [Font] = []
    
    var favoriteFonts : [Font] = []
    
    let cellReuseIdentifier = "fontCell"
    
    var segmentedControl : UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        
        initData()
    }
    
    
    func initViews() {
        
        segmentedControl = UISegmentedControl(items: ["Font","Favorite"])
        self.navigationItem.titleView = segmentedControl
        
       
        
        segmentedControl.snp.makeConstraints { (make) in
            
            make.width.equalTo(240)
            make.height.equalTo(30)
            
        }
        
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor : UIColor.black], for: .normal)
    }
    
    func initData() {
        
        for fontName in UIFont.familyNames.sorted(){
            
            
            if CoreDataTool.getFont(by: fontName).count <= 0 {
                
                CoreDataTool.insert(fontName: fontName, isFavorite: false)
                
            }
            
        }
        
        var array : [Font] = []
        var favoriteArray : [Font] = []
        for fontModel in CoreDataTool.getAllFonts() {
            
            
            let temp = Font(fontName: fontModel.fontName!, isFavorite: fontModel.isFavorite)
            array.append(temp)
            
            if fontModel.isFavorite {
                
                let temp = Font(fontName: fontModel.fontName!, isFavorite: fontModel.isFavorite)
                favoriteArray.append(temp)
                
            }
            
        }
        
        self.fonts =  array.sorted(by: { $0.fontName < $1.fontName })
        self.favoriteFonts = favoriteArray.sorted(by: { $0.fontName < $1.fontName })
        
        self.tableView.reloadData()
        
    }
    
    @objc func segmentChanged(){
        
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func fontForDisplay(with indexPath : IndexPath, index : Int )-> UIFont {
        
        let fontSize = UIFont.preferredFont(forTextStyle: .headline).pointSize
        
        if index == 0 {
            
            return UIFont(name: self.fonts[indexPath.row].fontName, size: fontSize)!
            
        }else {
            
            return UIFont(name: self.favoriteFonts[indexPath.row].fontName, size: fontSize)!
            
        }
        
        
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            return self.fonts.count
        }
        
        return self.favoriteFonts.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: self.cellReuseIdentifier)
        
        var temp : Font
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            temp = self.fonts[indexPath.row]
            
            
        }else {
            
            temp = self.favoriteFonts[indexPath.row]
        }
        cell.textLabel?.font = self.fontForDisplay(with: indexPath, index: segmentedControl.selectedSegmentIndex)
        cell.textLabel?.text = temp.fontName
        cell.detailTextLabel?.text = temp.fontName
        
        if temp.isFavorite {
            
            cell.accessoryType = .checkmark
            
        }

        return cell
    }
    
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let font = self.fontForDisplay(with: indexPath, index: segmentedControl.selectedSegmentIndex)
        
        return font.ascender + font.descender + 80
        
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            
            let temp = self.fonts[indexPath.row]
            
            if temp.isFavorite {
                
                let remvoFromFavoriteAction = UITableViewRowAction(style: .normal, title: "移除收藏") { (action, indexPath) in
                    
                    self.fonts[indexPath.row].isFavorite = false
                    
                    CoreDataTool.update(fontName: temp.fontName, isFavorite: false)
                    
                    self.refreshFavoriteData(handle: {
                        
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)

                    })
                    
                    
                    
                }
                remvoFromFavoriteAction.backgroundColor = UIColor.red
                
                return [remvoFromFavoriteAction]
                
            }
            
            let addFavoriteAction = UITableViewRowAction(style: .normal, title: "加入收藏") { (action, indexPath) in
                
                self.fonts[indexPath.row].isFavorite = true
                
                CoreDataTool.update(fontName: temp.fontName, isFavorite: true)
                
                self.refreshFavoriteData(handle: {
                    
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    
                })
                
            }
            addFavoriteAction.backgroundColor = UIColor.orange
            return [addFavoriteAction]
            
        default:
            
            let temp = self.favoriteFonts[indexPath.row]
            
            let remvoFromFavoriteAction = UITableViewRowAction(style: .normal, title: "移除收藏") { (action, indexPath) in
                
                //self.favoriteFonts.remove(at: indexPath.row)
                
                CoreDataTool.update(fontName:temp.fontName, isFavorite: false)
                
                self.refreshFavoriteData(handle: {
                    
                    self.tableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
                })
                
                
                
            }
            remvoFromFavoriteAction.backgroundColor = UIColor.red
            
            return [remvoFromFavoriteAction]
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = FontDetailVC()
        
        detailVC.font = self.fonts[indexPath.row]
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func refreshFavoriteData(handle : () -> Void) {
        
        var favoriteArray : [Font] = []
        
        for fontModel in CoreDataTool.getAllFonts() {
            
            if fontModel.isFavorite {
                
                let temp = Font(fontName: fontModel.fontName!, isFavorite: fontModel.isFavorite)
                favoriteArray.append(temp)
                
            }
            
        }
        
        self.favoriteFonts = favoriteArray.sorted(by: { $0.fontName < $1.fontName })
        
        handle()
    }

}
