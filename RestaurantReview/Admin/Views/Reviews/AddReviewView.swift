//
//  AddReviewView.swift
//  RestaurantReview
//
//  Created by Vishal on 7/26/21.
//

import SwiftUI

struct AddReviewView: View {
    
    
    @StateObject var viewModel: AdminAddReviewViewModel
    @State private var restaurant: RestaurantModel? = nil
    @State private var user: UserModel? = nil
    @State private var rating: Int?
    @State private var fullText: String = ""
    @State private var dateOfVisit = Date()
    @State var loginClick: Bool = false
    @State private var alert: Bool = false
    @State var error: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20){
                VStack(alignment: .leading, spacing: 5){
                    Text("Please select restaurant")
                        .bold()
                        .font(.system(size: 15.0))
                    DropdownRestaurantView(items: viewModel.restaurants, item: $restaurant)
                }
                
                VStack(alignment: .leading, spacing: 5){
                    Text("Please select user")
                        .bold()
                        .font(.system(size: 15.0))
                    DropdownUserView(items: viewModel.users, item: $user)
                }
                
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("Reviews")
                        .bold()
                        .font(.system(size: 15))
                    RatingView(rating: $rating, max: 5)
                        .frame(width: 180, height: 30, alignment: .center)
                    
                }
                
                VStack {
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Comment")
                            .bold()
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 13.0))
                    }.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    VStack {
                        TextEditor(text: $fullText)
                    }
                    .padding(5)
                    .frame(height: 100, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                    
                }
                
                VStack {
                    let partial = PartialRangeThrough(Date())
                    DatePicker(selection: $dateOfVisit, in: partial, displayedComponents: [.date], label: { Text("Date of visit").bold() }).frame(height: 20, alignment: .center)
                }
                
                VStack {
                    Spacer().frame(height:50)
                    if !loginClick {
                        Button {
                            loginClick = true
                            let comment = ["rating": rating ?? 0,
                                           "comment": fullText,
                                           "date" : dateOfVisit.unixDate,
                                           "restaurant": restaurant?.id ?? 0,
                                           "user": user?.id ?? 0] as [String : Any]
                            viewModel.postComment(comment)
                        } label: {
                            Text("Submit")
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 150, height: 45, alignment: .center)
                                .background(Color.blue)
                                .font(.system(size: 15.0))
                                .cornerRadius(45, antialiased: false)
                        }.alert(isPresented: $alert, title: "", message: error)
                    } else {
                        Spinner()
                            .frame(width: 45, height: 45, alignment: .center)
                    }
                    Spacer()
                }.onReceive(viewModel.$comment) { comment in
                    loginClick = false
                    guard comment != nil else { return }
                    presentationMode.wrappedValue.dismiss()
                }.onReceive(viewModel.$error) { error in
                    guard let error = error else { return }
                    DispatchQueue.main.async {
                        self.error = error
                        alert = true
                        loginClick = false
                    }
                }
                
                Spacer()
            }.padding(16)
            .navigationTitle("Add")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddReviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddReviewView(viewModel: AdminAddReviewViewModel())
        }
    }
}

struct DropdownRestaurantView: View {
    
    var items: [RestaurantModel]
    @Binding var item: RestaurantModel?
    
    @State private var isExpanded: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            DisclosureGroup(item?.name ?? "Restaurants", isExpanded: $isExpanded) {
                ScrollView{
                    Spacer()
                    Spacer()
                    Spacer()
                    VStack{
                        ForEach(items) { item in
                            Divider().frame(height: 1, alignment: .center).background(Color.red)
                            AdminRestaurantCellView(restaurant: item)
                                .onTapGesture {
                                    self.item = item
                                    withAnimation {
                                        isExpanded.toggle()
                                    }
                                }.padding()
                            
                        }
                    }
                }.frame(height:300)
            }
            .accentColor(.blue)
            .font(.system(size: 15.0))
            .foregroundColor(.blue)
            .padding(.all)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10.0)
        }
    }
}


struct DropdownUserView: View {
    
    var items: [UserModel]
    @Binding var item: UserModel?
    
    @State private var isExpanded: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            DisclosureGroup(item?.fullname ?? "Users", isExpanded: $isExpanded) {
                ScrollView{
                    Spacer()
                    Spacer()
                    Spacer()
                    VStack{
                        ForEach(items) { item in
                            Divider().frame(height: 1, alignment: .center).background(Color.red)
                            AdminUserCellView(user: item)
                                .onTapGesture {
                                    self.item = item
                                    withAnimation {
                                        isExpanded.toggle()
                                    }
                                }.padding()
                            
                        }
                    }
                }.frame(height:300)
            }
            .accentColor(.blue)
            .font(.system(size: 15.0))
            .foregroundColor(.blue)
            .padding(.all)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10.0)
        }
    }
}
