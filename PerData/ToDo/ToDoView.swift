//
//  ToDoView.swift
//  PerData
//
//  Created by Jan Hovland on 04/11/2021.
//

import SwiftUI

//
//  ToDoView.swift
//  PersonalOverView
//
//  Created by Jan Hovland on 24/09/2020.
//

import SwiftUI

struct ToDoView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var toDo =
    """
    
      1. 🟢 Oppdatere underteksten på "OPPDATER POSTNUMMER" til "Have uncommented the actual function!".
      2. 🟢 Legg inn ActivityIndicator (Ikke en del av SwiftUI).
      3. 🟢 Rette søk på postnummer, finne alle steder som begynner på f.eks. Varh .
      4. 🟢 Lagt inn 2 eksport parametre: func findPersons() async -> (err: LocalizedStringKey, person: [Person]).
      5. 🟢 Byttet over til Public Database fordi det er problemer med Private.
            Sendt epost til Apple Support.
      6. 🟢 Postnummer virker ikke i PersonalView (Utsettes: må skrives om for iOS 15).
      7. 🟢 Aktivere en bryter for å kunne oppdatere ZipCode tabellen:
            . 🟢 Activity Indicator.
      8. 🟢 Oppdatere Person tabellen fra Json:
            . 🟢 Selve oppdateringen fra Json backup filen.
            . 🟢 Activity Indicator.
            . 🟢 Antall personer som er oppdatert fra Json backup: viser nå riktig antall.
            . 🟢 Beskrive oppdatering fra Json save/modify.
      9. 🟢 Personer.
            . 🟢 Søkefelt på personer.
     10. 🟢 Kan ikke scrolle på oppgavene i Xcode.
     11. 🟢 Sjekk om Internet er tilkoplet.
     12. 🟢 Legge inn knapperekken på hver person.
            . 🟢 Kart
            . 🟢 Telefon
            . 🟢 Melding
            . 🟢 e-Post
            . 🟢 Hytte
     13. 🟢 Rette CloudKit for hytta (Cabin table)
     14. 🟢 Hyttereservasjon skrevet om.
     15. 🟢 CloudKit UserRecord:
            . 🟢 Oppdatert CloudKit og Cloud Helper.
            . 🟢 Skrive om UserRecordOverView()
     16. 🟢 Oppdatere åpningsbildet SignInView()
     17. 🟢 Oppdatere åpningsbildet SignUpView()
     18. 🟢 Nytt meny oppsett
     19. 🛑 Kryptere / dekryptere passordet til og fra CloudKit
     20. 🛑 Sjekk visning av fødselsdato når denne blir endret.
     21. 🛑 Sortere personene i person oversikt. (Å skal komme etter Æ)
     22. 🛑 Json:
            . 🛑 Lagre person i Json
                 . 🛑 Vente til persons er oppdatert
                 . 🛑 Finne json filen (du kan legge inn url i Safari og se innholdet)
            . 🛑 Lagre hyttereservasjoner i Json
            . 🛑 Lagre userRecord i Json
            . 🟢 Hente person fra Json
            . 🛑 Hente hyttereservasjoner fra Json
            . 🛑 Hente userRecord fra Json
     23. 🟢 Ascii
            . 🟢 Hente postkoder fra ascii
     24. 🛑 Indexed table view:
            . 🛑 Person
            . 🛑 Brukere
     25. 🛑 Se om sending av e-post kan gjøres på SwiftUI vis.
     26. 🛑 Gjøre oppfriskingen av personene raskere.
            let result = try await database.records(matching: query)
            result inneholder alle persondata, det er bare å plukke dem ut.
     27. 🛑 .

    """
    
    var body: some View {
        NavigationView {
            ScrollView (.vertical, showsIndicators: false) {
                VStack (alignment: .leading) {
                    Text(toDo)
                    Spacer()
                }
                .multilineTextAlignment(.leading)
                .padding()
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarTitle("ToDo", displayMode: .inline)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        ControlGroup {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                ReturnFromMenuView(text: "Menu")
                            }
                        }
                        .controlGroupStyle(.navigation)
                    }
                })
            }
        }
    }
}

