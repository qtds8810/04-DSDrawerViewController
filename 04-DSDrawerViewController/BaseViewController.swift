//
//  BaseViewController.swift
//  04-DSDrawerViewController
//
//  Created by 左得胜 on 2016/10/14.
//  Copyright © 2016年 左得胜. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - View LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let managerVC = UIApplication.shared.keyWindow?.rootViewController as? ManagerViewController {
            if let vcCounts = navigationController?.viewControllers.count {
                if vcCounts > 1 {
                    managerVC.mainView.removeGestureRecognizer(managerVC.homePanGesture)
                } else {
                    managerVC.mainView.addGestureRecognizer(managerVC.homePanGesture)
                }
            }
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        if let vcCounts = navigationController?.viewControllers.count {
            if vcCounts > 1 {
                navigationItem.leftBarButtonItem = UIBarButtonItem(title: "测试返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(baseVC_leftItemClick))
            }
//            else {
//                navigationItem.leftBarButtonItem = UIBarButtonItem(title: "测试除一级界面的返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(baseVC_leftItemClick))
//            }
        }
        
    }
    
    // MARK: - Public Method
    
    // MARK: - Private Method
    /// 初始化UI
    fileprivate func setupUI() {
        // 添加控件
        
        // 布局控件
        
    }
    
    // MARK: - Action
    func baseVC_leftItemClick() {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Lazy

}

// MARK: - UIGestureRecognizerDelegate
extension BaseViewController: UIGestureRecognizerDelegate {
    /// 解决设置返回为leftitem之后返回手势失效的问题，和抽屉冲突的问题
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("&&&&&&&&\(#function)&&&\(navigationController?.viewControllers.count)")
        
        guard let counts = navigationController?.viewControllers.count else {
            return false
        }
        if counts > 1 {
            
            return true
        } else {
            
            return false
        }
    }
}
