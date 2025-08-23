//
//  Buildable.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//


protocol SplashBuildable {
    func build(listener: SplashViewModelListener) -> any ViewableRoutable
}
