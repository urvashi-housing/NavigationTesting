//
//  CarModel.swift
//  NavigationTesting
//
//  Created by Urvashi Gupta on 30/11/23.
//

import Foundation
import SwiftUI
import Combine

struct Car : Identifiable,Hashable,Codable{
    
    var id : UUID
    var company : String
    var name : String
    var modelNumber : String
    var image : Image?

    enum CodingKeys: String, CodingKey {
            case id
            case company
            case name
            case modelNumber
            case image
        }
    
    init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         id = try container.decode(UUID.self, forKey: .id)
         company = try container.decode(String.self, forKey: .company)
         name = try container.decode(String.self, forKey: .name)
         modelNumber = try container.decode(String.self, forKey: .modelNumber)
//         image = try container.decode(Image.self, forKey: .image)
     }

     func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(id, forKey: .id)
         try container.encode(company, forKey: .company)
         try container.encode(name, forKey: .name)
         try container.encode(modelNumber, forKey: .modelNumber)
//         try container.encode(image, forKey: .image)
     }
    init(id: UUID, company: String, name: String, modelNumber: String, image: Image) {
        self.id = id
        self.company = company
        self.name = name
        self.modelNumber = modelNumber
        self.image = image
    }
    static func == (lhs: Car, rhs: Car) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }
    
}

class CarViewModel : ObservableObject{
   @Published var cars : [Car] = [.init(id: UUID(), company: "Tata",name: "Nexon", modelNumber: "123",image: Image(systemName: "car")),.init(id: UUID(), company: "Mahindra",name: "Scorpio N",modelNumber: "456",image: Image(systemName: "car")),.init(id: UUID(), company: "Audi",name: "A6", modelNumber: "897",image: Image(systemName: "car"))]
    var mostTrendingCar : Car = .init(id: UUID(),company: "Mahindra",name: "Scorpio N",modelNumber: "456",image: Image(systemName: "car"))
    
    func deleteCar(){
        cars.removeLast()
    }
}

enum Route : Hashable,Codable {

    case CarDetailView(Car)
    case MoreDetailView
    
    enum CodingKeys : String,CodingKey {
        case carDetailView
        case moreDetailView
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self{
            
        case .CarDetailView(let car):
            var nestedContainer = container.nestedUnkeyedContainer(forKey: .carDetailView)
            try nestedContainer.encode(car)
        case .MoreDetailView:
            var nestedContainer = container.nestedUnkeyedContainer(forKey: .moreDetailView)
              try nestedContainer.encodeNil()
        }
        
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch container.allKeys.first.unsafelyUnwrapped {
        
        case .carDetailView:
            var nestedContainer = try container.nestedUnkeyedContainer(forKey: .carDetailView)
            self = .CarDetailView(try nestedContainer.decode(Car.self))
        case .moreDetailView:
            _ = try container.nestedUnkeyedContainer(forKey: .moreDetailView)
               self = .MoreDetailView
        }
    }
    
}

class NavigationModel: ObservableObject, Codable {
    @Published var selectedCar : Car?
    @Published var path: [Route] = []
    
    enum CodingKeys : String,CodingKey {
        case selectedCar
        case carPathIds
    }
    
    init() {
        
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(selectedCar, forKey: .selectedCar)
        try container.encode(path, forKey: .carPathIds)
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.selectedCar = try container.decodeIfPresent(Car.self, forKey: .selectedCar)
        self.path = try container.decode([Route].self, forKey: .carPathIds)
    }
    
    var jsonData : Data?{
        get {
            try? JSONEncoder().encode(self)
        }
        set {
            guard let data = newValue,
                  let model = try? JSONDecoder().decode(NavigationModel.self, from: data)
            else { return }
            self.selectedCar = model.selectedCar
            self.path = model.path
            
        }
    }

            var objectWillChangeSequence:
                AsyncPublisher<Publishers.Buffer<ObservableObjectPublisher>>
            {
                objectWillChange
                    .buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
                    .values
            }
    
}
