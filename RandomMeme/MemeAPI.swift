//
//  MemeApi.swift
//  RandomMeme
//
//  Created by Oscar Byhlinder on 2023-12-14.
//

import Foundation

struct PulledMeme: Codable {
    var id: String
    var name: String
    var url: String
    var width: Int
    var height: Int
    var box_count: Int
}

struct MemeResponse: Codable {
    struct Data: Codable {
        let memes: [PulledMeme]
    }
    let success: Bool
    let data: Data
}

class MemeAPI: ObservableObject {
    @Published var memeURL = ""
    @Published var memeName = ""

    func loadAPI() async {
        let url = URL(string: "https://api.imgflip.com/get_memes")!

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(MemeResponse.self, from: data)

            // Show a random meme from imgflip api
            if let randomMeme = response.data.memes.randomElement() {
                DispatchQueue.main.async {
                    self.memeURL = randomMeme.url
                    self.memeName = randomMeme.name
                }
            } else {
                print("Inget meme hittades")
            }
        } catch {
            print("Fel vid hämtning av meme: \(error)")
        }
    }
}

