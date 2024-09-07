//
//  ContentView.swift
//  todoapp
//
//  Created by Tejas on 12/08/24.
//

import SwiftUI

enum StartingViewsEnums{
    case LoginViewEnum
    case RegisterViewEnum
}




struct CustomLoginAndRegisterView: View {
    
    @State private var email:String = ""
    @State private var password:String = ""
    @State private var firstName:String = ""
    @State private var lastName:String = ""
    
    
    let angle:Double
    let buttonText:String
    let title:String
    let subtitle:String
    let backgroundColor:Color
    let isLoginView:Bool
    
    @EnvironmentObject var login_register_ViewModel:LoginOrRegisterViewModel
    
    var showAlert:Bool {
        return login_register_ViewModel.loginState == .Failed
    }
    
    var body: some View{
        
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius:0).foregroundColor(backgroundColor).rotationEffect(Angle(degrees:angle))
                VStack{
                    Rectangle().frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/).opacity(0)
                    Text(title).font(.system(size: 50)).foregroundColor(.white).bold()
                    Text(subtitle).foregroundColor(.white).bold()
                    
                }
            }.frame(width: UIScreen.main.bounds.width*3,height:   350 ).offset(y:isLoginView ? -140 : -160)
            
            Spacer()
            Form{
                
                login_register_ViewModel.error.isEmpty ? nil : Text("\(login_register_ViewModel.error)").foregroundColor(.red).padding(4)
                
                isLoginView ? nil : TextField("First Name",text: $login_register_ViewModel.firstName).textFieldStyle(RoundedBorderTextFieldStyle())
                isLoginView ? nil : TextField("Last Name",text: $login_register_ViewModel.lastName).textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Email",text: $login_register_ViewModel.email).keyboardType(.emailAddress).textInputAutocapitalization(.never
                ).textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password",text: $login_register_ViewModel.password).textFieldStyle(RoundedBorderTextFieldStyle())
                
                
                Button{
                    
                    Task{
                        
                        do{
                            if isLoginView{
                                try await  login_register_ViewModel.loginUser(isLogin:true)
                                
                            }else {
                                try await login_register_ViewModel.registerUser(isLogin:false)
                            }
                        }catch{
                            
                            print("Error \(error.localizedDescription)")
                            
                        }
                        
                    }
                } label: {
                    if login_register_ViewModel.isLoading {
                        HStack{
                            Spacer()
                            ProgressView().progressViewStyle(.circular)
                            Spacer()
                        }
                    }
                    else{ZStack{
                        RoundedRectangle(cornerRadius: 10).foregroundColor(isLoginView ? .blue : .green)
                        Text(buttonText).foregroundColor(.white).bold()
                    }}
                }
            }
            
            VStack{
                if(isLoginView){
                    Text("New around here").padding(5)
                    
                    Button( "Create An Account" ){
                        login_register_ViewModel.navigationPath.append(NavigatingPaths.RegisterScreen)
                    }
                }
                
            }.padding(.bottom,50)
            Spacer()
        }.alert(isPresented: .constant(showAlert), content: {
            Alert(title: Text("Error while \(isLoginView ? "Logging" : "Registering")"),dismissButton: .default(Text("OK"),action: {
                login_register_ViewModel.clearAllData()
            }))
        }).navigationDestination(for: NavigatingPaths.self){
            
            path in
            if path == .RegisterScreen{
                RegistrationView()
            }
            
        }
    }
    
}



struct RegistrationView:View ,Hashable{
    
    var body: some View {
        CustomLoginAndRegisterView(angle: 20.0, buttonText: "Register", title:"Register",subtitle:"Start Organizing Todo's", backgroundColor:Color.yellow,isLoginView: false)
    }
}
struct LoginView:View ,Hashable{
    var body: some View {
        CustomLoginAndRegisterView(angle: -20.0, buttonText: "Log In", title:"To Do List",subtitle:"Get things done", backgroundColor:Color.red,isLoginView: true)
    }
}
