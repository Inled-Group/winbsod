import Cocoa
import SwiftUI

@main
struct BSODApp: App {
    var body: some Scene {
        WindowGroup {
            BSODView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
    }
}

struct BSODView: View {
    @State private var progress: Double = 20.0
    @State private var isFullScreen = false
    
    var body: some View {
        ZStack {
            // Fondo azul característico
            Color(red: 0.0, green: 0.47, blue: 0.84)
                .ignoresSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 40) {
                Spacer()
                
                // Cara triste
                Text(":(")
                    .font(.system(size: 120, weight: .thin))
                    .foregroundColor(.white)
                    .padding(.leading, 40)
                
                Spacer().frame(height: 20)
                
                // Mensaje principal
                VStack(alignment: .leading, spacing: 20) {
                    Text("Your PC ran into a problem and needs to restart. We're\njust collecting some error info, and then we'll restart for\nyou.")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(.white)
                        .lineSpacing(8)
                    
                    Spacer().frame(height: 40)
                    
                    // Porcentaje de progreso
                    Text("\(Int(progress))% complete")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(.white)
                }
                .padding(.leading, 40)
                
                Spacer()
                
                // Información adicional y QR
                HStack(alignment: .top, spacing: 20) {
                    // QR Code desde archivo
                    if let qrImage = NSImage(named: "qr") {
                        Image(nsImage: qrImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                    } else {
                        // Fallback si no se encuentra la imagen
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text("QR\nNOT\nFOUND")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("For more information about this issue and possible fixes, visit https://www.windows.com/stopcode")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.white)
                        
                        Spacer().frame(height: 10)
                        
                        Text("If you call a support person, give them this info:")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.white)
                        
                        Text("Stop code: CRITICAL_PROCESS_DIED")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.white)
                    }
                }
                .padding(.leading, 40)
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            enterFullScreen()
            startProgressAnimation()
        }
        .focusable()
        .onKeyPress { keyPress in
            if keyPress.key == .escape {
                exitFullScreen()
                NSApplication.shared.terminate(nil)
                return .handled
            }
            return .ignored
        }
    }
    
    private func enterFullScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let window = NSApplication.shared.windows.first {
                window.setFrame(NSScreen.main?.frame ?? .zero, display: true)
                window.level = .floating
                window.toggleFullScreen(nil)
                isFullScreen = true
            }
        }
    }
    
    private func exitFullScreen() {
        if let window = NSApplication.shared.windows.first, isFullScreen {
            window.toggleFullScreen(nil)
        }
    }
    
    private func startProgressAnimation() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 1.5)) {
                progress += Double.random(in: 1...5)
                if progress > 100 {
                    progress = 20
                }
            }
        }
    }
}

#Preview {
    BSODView()
}
