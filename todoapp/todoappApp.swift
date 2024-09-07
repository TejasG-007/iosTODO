//
//  todoappApp.swift
//  todoapp
//
//  Created by Tejas on 12/08/24.
//
import FirebaseCore
import SwiftUI



@main
struct todoappApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var userGlobal = LoginOrRegisterViewModel()

    var body: some Scene {
        WindowGroup {
            ScreenSwitcher().environmentObject(userGlobal)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
