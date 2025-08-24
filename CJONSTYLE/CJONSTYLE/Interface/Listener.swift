//
//  Listener.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

protocol ListViewModelListener: ChildListener { }

protocol SplashViewModelListener: ChildListener {
    func endLaunchScreen()
}

protocol DetailViewModelListener: ChildListener { }
