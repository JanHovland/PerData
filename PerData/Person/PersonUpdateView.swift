//
//  PersonUpdateView.swift
//  PerData
//
//  Created by Jan Hovland on 27/10/2021.
//

import SwiftUI
import CloudKit

///
/// https://www.simpleswiftguide.com/swiftui-textfield-complete-tutorial/
/// https://www.hackingwithswift.com/articles/216/complete-guide-to-navigationview-in-swiftui
///

struct PersonUpdateView: View {
    
    /// Denne kalles via NavigationLink i PerData som innholder automatisk retur.
    /// Derfor må det ikke legge inn NavigationView.
    
    @State var person: Person
    @State private var message: LocalizedStringKey = ""
    @State private var title: LocalizedStringKey = ""
    @State private var isAlertActive = false
    @State private var image = UIImage()
    @State private var modifyImage = false
    @State private var showSheetFindZipCode = false
    @State private var showImage = false
    
    var genders = [String(localized: "Man"),
                   String(localized: "Woman")]
    
    var body: some View {
        VStack {
            
            ///
            /// VStack kan kun inneholde 10 elementer,
            /// derfor må Group benyttes
            
            Group {
                ZStack {
                    if  person.image != nil {
                        Image(uiImage: person.image!)
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                            .onTapGesture {
                                showImage.toggle()
                                modifyImage = true
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
                .onTapGesture {
                    showImage.toggle()
                    modifyImage = true
                }
                .sheet(isPresented: $showImage, content: {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: $image, image: $person.image)
                })
                TextField("FirstName", text: $person.firstName)
                    .autocapitalization(.words)
                TextField("LastName", text: $person.lastName)
                    .autocapitalization(.words)
                TextField("Email", text: $person.personEmail)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                TextField("Address", text: $person.address)
                    .autocapitalization(.words)
                TextField("Phonenumber", text: $person.phoneNumber)
            }
            Group {
                HStack (alignment: .center, spacing: 10) {
                    TextField("Citynumber", text: $person.cityNumber)
                        .keyboardType(.numberPad)
                    TextField("City", text: $person.city)
                        .autocapitalization(.words)
                    VStack {
                        Button {
                            showSheetFindZipCode.toggle()
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .center)
                                .foregroundColor(.blue)
                                .font(.title)
                        }
                        .sheet(isPresented: $showSheetFindZipCode, content: {
                            FindZipCode(city: $person.city,
                                        cityNumber: $person.cityNumber,
                                        municipalityNumber: $person.municipalityNumber,
                                        municipality: $person.municipality)
                        })
                    }
                }
                HStack (alignment: .center, spacing: 0) {
                    TextField("Municipality number", text: $person.municipalityNumber)
                        .keyboardType(.numberPad)
                    TextField("Municipality", text: $person.municipality)
                        .autocapitalization(.none)
                        .autocapitalization(.words)
                }
                DatePicker(
                    selection: $person.dateOfBirth,
                    // in: ...dato,                  /// Uten in: -> ingen begrensning på datoutvalg
                    displayedComponents: [.date],
                    label: {
                        Text("Date of birth")
                    })
                    .padding(.leading, 10)
                /// Returning an integer 0 == "Man" 1 == "Women
                InputGender(heading: "Gender",
                            genders: genders,
                            value: $person.gender)
            }
            Spacer()
        }
        .textFieldStyle(.roundedBorder)
        .padding()
        .navigationBarTitle("Modify person", displayMode: .inline)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                ControlGroup {
                    Button (action: {
                        Task.init {
                            if modifyImage == true {
                                person.image = image
                            } else {
                                self.person.image = person.image
                            }
                            ///
                            ///Finn RecordID med eventuell feilmelding
                            ///
                            await FindRecordId()
                        }
                    }, label: {
                        Text("Modify")
                    })
                }
                .controlGroupStyle(.navigation)
            }
        })
        .alert(title, isPresented: $isAlertActive) {
            Button("OK", action: {})
        } message: {
            Text(message)
        }
    }
    
    func FindRecordId() async {
        var value: (LocalizedStringKey, CKRecord.ID?   )
        await value = personRecordID(person)
        if value.0 != "" {
            ///
            ///Feilmelding
            ///
            message = value.0
            title = "Error message from the Server"
            isAlertActive.toggle()
        } else {
            if value.1 == nil {
                await message = save(person)
                title = "Save"
                isAlertActive.toggle()
            } else {
                await message = modify(person, modifyImage)
                modifyImage = false
                title = "Modify"
                isAlertActive.toggle()
            }
        }
    }
}
