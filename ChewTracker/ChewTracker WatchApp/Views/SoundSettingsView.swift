import SwiftUI

struct SoundSettingsView: View {
    @AppStorage("selectedSound") private var selectedSound: String = SoundOption.gentleBeep.rawValue
    @AppStorage("soundVolume") private var soundVolume: Double = 0.7
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var soundManager = SoundManager()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Sound Options")
                    .font(.headline)
                    .padding(.top)
                
                ForEach(SoundOption.allCases) { option in
                    Button(action: {
                        selectedSound = option.rawValue
                        soundManager.playWarningSound()
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(option.rawValue)
                                    .font(.body)
                                
                                Text(option.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if selectedSound == option.rawValue {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(selectedSound == option.rawValue ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Divider()
                    .padding(.vertical)
                
                Text("Volume")
                    .font(.headline)
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "speaker.fill")
                            .foregroundColor(.secondary)
                        
                        Slider(value: $soundVolume, in: 0...1) { _ in
                            soundManager.playWarningSound()
                        }
                        
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom)
                
                Button("Test Sound") {
                    soundManager.playWarningSound()
                }
                .buttonStyle(.bordered)
                .padding(.vertical)
                
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Sound Settings")
    }
}

struct SoundSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SoundSettingsView()
    }
}

