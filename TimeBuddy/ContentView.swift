import SwiftUI

struct ContentView: View {
    @State private var timeZones = [String]()
    @State private var newTimeZone = "GMT"
    @State private var selectedTimeZones = Set<String>()
    
    var body: some View {
        VStack {
            if timeZones.isEmpty {
                Text("Please add your first time zone below.")
                    .frame(maxHeight: .infinity)
            } else {
                List(selection: $selectedTimeZones) {
                    ForEach(timeZones, id: \.self) { timeZone in
                        Text(timeZone)
                    }
                    .onMove(perform: moveItems)
                }
                .onDeleteCommand(perform: deleteItems)
            }
            
            HStack {
                Picker("Add Time Zone", selection: $newTimeZone) {
                    ForEach(TimeZone.knownTimeZoneIdentifiers, id: \.self) { timeZone in
                        Text(timeZone)
                    }
                }
                Button("Add") {
                    if timeZones.contains(newTimeZone) == false {
                        withAnimation {
                            timeZones.append(newTimeZone)
                        }
                        
                        save()
                    }
                }
            }
        }
        .padding()
        .onAppear(perform: load)
    }
    
    private func load() {
        timeZones = UserDefaults.standard.stringArray(forKey: "TimeZones") ?? []
    }
    
    private func save() {
        UserDefaults.standard.set(timeZones, forKey: "TimeZones")
    }
    
    private func deleteItems() {
        withAnimation {
            timeZones.removeAll(where: selectedTimeZones.contains)
        }
        
        save()
    }
    
    private func moveItems(from source: IndexSet, to destination: Int) {
        timeZones.move(fromOffsets: source, toOffset: destination)
        save()
    }
}

#Preview {
    ContentView()
}

