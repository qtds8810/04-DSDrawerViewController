//
//  LeftViewController.swift
//  04-DSDrawerViewController
//
//  Created by 左得胜 on 2016/10/13.
//  Copyright © 2016年 左得胜. All rights reserved.
//

import UIKit

class LeftViewController: BaseViewController {

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Public Method
    
    // MARK: - Private Method
    /// 初始化UI
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.green
                
        // 添加控件
        view.addSubview(myImageView)
        view.addSubview(loginBtn)
        
        // 布局控件
        myImageView.frame = CGRect(x: 10, y: 100, width: 80, height: 80)
        loginBtn.frame = CGRect(x: 10, y: 200, width: 80, height: 40)
    }
    
    // MARK: - Action
    func loginBtnClick() {
        let detailVC = DetailViewController()
//        navigationController?.pushViewController(detailVC, animated: true)
        let managerVC = UIApplication.shared.keyWindow?.rootViewController as! ManagerViewController
        managerVC.centerVC.navigationItem.title = "hahahahahahah"
        managerVC.centerVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "测试哈", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        managerVC.homeNavController?.pushViewController(detailVC, animated: true)
        managerVC.showHome()
    }
    
    // MARK: - Lazy
    /// 懒加载头像
    fileprivate lazy var myImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "gold")
        
        return iv
    }()
    /// 懒加载登录按钮
    fileprivate lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.brown
        btn.setTitle("点我登录", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.setTitleColor(UIColor.lightText, for: UIControlState.highlighted)
        
        btn.addTarget(self, action: #selector(loginBtnClick), for: UIControlEvents.touchUpInside)
        
        return btn
    }()

}
