//
//  AddRestaurantView.swift
//  AddRestaurantView
//
//  Created by Vishal on 7/26/21.
//

import SwiftUI

struct AddRestaurantView: View {
    
    @StateObject var viewModel: AddRestaurantViewModel
    
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var contact: String = ""
    @State private var loading: Bool = false
    @State private var alert: Bool = false
    @State private var error: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    VStack(alignment: .center, spacing: 25) {
                        TextFieldView(placeHolder: "Name", imageName: "person", text: $name)
                        TextFieldView(placeHolder: "Address", imageName: "map", text: $address)
                        TextFieldView(placeHolder: "Contact", imageName: "candybarphone", text: $contact)
                            .keyboardType(.phonePad)
                    }
                }.padding()
                VStack {
                    if !loading {
                        Button {
                            if name == "" {
                                error = "Please enter name"
                                alert = true
                            } else if address == "" {
                                error = "Please enter address"
                                alert = true
                            }  else if contact == "" {
                                error = "Please enter contact"
                                alert = true
                            } else {
                                loading = true
                                let credentials = ["name": name,
                                                   "address": address,
                                                   "contact":contact]
                                viewModel.add(credentials)
                            }
                        } label: {
                            Text("Add")
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
                }.onReceive(viewModel.$restaurant) { restaurant in
                    DispatchQueue.main.async {
                        if loading == true {
                            loading = false
                            error = "Restuarant Added Succcessfully"
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
            }.navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Add")
        }
    }
}

struct AddRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddRestaurantView(viewModel: AddRestaurantViewModel())
        }
    }
}
