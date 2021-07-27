//
//  EditReviewsView'.swift
//  RestaurantReview
//
//  Created by Vishal on 7/26/21.
//

import SwiftUI

struct EditReviewsView: View {
    
    @StateObject var viewModel: AdminEditReviewViewModel
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
                            viewModel.edit(comment)
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
                }.onReceive(viewModel.$error) { error in
                    guard let error = error else { return }
                    DispatchQueue.main.async {
                        self.error = error
                        alert = true
                        loginClick = false
                    }
                }
                .onReceive(viewModel.$review) { review in
                    DispatchQueue.main.async {
                        if loginClick == true {
                            loginClick = false
                            error = "Review Updated Succcessfully"
                            DispatchQueue.main.async {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }
                
                Spacer()
            }.padding(16)
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                self.user = viewModel.review.user
                self.restaurant = viewModel.restaurants.first(where: { restaurant in
                    return restaurant.id == viewModel.review.restaurant
                })
                self.rating = viewModel.review.rating
                self.fullText = viewModel.review.comment ?? ""
                self.dateOfVisit = viewModel.review.dateFormate
            })
        }
    }
}

struct EditReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditReviewsView(viewModel: AdminEditReviewViewModel(review: CommentsModel(id: 1)))
        }
    }
}
