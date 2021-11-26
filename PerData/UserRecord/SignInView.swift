//
//  SignInView.swift
//  PerData
//
//  Created by Jan Hovland on 19/11/2021.
//

import SwiftUI
import CloudKit
import Network

struct SignInView: View {
    
    @State private var showOptionMenu = false
    @State private var showSignUpView = false
    @State private var isAlertActive = false
    @State private var runPerData = false
    @State private var runSignUpView = false
    
    @State private var title: LocalizedStringKey = ""
    @State private var message: LocalizedStringKey = ""
    @State private var device: LocalizedStringKey = ""
    @State private var hasConnectionPath = false
    @State private var userRecord = UserRecord(firstName: "Jan",
                                               lastName: "Hovland",
                                               email: "jan.hovland@lyse.net",
                                               passWord: "qwerty",
                                               image: nil)
    
    let internetMonitor = NWPathMonitor()
    let internetQueue = DispatchQueue(label: "InternetMonitor")
    
    @State private var userRecords = [UserRecord]()
    @State private var recordID: CKRecord.ID?
    
    @State private var indicatorShowing = false
    @State private var image = UIImage()
    
    var body: some View {
        
        VStack {
            if hasInternet() == true {
                HeadingView(heading: "Sign in CloudKit")
                HStack {
                    if userRecord.image != nil {
                        Image(uiImage: userRecord.image!)
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                            .font(Font.title.weight(.ultraLight))
                    }
                }
                
                .padding(.top, 40)
                .padding(.bottom, 40)
                VStack {
                    HStack {
                        Spacer()
                        Text("FirstName")
                            .foregroundColor(.accentColor)
                        TextField("Enter firstName", text: $userRecord.firstName)
                            .padding(.leading, 30)
                            .autocapitalization(.words)
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    HStack {
                        Spacer()
                        Text("LastName")
                            .foregroundColor(.accentColor)
                        TextField("Enter lastName", text: $userRecord.lastName)
                            .padding(.leading, 20)
                            .autocapitalization(.words)
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    HStack {
                        Spacer()
                        Text("email")
                            .foregroundColor(.accentColor)
                        TextField("Enter email", text: $userRecord.email)
                            .padding(.leading, 40)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    HStack {
                        Spacer()
                        Text("Password")
                            .foregroundColor(.accentColor)
                        SecureField("Enter passWord", text: $userRecord.passWord)
                            .padding(.leading, 30)
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                }
                .padding(.leading, device == "iPhone" ? 50 : ((UIScreen.main.bounds.width / 3.0) + 50   ))
                
                Button (action: {
                    if userRecord.firstName.count > 0,
                       userRecord.lastName.count > 0,
                       userRecord.passWord.count > 0 {
                        
                        ///
                        ///Finnes denne brukeren?
                        ///
                        
                        Task.init {
                            var value: (LocalizedStringKey, Bool)
                            await value = userRecordExist(userRecord)
                            
                            if value.0 != "" {
                                title = "Error looking for userRecord"
                                message = value.0
                                isAlertActive.toggle()
                            } else {
                                
                                /// Finn RecordID
                                
                                var value: (LocalizedStringKey, CKRecord.ID?)
                                await value = userRecordRecordID(userRecord)
                                if value.0 != "" {
                                    message = value.0
                                    title = "Error message from the Server"
                                    isAlertActive.toggle()
                                } else {
                                    recordID = value.1
                                    if recordID != nil {
                                        var value: (LocalizedStringKey, UserRecord)
                                        let predicate = NSPredicate(format: "firstName == %@ AND lastName == %@", userRecord.firstName, userRecord.lastName)
                                        await value = findUserRecord(predicate)
                                        if value.0 != "" {
                                            message = value.0
                                            title = "Error message from the Server"
                                            isAlertActive.toggle()
                                        } else {
                                            userRecord = value.1
                                        }
                                        /// Starter PerDate()
                                        runPerData.toggle()
                                    } else {
                                        message = value.0
                                        title = "Unknown userRecord"
                                        isAlertActive.toggle()
                                    }
                                }
                            }
                        }
                    } else {
                        title = "Missing value(s)"
                        message = "All the fields must have a value"
                        isAlertActive.toggle()
                    }
                }, label: {
                    Text("Sign Up")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.white)
                        .bold()
                        .padding()
                        .frame(minWidth: 300, maxWidth: 300)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 251/255, green: 128/255, blue: 128/255), Color(red: 253/255, green: 193/255, blue: 104/255)]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                })
                
                HStack (alignment: .center, spacing: 60) {
                    Text("Create a new account?")
                        .foregroundColor(.purple)
                    Button(action: {
                        runSignUpView.toggle()
                    },
                    label: {
                        HStack {
                            Text("New user")
                                .foregroundColor(.secondary)
                        }
                        .foregroundColor(.blue)
                    })
                }
                .padding(.top, 30)
                .padding(.bottom, 50)
                
                .sheet(isPresented: $runPerData, content: {
                    PerData()
                })
                .sheet(isPresented: $runSignUpView, content: {
                    SignUpView()
                })
                
            }
        }
        
        .task {
            startInternetTracking()
            ///
            /// Må legge inn en forsinkelse fordi
            /// usleep() takes millionths of a second
            usleep(1000000) /// 1.0 S
            if UIDevice.current.localizedModel == "iPhone" {
                device = "iPhone"
            } else if UIDevice.current.localizedModel == "iPad" {
                device = "iPad"
            }
            if hasInternet() == false {
                title = device
                message = "No Internet connection for this device."
                isAlertActive.toggle()
            }
        }
        .alert(title, isPresented: $isAlertActive) {
            Button("OK", action: {})
        } message: {
            Text(message)
        }
    }
    
    func startInternetTracking() {
        // Only fires once
        guard internetMonitor.pathUpdateHandler == nil else {
            return
        }
        internetMonitor.pathUpdateHandler = { update in
            if update.status == .satisfied {
                self.hasConnectionPath = true
            } else {
                self.hasConnectionPath = false
            }
        }
        internetMonitor.start(queue: internetQueue)
    }
    
    /// Will tell you if the device has an Internet connection
    /// - Returns: true if there is some kind of connection
    func hasInternet() -> Bool {
        return hasConnectionPath
    }
}

struct HeadingView: View {
    var heading: LocalizedStringKey
    var body: some View {
        VStack {
            Text(heading)
                .font(.headline)
                .foregroundColor(.accentColor)
                .padding()
        }
        .padding(.bottom, 30)
    }
}


