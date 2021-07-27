//
//  RestaurantDetailsView.swift
//  RestaurantDetailsView
//
//  Created by Vishal on 7/22/21.
//

import SwiftUI

struct RestaurantDetailsView: View {
    
    @StateObject var viewModel: RestaurantDetailsViewModel
    @State private var clickAddReview: Bool = false
    @State private var isAsc: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                VStack {
                    Image("restaurant")
                        .resizable()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 200, maxHeight: 200, alignment: .center)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(viewModel.restaurant.name ?? "")
                            .bold()
                            .font(.system(size: 20))
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.blue)
                        Text(viewModel.restaurant.address ?? "")
                            .font(.system(size: 15))
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.red)
                        Text(viewModel.restaurant.contact ?? "")
                            .font(.system(size: 15))
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(viewModel.restaurant.avgRating)
                            .font(.system(size: 15))
                        Spacer()
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .padding([.leading,.trailing], 5)
                
                VStack(alignment: .center, spacing: 10) {
                    HStack {
                        Text("Reviews")
                            .bold()
                            .font(.system(size: 20))
                        Button {
                            isAsc.toggle()
                            viewModel.sort(isAsc)
                        } label: {
                            Image(systemName: "arrow.up.arrow.down.circle")
                                .resizable()
                                .frame(width: 25, height: 25, alignment: .center)
                        }
                        Spacer()
                        Button {
                            self.clickAddReview = true
                        } label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 25, height: 25, alignment: .center)
                        }
                        Spacer().frame(width: 10, alignment: .center)
                        NavigationLink(destination: AddReviewsView(viewModel: AddReviewViewModel(restaurant: viewModel.restaurant, userModel: viewModel.userModel)), isActive: $clickAddReview) {
                            EmptyView()
                        }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .padding([.leading,.trailing], 8)
                
                VStack(alignment: .center, spacing: 0) {
                    if viewModel.comments.count == 0 {
                        VStack{
                            Spacer()
                            Text("No reviews")
                                .bold()
                                .font(.system(size: 20))
                            Spacer()
                        }.frame(height: 250, alignment: .center)
                    } else {
                        List {
                            ForEach(viewModel.comments) { comment in
                                CommentsCellView(comment: comment)
                            }
                        }
                        .scaledToFill()
                        .listStyle(PlainListStyle())
                    }
                }
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle(viewModel.restaurant.name ?? "Details")
        }.onAppear(perform: {
            viewModel.fetchComments()
        })
    }
    
}

struct CommentsCellView: View {
    
    var comment: CommentsModel {
        didSet {
            rating = comment.rating
        }
    }
    
    @State private var rating: Int?
    
    var body: some View {
        VStack (alignment: .leading, spacing: 5){
            Text(comment.fullname ?? "")
                .bold()
                .font(.system(size: 15))
            HStack {
                RatingView(rating: $rating, max: 5)
                    .frame(width: 100, height: 15, alignment: .center)
                    .disabled(true)
                Text(comment.localDate)
                    .font(.system(size: 15))
                
            }
            Text(comment.comment ?? "")
                .font(.system(size: 15))
        }.onAppear {
            rating = comment.rating
        }
    }
}


struct RestaurantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RestaurantDetailsView(viewModel: RestaurantDetailsViewModel(restaurant: RestaurantModel(id: 1, name: "Tacos", avg: 4, address: "Paris", contact: "+33 75 38 40 37 4"), userModel: UserModel(id: 1, firstname: "", lastname: "", email: "", token: "", username: "", is_superuser: false, is_staff: false)))
        }
    }
}
