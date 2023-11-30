//
//  ContentView.swift
//  NavigationTesting
//
//  Created by Urvashi Gupta on 30/11/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CarViewModel()
    @StateObject var navModel = NavigationModel()
    @SceneStorage("nav") private var data:Data?
    var body: some View {
        NavigationStack(path: $navModel.path){
            List(viewModel.cars,selection: $navModel.selectedCar){ car in
                NavigationLink(value: Route.CarDetailView(car))
                { HStack{
                    Text(car.name)
                    Spacer()
                    car.image
                }
                }
            }
            
            Button(action: {
                navToMostTrendingCar()
            }, label: {
                Text("Most Trending Car")
            })
            .frame(height: 50)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .CarDetailView(let car):
                    CarDetailView(car: car,viewModel: viewModel,path: $navModel.path)
                case .MoreDetailView:
                    MoreDetailView(path: $navModel.path)
                }
            }
           
        }
        .task {
            if let data = data{
                navModel.jsonData = data
            }
            for await _ in navModel.objectWillChangeSequence{
                data = navModel.jsonData
            }
        }
    }
    func navToMostTrendingCar(){
        navModel.path = [Route.CarDetailView(viewModel.mostTrendingCar)]
    }
}



#Preview {
    ContentView()
}
