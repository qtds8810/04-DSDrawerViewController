//
//  CenterViewController.swift
//  04-DSDrawerViewController
//
//  Created by 左得胜 on 2016/10/13.
//  Copyright © 2016年 左得胜. All rights reserved.
//

import UIKit

class CenterViewController: BaseViewController {
    
//    var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Public Method
    
    // MARK: - Private Method
    /// 初始化UI
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
//        navigationItem.leftBarButtonItem?.title = "测试"
//        view.addGestureRecognizer(panGesture)
        // 添加控件
        view.addSubview(myButton)
        
        // 布局控件
        myButton.frame = CGRect(x: 10, y: 100, width: 150, height: 40)
    }
    
    // MARK: - Action
    func btnClick() {
        let detailVC = DetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - Lazy
    /// 懒加载按钮
    fileprivate lazy var myButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("点我进入详情页", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.setTitleColor(UIColor.lightText, for: UIControlState.highlighted)
        btn.backgroundColor = UIColor.brown
        
        btn.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
        
        return btn
    }()

}
