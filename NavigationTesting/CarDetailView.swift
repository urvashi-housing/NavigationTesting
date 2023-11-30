//
//  CarDetailView.swift
//  NavigationTesting
//
//  Created by Urvashi Gupta on 30/11/23.
//

import SwiftUI

struct CarDetailView: View {
    var car : Car
    var viewModel : CarViewModel
    @Binding var path : [Route]
    var body: some View {
        NavigationLink(value : Route.MoreDetailView){
            Text("Move To More Detail view")
        }
        .navigationTitle("\(car.company) : \(car.name)")

        Button(action: {
            viewModel.deleteCar()
        }, label: {
            Text("Remove one Car")
        })
    }
}

#Preview {
    NavigationStack{
        CarDetailView(car: CarViewModel().cars[0], viewModel: CarViewModel(),path: .constant([Route.CarDetailView(CarViewModel().cars[0])]))
    }
}
