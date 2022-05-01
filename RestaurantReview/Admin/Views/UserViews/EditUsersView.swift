//
//  EditUsers.swift
//  RestaurantReview
//
//  Created by Vishal on 7/26/21.
//

import SwiftUI

struct EditUsersView: View {
    @StateObject var viewModel: EditUserViewModel
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var email: String = ""
    @State private var isAdmin: Bool = false
    
    @State private var loading: Bool = false
    @State private var alert: Bool = false
    @State private var error: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    VStack(alignment: .center, spacing: 25) {
                        TextFieldView(placeHolder: "First Name", imageName: "person", text: $firstname)
                        TextFieldView(placeHolder: "Last Name", imageName: "person", text: $lastname)
                        TextFieldView(placeHolder: "Email Id", imageName: "envelope", text: $email)
                        HStack {
                            Text("Gender").font(.headline)
                            HStack{
                                RadioButtonField(
                                    id: "Admin",
                                    label: "Admin",
                                    color:.blue,
                                    bgColor: .blue,
                                    isMarked: isAdmin ? true : false,
                                    callback: {
                                        isAdmin = true
                                    }
                                )
                                RadioButtonField(
                                    id: "Normal",
                                    label: "Normal",
                                    color:.blue,
                                    bgColor: .blue,
                                    isMarked: isAdmin ? false : true,
                                    callback: {
                                        isAdmin = false
                                    }
                                )
                            }
                            Spacer()
                        }
                        
                    }
                }.padding()
                VStack {
                    if !loading {
                        Button {
                            if valid() {
                                loading = true
                                let credentials = ["first_name": firstname,
                                                   "last_name": lastname,
                                                   "email": email,
                                                   "is_staff": isAdmin,
                                                   "is_superuser": isAdmin] as [String : Any]
                                viewModel.edit(credentials)
                            } else {
                                loading = false
                            }
                        } label: {
                            Text("Update")
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
                }.onReceive(viewModel.$user) { user in
                    DispatchQueue.main.async {
                        if loading == true {
                            loading = false
                            error = "User Updated Succcessfully"
                            self.presentationMode.wrappedValue.dismiss()
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
                Spacer()
            }.onAppear {
                self.firstname = viewModel.user.firstname ?? ""
                self.lastname = viewModel.user.lastname ?? ""
                self.email = viewModel.user.email ?? ""
                self.isAdmin = (viewModel.user.is_superuser ?? false) && (viewModel.user.is_staff ?? false)
            }.navigationBarTitleDisplayMode(.inline)
                .navigationTitle(viewModel.user.username ?? "Edit")
        }
    }
    
    func valid() -> Bool {
        if firstname == "" {
            self.error = "Please enter first name"
            return false
        } else if lastname == "" {
            self.error = "Please enter last name"
            return false
        } else if email == "" {
            self.error = "Please enter email"
            return false
        } else {
            return true
        }
    }
}
struct EditUsers_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditUsersView(viewModel: EditUserViewModel(user: UserModel(id: 1, firstname: "vishal", lastname: "vishal", email: "vishal@gmail.com", token: "", username: nil, is_superuser: true, is_staff:true)))
        }
    }
}


//MARK:- Radio Button Field
struct RadioButtonField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let bgColor: Color
    let textSize: CGFloat
    let isMarked:Bool
    let callback: ()->()
    
    init(
        id: String,
        label:String,
        size: CGFloat = 20,
        color: Color = Color.black,
        bgColor: Color = Color.black,
        textSize: CGFloat = 14,
        isMarked: Bool = false,
        callback: @escaping ()->()
    ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.bgColor = bgColor
        self.textSize = textSize
        self.isMarked = isMarked
        self.callback = callback
    }
    
    var body: some View {
        Button(action:{
            self.callback()
        }) {
            HStack(alignment: .center) {
                Image(systemName: self.isMarked ? "largecircle.fill.circle" : "circle")
                    .clipShape(Circle())
                    .foregroundColor(self.bgColor)
                Text(label)
                    .font(Font.system(size: textSize))
            }.foregroundColor(self.color)
        }
        .foregroundColor(Color.white)
    }
}
