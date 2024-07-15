//
//  LottieView.swift
//  CoreLocationComponent
//
//  Created by Lucinda Artahni on 15/07/24.
//

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    let animationView = AnimationView()

    var animationName: String

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        animationView.animation = Animation.named(animationName)
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the animation if needed
        animationView.animation = Animation.named(animationName)
        animationView.play()
    }
}

#Preview{
    LottieView(animationName: "Clear")
}

#Preview{
    LottieView(animationName: "Rain")
}
