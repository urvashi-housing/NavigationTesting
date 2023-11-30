//
//  MoreDetailView.swift
//  NavigationTesting
//
//  Created by Urvashi Gupta on 30/11/23.
//

import SwiftUI

struct MoreDetailView: View {
    @Binding var path : [Route]
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button(action: {
            backToMainScreen()
        }, label: {
            Text("Back To Main Screen")
        })
    }
    
    func backToMainScreen(){
        path.removeAll()
    }
}

#Preview {
    MoreDetailView(path: .constant([]))
}
