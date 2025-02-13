//
//  BaseViewController.swift
//  TodayWeather
//
//  Created by 조우현 on 2/13/25.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twBackground
        
        configureView()
        configureData()
        configureAction()
        bindData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // view가 willDisappear될 때 백버튼의 타이틀 없애기
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func configureView() { }
    
    func configureData() { }
    
    func configureAction() { }
    
    func bindData() { }
}
