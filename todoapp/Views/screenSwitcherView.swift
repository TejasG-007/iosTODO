//
//  screenSwitcherView.swift
//  todoapp
//
//  Created by Tejas on 24/08/24.
//

import SwiftUI



struct ScreenSwitcher:View {
    
    @EnvironmentObject var user:LoginOrRegisterViewModel
    
    
    
    var body: some View {
        
        NavigationStack(path:$user.navigationPath){
            if user.loginState == .Success {
                HomeView()
            }else{
                LoginView()
            }
        }
    }
}


