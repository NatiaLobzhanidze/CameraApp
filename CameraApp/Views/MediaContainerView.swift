//
//  MediaContainerView.swift
//  CameraApp
//
//  Created by Natia's Mac on 07.03.23.
//

import SwiftUI

struct MediaContainerView: View {
    enum Sizing {
        static let imagePickerIconSize: CGFloat = 25
        static let imagePickerCircleSize: CGFloat = 44
        static var cameraIconSize: CGFloat = 35
        static var cameraCircleSize: CGFloat = 82
        static var cameraLineLength: CGFloat = 76
        static var cameraLineWidth: CGFloat = 6
    }
    var body: some View {
        HStack{
            imagePickerView
            Spacer()
            cameraButtonView
            Spacer()
            Circle().fill(Color.clear).frame(width: 44)
        }
        .padding(.horizontal, 34)
    }
    
    private var cameraButtonView: some View {
        Button(action: {}, label: {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(
                        height: Sizing.cameraCircleSize
                    )
                Circle()
                    .stroke(Color.blue, lineWidth: Sizing.cameraLineWidth)
                    .frame(
                        height: Sizing.cameraLineLength
                    )
                
                Image("ic_camera")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        height: Sizing.cameraIconSize                    )
            }
        })
    }
    
    private var imagePickerView: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(height: Sizing.imagePickerCircleSize)
            Image("ic_picker_images")
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .frame(width: Sizing.imagePickerIconSize,
                       height: Sizing.imagePickerIconSize)
        }
    }
}
    struct MediaContainerView_Previews: PreviewProvider {
        static var previews: some View {
            MediaContainerView()
        }
    }
