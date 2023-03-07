//
//  ContentView.swift
//  CameraApp
//
//  Created by Natia's Mac on 07.03.23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = ContentViewModel()
    var body: some View {
        ZStack {
            CameraViewContainer()
            VStack {
                Spacer()
                MediaContainerView()
                Color.clear.frame(height: 16)
                InstrumentsView()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


