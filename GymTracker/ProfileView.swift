//
//  ProfileView.swift
//  GymTracker
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("gymPreference") private var gymPreference: String = ""
    @AppStorage("userHeight") private var userHeight: String = ""
    @AppStorage("userWeight") private var userWeight: String = ""
    @AppStorage("profileImageData") private var profileImageData: Data = Data()

    @State private var selectedPhoto: PhotosPickerItem?
    @State private var heightDigits: String = ""

    private var profileImage: Image? {
        guard let uiImage = UIImage(data: profileImageData) else { return nil }
        return Image(uiImage: uiImage)
    }

    private func formattedHeight(from digits: String) -> String {
        guard !digits.isEmpty else { return "" }
        if digits.count == 1 {
            return digits
        }
        let feet = min(Int(String(digits.first!)) ?? 0, 9)
        let inches = min(Int(digits.dropFirst()) ?? 0, 11)
        return "\(feet)'\(inches)\""
    }

    private var heightBinding: Binding<String> {
        Binding(
            get: { formattedHeight(from: heightDigits) },
            set: { newValue in
                let currentDisplay = formattedHeight(from: heightDigits)
                if newValue.count < currentDisplay.count {
                    heightDigits = String(heightDigits.dropLast())
                } else {
                    heightDigits = String(newValue.filter { $0.isNumber }.prefix(3))
                }
            }
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 10) {
                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                ZStack {
                                    if let profileImage {
                                        profileImage
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    } else {
                                        Circle()
                                            .fill(.quaternary)
                                            .frame(width: 100, height: 100)
                                            .overlay {
                                                Image(systemName: "person.fill")
                                                    .font(.system(size: 40))
                                                    .foregroundStyle(.secondary)
                                            }
                                    }

                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 30, height: 30)
                                        .overlay {
                                            Image(systemName: "camera.fill")
                                                .font(.caption)
                                                .foregroundStyle(.white)
                                        }
                                        .offset(x: 34, y: 34)
                                }
                            }

                            if !userName.isEmpty {
                                Text(userName)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 12)
                }
                .listRowBackground(Color.clear)

                Section("Your Name") {
                    TextField("Enter your name", text: $userName)
                }

                Section("Gym") {
                    TextField("Preferred gym", text: $gymPreference)
                }

                Section("Body Stats") {
                    HStack {
                        Text("Height")
                        Spacer()
                        TextField("e.g. 5'10\"", text: heightBinding)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 120)
                    }
                    HStack {
                        Text("Weight (lbs)")
                        Spacer()
                        TextField("e.g. 175", text: $userWeight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 120)
                    }
                }
            }
            .navigationTitle("Profile")
            .onChange(of: selectedPhoto) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        profileImageData = data
                    }
                }
            }
            .onAppear {
                heightDigits = userHeight.filter { $0.isNumber }
            }
            .onChange(of: heightDigits) { _, newValue in
                userHeight = formattedHeight(from: newValue)
            }
        }
    }
}
