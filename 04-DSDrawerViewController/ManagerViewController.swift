//
//  ManagerViewController.swift
//  04-DSDrawerViewController
//
//  Created by 左得胜 on 2016/10/13.
//  Copyright © 2016年 左得胜. All rights reserved.
//

import UIKit

class ManagerViewController: UIViewController {
    
    /// 局部变量，其他页面可以获取到
    var homeNavController: UINavigationController!
    /// 侧滑手势，这里做成局部变量，方便push到详情页后取消掉
    var homePanGesture: UIPanGestureRecognizer!

    /// 侧滑所需要的参数
    var centerOfLeftViewAtBeginning: CGPoint = CGPoint.zero
    var distance: CGFloat = 0
    var distanceOfLeftView: CGFloat = 50
    var proportionOfLeftView: CGFloat = 1
    let fullDistance: CGFloat = 0.78
//    let fullDistance: CGFloat = 0.78
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Public Method
    
    // MARK: - Private Method
    /// 初始化UI
    fileprivate func setupUI() {
        // 给容器添加背景和遮罩
        view.addSubview(backgroundImageView)
        view.addSubview(blackCover)
        
        // 初始化左视图
        leftVC.view.frame = CGRect(x: 0, y: 0, width: screenWidth * fullDistance, height: screenHeight)
        leftVC.view.center = CGPoint(x: leftVC.view.center.x - distanceOfLeftView, y: leftVC.view.center.y)
        view.addSubview(leftVC.view)
        
        // 设置左侧视图动画开始的frame
        centerOfLeftViewAtBeginning = leftVC.view.center
        
        // 初始化中间视图
        homeNavController = UINavigationController(rootViewController: centerVC)
        centerVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "测试侧滑", style: UIBarButtonItemStyle.plain, target: self, action: #selector(showLeft))
        
        mainView.addSubview(homeNavController!.view)
        
        view.addSubview(mainView)
        
        // 把主视图绑定侧滑手势
        homePanGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(pan:)))
        mainView.addGestureRecognizer(homePanGesture)
    }
    
    // MARK: - Action
    func panAction(pan: UIPanGestureRecognizer) {
        let x = pan.translation(in: view).x
        let trueDistance = distance + x // 实时距离
        
        // 自己测试！！！
        //        print("******\(trueDistance)")
        // 禁止右滑手势出现右侧的view
        guard trueDistance > 0 else {
            return
        }
        
//        print(pan.state.rawValue)
        // 如果 UIPanGestureRecognizer 结束，则激活自动停靠
        if pan.state == UIGestureRecognizerState.ended {
            if trueDistance > screenWidth * (fullDistance / 3) {
                showLeft()
            } else if trueDistance < screenWidth * -(fullDistance / 3) {
//                showRight()
//                return
            } else {
                showHome()
            }
            return
        }
        
        // 计算缩放比例
        var proportion: CGFloat = pan.view!.frame.origin.x >= 0 ? -1 : 1
        proportion *= trueDistance / screenWidth
        proportion *= 1 - fullDistance
        proportion /= fullDistance + fullDistance/2 - 0.5
        proportion += 1
        if proportion <= fullDistance { // 若比例已经达到最小，则不再继续动画
            return
        }
        // 执行视差特效
        blackCover.alpha = (proportion - fullDistance) / (1 - fullDistance)
        // 执行平移和缩放动画
        pan.view?.center = CGPoint(x: self.view.center.x + trueDistance, y: self.view.center.y)
        pan.view?.transform = CGAffineTransform.identity.scaledBy(x: proportion, y: proportion)
        
        // 执行左视图动画
        let trueProportion = trueDistance / (screenWidth*fullDistance)
        let pro = 0.8 + (proportionOfLeftView - 0.8) * trueProportion
        leftVC.view.center = CGPoint(x: centerOfLeftViewAtBeginning.x + distanceOfLeftView * trueProportion, y: centerOfLeftViewAtBeginning.y - (proportionOfLeftView - 1) * leftVC.view.frame.height * trueProportion / 2 )
        leftVC.view.transform = CGAffineTransform.identity.scaledBy(x: pro, y: pro)
    }
    
    /// 展示左侧视图
    func showLeft() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showHome))
        mainView.addGestureRecognizer(tapGesture)
        
        distance = view.center.x * (fullDistance*2 + fullDistance - 1)
        
        doAnimation(proportion: fullDistance, showWhat: 2)
    }
    
    /// 展示主视图
    func showHome() {
        distance = 0
        doAnimation(proportion: 1.0, showWhat: 1)
    }
    
    /// 执行三种动画：显示左侧菜单，显示主页，显示右侧菜单（封闭该功能）
    ///
    /// - parameter proportion: <#proportion description#>
    /// - parameter showWhat:   1表示主界面，2表示左侧界面，3表示右侧界面
    func doAnimation(proportion: CGFloat, showWhat: Int) {
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
            // 移动首页中心
            self.mainView.center = CGPoint(x: self.view.center.x + self.distance, y: self.view.center.y)
            // 缩放首页
            self.mainView.transform = CGAffineTransform.identity.scaledBy(x: proportion, y: proportion)
            if showWhat == 2 {
                self.leftVC.view.center = CGPoint(x: self.centerOfLeftViewAtBeginning.x + self.distanceOfLeftView, y: self.leftVC.view.center.y)
                self.leftVC.view.transform = CGAffineTransform.identity.scaledBy(x: self.proportionOfLeftView, y: self.proportionOfLeftView)
            }
            
            // 改变黑色遮罩的透明度
            self.blackCover.alpha = showWhat == 1 ? 1 : 0
            
            //
            self.leftVC.view.alpha = showWhat == 3 ? 0 : 1
            
            }) { (isFinished) in
        }
    }
    
    // MARK: - Lazy
    /// 懒加载背景图片
    fileprivate lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "back"))
        iv.frame = UIScreen.main.bounds
        
        return iv
    }()
    /// 懒加载中间的界面
    lazy var centerVC: CenterViewController = CenterViewController()
    /// 懒加载左侧的界面
    fileprivate lazy var leftVC: LeftViewController = LeftViewController()
    /// 懒加载黑色遮罩
    fileprivate lazy var blackCover: UIView = {
        let view = UIView(frame: self.view.frame.offsetBy(dx: 0, dy: 0))
        view.backgroundColor = UIColor.black
        
        return view
    }()
    /// 懒加载主界面的View
    lazy var mainView: UIView = UIView(frame: self.view.frame)

}
