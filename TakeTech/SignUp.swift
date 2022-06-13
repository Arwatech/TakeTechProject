//
//  SignUp.swift
//  TakeTechSH
//
//  Created by Shahad Alkamli on 31/05/2022.
//


import AuthenticationServices
import SwiftUI

struct SignUp: View {
    
    
    @State var email = ""
    @State var pass = ""
    
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        
        
        
        VStack{
            
            
            Text("TakeTech")
                .font(.largeTitle)
                .padding(.vertical, 60.0)
            
            
            
            mailView(email: email)
            
            passView(pass: pass)
            
            
            
            VStack{
            
            
                Button (action: {} ){

                    Text("Sign Up")
                        .foregroundColor(.black)
                        .frame(width: 250, height: 15)
                        .padding(.all)
                }
                
                .background(Color("blue"))
                .cornerRadius(4)
                
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            // OR
            
            HStack{
                
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                    .opacity(0.5)
                    .padding(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                
                Text("OR")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                    .opacity(0.5)
                
                
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                    .opacity(0.5)
                    .padding(/*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                
            }
            
                //sign up with apple
                SignInWithAppleButton(.signUp, onRequest: configure, onCompletion: handle)
                
                    .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                    .frame(width: 285, height: 47)
                    .cornerRadius(4)
                    .padding(.all)
                         
            
                
            
            HStack{
                Text("Already have an account? ")
                    .font(.footnote)
                
                Text("Login")
                    .font(.footnote)
                
                    .foregroundColor(Color("MyYellow"))
                    .underline()
                
                
            }    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

            
            
            // I agree ...
            
            
            VStack{
                Text("By clicking Sign up or Sign up with Apple, you agree to our")
                
                    .frame(width: 330, height: 50, alignment: .leading)
                       .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(.footnote)
                    .multilineTextAlignment(.center)

                    .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .trailing]/*@END_MENU_TOKEN@*/)
                
                
                Button(action: {} , label:{
                    
                    
                    
                    
                    
                    Text( "Terms and Conditions")
                    
                        .foregroundColor(Color("MyYellow"))
                        .font(.footnote)
                    
                    
                        .underline()
                        .multilineTextAlignment(.center)
                })
                
                
            }
            

                
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .padding(/*@START_MENU_TOKEN@*/.top, 16.0/*@END_MENU_TOKEN@*/)

            
            Spacer()

            
        }
        
        
        
    }
    
    
}



struct passView: View {
    
    
    @State var pass: String
    
    var body: some View {
        VStack{
            
            
            Text("Password")
                .frame( maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 15){
                
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
                
                SecureField("***********", text: self.$pass)
                
                Image(systemName: "eye.slash.fill")
                    .foregroundColor(.gray)
                
            }
            .padding(.vertical, 8.0)
            
            Divider().background(Color.white.opacity(0.5))
            
            
        }
        
        .padding(.horizontal, 32.0)
        .padding(.top,40)
    }
}



struct mailView: View{
    
    
    @State var email: String
    
    var body: some View {
    
    
    VStack{
        
        Text("Email")
            .frame( maxWidth: .infinity, alignment: .leading)
        
        
        HStack(spacing: 15){
            
            Image(systemName: "envelope.fill")
                .foregroundColor(.gray)
            
            TextField("you@example.com", text: self.$email)
            
            
        }
        
        .padding(.vertical, 8.0)
        
        Divider().background(Color.white.opacity(0.5))
        
    }
    
    .padding(.horizontal, 32.0)
    .padding(.top, 1.0)
        
    }
    
}




struct AppleUser: Codable {
    
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
    
    init?(credentials: ASAuthorizationAppleIDCredential){
        
        guard
            let firstName = credentials.fullName?.givenName,
            let lastName = credentials.fullName?.familyName,
            let email = credentials.email
        else{return nil}
        
        self.userId = credentials.user
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}


    func configure(_ request: ASAuthorizationAppleIDRequest){
        
        request.requestedScopes = [.fullName, .email]
        //        request.nonce = ""
        
    }
    
    func handle(_ authResult: ( Result<ASAuthorization, Error>)){
        
        switch authResult {
        case.success(let auth):
            print(auth)
            
            switch auth.credential{
            case let appleIdCredentials as ASAuthorizationAppleIDCredential:
                
                if let appleUser = AppleUser(credentials: appleIdCredentials),
                   let appleUserDate = try? JSONEncoder().encode(appleUser)
                {
                    UserDefaults.standard.setValue(appleUserDate, forKey: appleUser.userId)
                    
                    print("saved apple user", appleUser)
                } else{
                    print("missing some fields",appleIdCredentials.email, appleIdCredentials.fullName, appleIdCredentials.user)
                    
                    guard
                        let appleUserData = UserDefaults.standard.data(forKey: appleIdCredentials.user),
                        let appleUser = try? JSONDecoder().decode(AppleUser.self, from: appleUserData)
                            
                    else { return }
                    
                    print(appleUser)
                }
                
            default:
                print(auth.credential)
                
                
            }
        case.failure(let error):
            print(error)
            
        }
        
    }
    



struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
        
            .preferredColorScheme(.dark)
        
    }
}


