import SwiftUI

struct PomodoroTimerView: View {
    @State private var timeRemaining = 25 * 60 // 25 minutes in seconds
    @State private var isActive = false
    @State private var isWorkSession = true
    @State private var workDuration = 25
    @State private var breakDuration = 5
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isWorkSession ? "Work Session" : "Break Session")
                .font(.headline)
            
            Text(timeString(time: timeRemaining))
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            HStack {
                Button(action: startStop) {
                    Text(isActive ? "Pause" : "Start")
                        .padding()
                        .background(isActive ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: reset) {
                    Text("Reset")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            VStack {
                Stepper("Work duration: \(workDuration) min", value: $workDuration, in: 1...60)
                Stepper("Break duration: \(breakDuration) min", value: $breakDuration, in: 1...30)
            }
            .padding()
        }
        .frame(width: 400)
        .padding()
        .onReceive(timer) { _ in
            if isActive {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    isWorkSession.toggle()
                    timeRemaining = (isWorkSession ? workDuration : breakDuration) * 60
                    // Here you could add a notification sound or alert
                }
            }
        }
    }
    
    func startStop() {
        isActive.toggle()
    }
    
    func reset() {
        isActive = false
        isWorkSession = true
        timeRemaining = workDuration * 60
    }
    
    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct PomodoroTimerView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroTimerView()
    }
}
