//
//  AddReviews.swift
//  AddReviews
//
//  Created by Vishal on 7/23/21.
//

import SwiftUI


struct AddReviewsView: View {
    
    @StateObject var viewModel: AddReviewViewModel
    @State private var rating: Int?
    @State private var fullText: String = ""
    @State private var dateOfVisit = Date()
    @State var loginClick: Bool = false
    @State private var alert: Bool = false
    @State var error: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            VStack{
                Text(viewModel.restaurant.name ?? "")
                    .bold()
                    .font(.system(size: 20))
                Text(viewModel.restaurant.address ?? "")
                    .font(.system(size: 13.0))
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
                Spacer().frame(height: 10, alignment: .center)
                let partial = PartialRangeThrough(Date())
                DatePicker(selection: $dateOfVisit, in: partial, displayedComponents: [.date], label: { Text("Date of visit").bold() }).frame(height: 20, alignment: .center)
            }
            
            VStack {
                Spacer()
                if !loginClick {
                    Button {
                        loginClick = true
                        let comment = ["rating": rating ?? 0,
                                       "comment": fullText,
                                       "date" : dateOfVisit.unixDate,
                                       "restaurant": viewModel.restaurant.id ?? "",
                                       "user": viewModel.userModel.id ?? ""] as [String : Any]
                        viewModel.comments(comment)
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
        }.padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddReviews_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddReviewsView(viewModel: AddReviewViewModel(restaurant: RestaurantModel(id: 1, name: "Hotel Taj Mahal", avg: 4.5, address: "Paris", contact: "0753840374"), userModel: UserModel(id: 1, firstname: "", lastname: "", email: "", token: "", username: "", is_superuser: false, is_staff: false)))
        }
    }
}


extension Date {
    var unixDate: Int {
        return Int(self.timeIntervalSince1970)
    }
}
