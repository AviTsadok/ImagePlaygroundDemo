//
//  ContentView.swift
//  ImagePlaygroundDemo
//
//  Created by Avi Tsadok on 20/06/2025.
//

import SwiftUI
import ImagePlayground


struct ContentView: View {
    @State private var prompt: String = ""
    @State private var generatedImage: CGImage? = nil
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(spacing: 24) {
            TextField("prompt", text: $prompt)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: generateImage) {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Start")
                }
            }
            .disabled(prompt.isEmpty || isLoading)

            Group {
                if let image = generatedImage {
                    Image(image, scale:1.0, label:Text(""))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 256, maxHeight: 256)
                        .border(Color.gray.opacity(0.5))
                } else {
                    Rectangle()
                        .foregroundColor(Color.gray.opacity(0.15))
                        .frame(width: 256, height: 256)
                        .overlay(
                            Text("Image will appear here")
                                .foregroundColor(.secondary)
                        )
                }
            }
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }

    func generateImage() {
        isLoading = true
        generatedImage = nil
        errorMessage = nil
        Task {
            do {
                let creator = try await ImageCreator()
                let images = creator.images(for: [.text(prompt)], style: .animation, limit: 1)
                if let firstData = try await images.first(where: { _ in true }) {
                        generatedImage = firstData.cgImage
                                                           
                } else {
                    errorMessage = "No image returned."
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

#Preview {
    ContentView()
}
