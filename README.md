# ImagePlaygroundDemo

**This is a demo project.**

_ImagePlaygroundDemo_ is a playful SwiftUI app that turns your imagination into images—instantly! Powered by the `ImagePlayground` framework, this project takes a text prompt, generates an illustration, and displays the resulting artwork right on your device. It’s ideal for experimenting with generative AI and the latest SwiftUI patterns.

---

## ✨ What does it do?

- **You type a creative prompt.**
- **Tap "Start"** and the app generates an image using AI.
- **See your result**: The artwork appears in the preview frame. If there’s a problem, you get a clear error message.
- **SwiftUI + UIKit**: The project shows how to bridge UIKit’s `UIImage` into a SwiftUI view.

---

## 🚀 How does it work?

This app is state-driven using `@State` properties for:
- The prompt you enter
- The generated image
- Loading state (with a spinner)
- Friendly error messages

Image generation uses Swift’s modern async/await for smooth, non-blocking UI updates. When you start, it:

1. Clears the previous result and enters loading mode.
2. Asynchronously creates an `ImageCreator` and requests an image based on your text.
3. Shows the resulting image (or an error) as soon as it’s ready.

**Example core function:**
```swift
func generateImage() {
    isLoading = true
    generatedImage = nil
    errorMessage = nil
    Task {
        do {
            let creator = try await ImageCreator()
            let images = creator.images(for: [.text(prompt)], style: .illustration, limit: 1)
            if let firstData = try await images.first(where: { _ in true }) {
                generatedImage = UIImage(cgImage: firstData.cgImage)
            } else {
                errorMessage = "No image returned."
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
