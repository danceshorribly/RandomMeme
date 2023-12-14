//
//  ContentView.swift
//  RandomMeme
//
//  Created by Oscar Byhlinder on 2023-12-14.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var memeAPI = MemeAPI()

    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text(memeAPI.memeName)
                .font(.headline)
                .padding()
            
            AsyncImage(url: URL(string: memeAPI.memeURL)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                         .aspectRatio(contentMode: .fill)
                case .empty:
                    Rectangle()
                        .foregroundColor(.gray)
                        .overlay(
                            ProgressView()
                        )
                case .failure:
                    Text("Kunde inte ladda meme")
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 300, height: 300)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()

            Button("Ladda Meme") {
                Task {
                    await memeAPI.loadAPI()
                }
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.black)
            .cornerRadius(5)
        }
        .onAppear() {
            Task {
                await memeAPI.loadAPI()
            }
        }
        
    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
