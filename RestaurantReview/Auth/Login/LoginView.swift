//
//  ContentView.swift
//  RestaurantReview
//
//  Created by Vishal on 7/22/21.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = SignInViewModel()
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var alert: Bool = false
    @State private var error: String = ""
    @State private var loading: Bool = false
    @State private var registerClick: Bool = false
    @State private var moveToSuccess: Bool = false
    @State private var moveToAdmin: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing:10) {
                VStack {
                    Image("backgroundImage")
                        .resizable()
                        .frame(width:geo.size.width, height: geo.size.height/3, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                }.frame(width: geo.size.width, height: geo.size.height/3, alignment: .center)
                VStack {
                    VStack {
                        Text("Welcome back!").font(.title).bold()
                        Text("Login your existing account")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                    VStack {
                        VStack(alignment: .center, spacing: 25) {
                            TextFieldView(placeHolder: "Username", imageName: "person", text: $username)
                            TextFieldView(placeHolder: "Password", imageName: "lock", text: $password, isSecure: true)
                        }
                    }.padding()
                    VStack {
                        if !loading {
                            NavigationLink(destination: RestaurantListView(viewModel: RestaurantViewModel(userModel: (viewModel.tokenModel?.user)!)), isActive: $moveToSuccess) {
                                EmptyView()
                            }
                            
                            NavigationLink(destination: AdminHomeView(userModel: viewModel.tokenModel?.user ?? nil), isActive: $moveToAdmin) {
                                EmptyView()
                            }
                            
                            Button {
                                if username == "" {
                                    error = "Please enter username"
                                    alert = true
                                } else if password == "" {
                                    error = "Please enter password"
                                    alert = true
                                } else {
                                    loading = true
                                    let credentials = ["username": username,
                                                       "password": password]
                                    viewModel.login(credentials)
                                }
                            } label: {
                                Text("LOG IN")
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(width: 150, height: 45, alignment: .center)
                                    .background(Color.blue)
                                    .font(.system(size: 13.0))
                                    .cornerRadius(45, antialiased: false)
                            }
                            .alert(isPresented: $alert, title: "", message: error)
                            .background(Color.blue)
                            .cornerRadius(45, antialiased: true)
                        } else {
                            Spinner()
                                .frame(width: 45, height: 45, alignment: .center)
                        }
                    }.onReceive(viewModel.$tokenModel) { user in
                        DispatchQueue.main.async {
                            guard let user = user else { return }
                            loading = false
                            if user.key == nil {
                                error = "Invalid credentials"
                                alert = true
                            } else {
                                if registerClick == false {
                                    if let is_superuser = user.user?.is_superuser, is_superuser == true {
                                        moveToAdmin = true
                                    } else {
                                        moveToSuccess = true
                                    }
                                }
                            }
                        }
                    }.onReceive(viewModel.$error) { error in
                        guard let error = error else { return }
                        DispatchQueue.main.async {
                            self.error = error
                            alert = true
                            loading = false
                        }
                    }
                }.frame(width: geo.size.width, height: geo.size.height/2, alignment: .center)
                VStack {
                    Spacer()
                    HStack(alignment: .center, spacing: 0) {
                        Text("Don't have an account? ")
                            .font(.system(size: 15.0))
                        Text("Sign Up")
                            .bold()
                            .font(.system(size: 15.0))
                            .foregroundColor(.blue)
                            .onTapGesture {
                                self.registerClick = true
                                loading = false
                            }
                        NavigationLink(destination: SignUpView(), isActive: $registerClick) {
                            EmptyView()
                        }
                    }.padding(20)
                }
                .frame(width: geo.size.width, height: 50, alignment: .center)
                //Spacer().frame(height:50)
            }
            .frame(minWidth:0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .center)
            .ignoresSafeArea()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct TextFieldView: View {
    
    var placeHolder: String
    var imageName: String
    @Binding var text: String
    var isSecure = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Image(systemName: imageName)
                .foregroundColor(.blue)
            
            if isSecure {
                SecureField(placeHolder, text: $text)
                    .frame(height: 50, alignment: .center)
                    .font(.system(size: 15.0))
                    .foregroundColor(.blue)
            }else {
                TextField(placeHolder, text: $text)
                    .frame(height: 50, alignment: .center)
                    .font(.system(size: 15.0))
                    .foregroundColor(.blue)
            }
        }
        .padding([.leading, .trailing], 20)
        .overlay(
            RoundedRectangle(cornerRadius: 35)
                .stroke(Color.blue, lineWidth: 2)
        )
        .background(Color.white)
        .cornerRadius(35)
        
    }
}

public extension View {
    func alert(isPresented: Binding<Bool>,
               title: String,
               message: String? = nil,
               dismissButton: Alert.Button? = nil) -> some View {
        
        alert(isPresented: isPresented) {
            Alert(title: Text(title),
                  message: {
                    if let message = message { return Text(message) }
                    else { return nil } }(),
                  dismissButton: dismissButton)
        }
    }
}
