//
//  FontDetailVC.swift
//  Font
//
//  Created by 王坤田 on 2017/10/25.
//  Copyright © 2017年 王坤田. All rights reserved.
//

import UIKit

class FontDetailVC: UIViewController {
    
    var font : Font!
    
    let screenSize = UIScreen.main.bounds
    
    var detailLabel : UILabel!
    
    let text = "ABCDEFGHIJKLMNOPQRSTUVWXYZ\nabcdefghijklmnopqrstuvwxyz\n1234567890\n一二三四五六七八九十"
    var toolBar : UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        self.title = font.fontName
        
        //self.toolBar = self.navigationController?.toolbar
        
        initViews()
    }
    
    func initViews() {
        
        
        let scrollView = UIScrollView()
        
        self.view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            
            make.top.bottom.right.left.equalTo(0)
            
            
        }
        
        scrollView.contentSize = CGSize(width: 0, height: screenSize.height)
        
        
        detailLabel = UILabel()
        scrollView.addSubview(detailLabel)
        
        let h : CGFloat = (self.navigationController?.navigationBar.bounds.height)! + 10
        
        detailLabel.snp.makeConstraints { (make) in
            
            make.left.equalTo(20)
            make.width.equalTo(screenSize.width - 40)
            make.top.equalTo(h)
            make.bottom.equalTo(-200)
            
        }
        detailLabel.numberOfLines = 0
        
        detailLabel.lineBreakMode = .byCharWrapping
        
        detailLabel.font = UIFont(name: font.fontName, size: 30)
        
        detailLabel.text = text
        
        toolBar = UIToolbar()
        self.view.addSubview(toolBar)
        toolBar.snp.makeConstraints { (make) in
            
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(44)
            
        }
        toolBar.barStyle = .default
        
        let slider = UISlider()
        
        toolBar.addSubview(slider)
        
        slider.snp.makeConstraints { (make) in
            
            make.width.equalTo(screenSize.width - 60)
            make.height.equalTo(30)
            make.center.equalTo(toolBar)
            
        }
        
        slider.minimumValue = 1
        slider.maximumValue = 100
        slider.value = 30
        
        slider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        
 
    }
    
    @objc func sliderValueChanged(sender : UISlider) {
        
        let value = sender.value
        detailLabel.font = UIFont(name: font.fontName, size: CGFloat(value))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
