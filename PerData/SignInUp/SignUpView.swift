//
//  SignUpView.swift
//  PerData
//
//  Created by Jan Hovland on 20/11/2021.
//

import SwiftUI
import CloudKit

struct SignUpView : View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var passWord: String = ""
    @State private var image = UIImage()
    @State private var userRecord = UserRecord(firstName: "",
                                               lastName: "",
                                               email: "",
                                               passWord: "",
                                               image: nil)
    
    @State private var indicatorShowing = false
    @State private var showSheetImagePicker = false
    @State private var isAlertActive = false

    @State private var title: LocalizedStringKey = ""
    @State private var message: LocalizedStringKey = ""
    @State private var recordID: CKRecord.ID?
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    if  userRecord.image != nil {
                        Image(uiImage: userRecord.image!)
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                            .onTapGesture {
                                showSheetImagePicker.toggle()
                            }
                    } else {
                        ZStack {
                            Text("Select\nimage")
                                .font(Font.footnote.weight(.medium))
                                .foregroundColor(.green)
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 80, height: 80, alignment: .center)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                        }
                    }
                }
                .padding(.top, 70)
                .padding(.bottom, 40)
                .onTapGesture {
                    showSheetImagePicker.toggle()
                }
                .sheet(isPresented: $showSheetImagePicker, content: {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: $image, image: $userRecord.image)
                })
                VStack {
                    HStack {
                        Spacer()
                        Text("FirstName")
                            .foregroundColor(.accentColor)
                            .padding(.trailing, 21)
                        TextField("Enter firstName", text: $userRecord.firstName)
                            .autocapitalization(.words)
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    HStack {
                        Spacer()
                        Text("LastName")
                            .foregroundColor(.accentColor)
                            .padding(.trailing, 12)
                        TextField("Enter lastName", text: $userRecord.lastName)
                            .autocapitalization(.words)
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    HStack {
                        Spacer()
                        Text("email")
                            .foregroundColor(.accentColor)
                            .padding(.trailing, 33)
                        TextField("Enter email", text: $userRecord.email)
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
                            .padding(.trailing, 21)
                        SecureField("Enter passWord", text: $userRecord.passWord)
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                }
                .padding(.leading, 50)
                Spacer()
            }
            .navigationBarTitle("Add a new User", displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                                        /// Rutine for å returnere til personoversikten
                                        presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        HStack {
                                            ReturnFromMenuView(text: "SignInView")
                                        }
                                    })
                                ,trailing:
                                    Button(action: {
                /// Rutine for å legge til en bruker
                if userRecord.firstName.count > 0,
                   userRecord.lastName.count > 0,
                   userRecord.email.count > 0,
                   userRecord.passWord.count > 0 {
                    /// Starte ActivityIndicator
                    indicatorShowing = true
                    
                    ///  Finnes denne brukeren fra før?
                    
                    Task.init {
                        var value: (LocalizedStringKey, CKRecord.ID?)
                        await value = userRecordRecordID(userRecord)
                        if value.0 != "" {
                            message = value.0
                            title = "Error message from the Server"
                            isAlertActive.toggle()
                        } else {
                            recordID = value.1
                            if recordID != nil {
                                message = "This userRecord exists"
                                title = "UserRecord"
                                isAlertActive.toggle()
                            } else {
                                userRecord.recordID = recordID
                                await message = saveUserRecord(userRecord)
                                title = "Save"
                                isAlertActive.toggle()
                            }
                        }
                    }

                } else {
                    title = "Missing value(s)"
                    message = "All the fields must have a value"
                    isAlertActive.toggle()
                }
            }, label: {
                Text("Add user")
                    .font(Font.headline.weight(.light))
            })
                                
            )
        }
        .alert(title, isPresented: $isAlertActive) {
            Button("OK", action: {})
        } message: {
            Text(message)
        }

    }
}

