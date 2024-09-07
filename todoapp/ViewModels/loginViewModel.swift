//
//  loginViewModel.swift
//  todoapp
//
//  Created by Tejas on 19/08/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class LoginOrRegisterViewModel: ObservableObject{
    @Published var email:String = ""
    @Published var password:String = ""
    @Published var firstName:String = ""
    @Published var lastName:String = ""
    @Published var error:String = ""
    @Published var isLoading:Bool = false
    @Published var loginState:LoginState = LoginState.Unavailable
    @Published var userInfo:UserInfo? = nil
    @Published var currentUser:User? = nil
    @Published var navigationPath:[NavigatingPaths] = []
    
    
    
    func insertValueIntoDb(userId:String,emailId:String,firstName:String,lastName:String){
        
        userInfo = UserInfo(userId: userId, emailId: emailId, firstName: firstName, lastName:lastName)
        
    }
    
    func registerUser(isLogin:Bool)async throws{
        guard validate(isLogin: isLogin) else {
            throw AuthError.ScreenValidationError
        }
        do{
            self.setLoading(isLoading: true)
            let result:AuthDataResult =  try await Auth.auth().createUser(withEmail: self.email.lowercased(), password: self.password)
            if(!result.user.uid.isEmpty){
                self.currentUser = result.user
                let changeUserProfile = self.currentUser?.createProfileChangeRequest()
                changeUserProfile?.displayName = self.firstName
                changeUserProfile?.commitChanges{ error in if let error = error{
                    print("Error While Adding First Name \(error.localizedDescription)")
                }else{
                    print("Profile Modification Completed")
                }
                    
                }
                insertValueIntoDb(userId:result.user.uid, emailId: self.email, firstName:self.firstName, lastName: self.lastName)
                navigationPath.removeAll()
                loginState = LoginState.Success
                
            }
            self.setLoading(isLoading: false)
        }catch{
            self.clearAllData()
            self.loginState = .Failed
            self.setLoading(isLoading: false)
            print("Error from Register  \(error.localizedDescription)")
            throw AuthError.RegisterError
        }
    }
    
    func loginUser(isLogin:Bool)async throws{
        guard validate(isLogin: isLogin) else {
            throw AuthError.ScreenValidationError
        }
        do{
            self.setLoading(isLoading: true)
            let result:AuthDataResult = try await Auth.auth().signIn(withEmail: self.email.lowercased(), password: self.password)
            if (!result.user.uid.isEmpty){
                self.currentUser = result.user
                insertValueIntoDb(userId: result.user.uid, emailId:result.user.email ?? "", firstName: result.user.displayName ?? "", lastName:result.user.displayName ?? "")
                print("Logged In")
                loginState = LoginState.Success
            }
            self.setLoading(isLoading: false)
        }catch{
            self.clearAllData()
            self.loginState = .Failed
            self.setLoading(isLoading: false)
            print("Error from Login \(error.localizedDescription)")
            throw AuthError.LoginError
        }
    }
    
    
    
    
    func setError(error:String)->Void{
        DispatchQueue.main.async {
            self.error = error
        }
    }
    
    func setLoading(isLoading:Bool){
        DispatchQueue.main.async{
            self.isLoading = isLoading
        }
    }
    
    
    func clearAllData()->Void{
        currentUser = nil
        userInfo = nil
        self.email.removeAll()
        self.password.removeAll()
        self.firstName.removeAll()
        self.lastName.removeAll()
        self.loginState = LoginState.Unavailable
        self.navigationPath.removeAll()
    }
    
    
    
    func validate(isLogin:Bool=false)->Bool{
        setError(error: "")
        if(!email.contains("@") && !email.contains(".")){
            setError(error: "Please enter valid email")
            return false
        }
        
        if(isLogin){
            if(
                self.email.trimmingCharacters(in: .whitespaces).isEmpty ||
                self.password.trimmingCharacters(in: .whitespaces).isEmpty
            ){
                setError(error:"Please fill in all fields" )
                return false
            }else{
                
            }
        }else{
            if(self.firstName.trimmingCharacters(in: .whitespaces).isEmpty ||
               self.lastName.trimmingCharacters(in: .whitespaces).isEmpty){
                setError(error: "Please fill in first/last names fields")
            }else if(
                self.email.trimmingCharacters(in: .whitespaces).isEmpty ||
                self.password.trimmingCharacters(in: .whitespaces).isEmpty
            ){
                setError(error: "Please fill in email/password fields")
                return false
            }
        }
        return true
    }
    
    
    func logoutUser() throws{
        do{
            try Auth.auth().signOut()
            clearAllData()
        }catch{
            print("Issue while logging out \(error.localizedDescription)")
        }
        
    }
    
    
    
}


enum AuthError:Error{
    case RegisterError
    case LoginError
    case ScreenValidationError
}

enum LoginState{
    case Unavailable
    case Success
    case Failed
}


enum NavigatingPaths{
    case LoginScreen
    case RegisterScreen
    case HomeScreen
}
