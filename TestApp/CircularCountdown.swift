import SwiftUI

struct CircularCountdown: View {
    let totalTime: Int
    let currentTime: Int
    
    private var progress: Double {
        Double(totalTime - currentTime) / Double(totalTime)
    }
    
    private var displayTime: Int {
        totalTime - currentTime
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(lineWidth: 12)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(style: StrokeStyle(
                    lineWidth: 12,
                    lineCap: .round
                ))
                .foregroundColor(.blue)
                .rotationEffect(.degrees(-90))
                // Add glow effect
                .shadow(color: .blue.opacity(0.5), radius: 5, x: 0, y: 0)
            
            // Time text
            Text("\(displayTime)")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
        }
        .padding()
        .frame(width: 100, height: 100)
    }
} 