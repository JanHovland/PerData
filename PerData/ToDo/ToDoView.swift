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
     19. 🟢 Gjøre oppfriskingen av Person / UserRecord / Cabin etc. raskere.
            for record in result .matchResults {
            var person = Person()
            ///
            /// Slik hentes de enkelte feltene ut:
            ///
            let per  = try record.1.get()
     20. 🟢 Legg in overskrift på oversikt hyttereservasjon
     21. 🟢 Ascii
            . 🟢 Hente postkoder fra ascii
     22. 🟢 Encrypted fields in CloudKit
            Kan ikke brukes på Public Database, kun på Private og Shared Database!
     23. 🟢 Ved oppdatering av UserRecordDetailView():
            . Bildet fra viewet og ved oppfrisking i UserRecordOverView
              kommer bildet frem igjen.
            . Dersom en velger nytt bilde, er alt OK.
     24. 🟢 Endre tilsvarende getAllPersons()
            . 🟢 getAllCabins()
            . 🟢 getAllZipCodes
     25. 🟢 Kun store bokstaver i feltet "By" PersonUpdateView()
            . Løsningen virker ikke å iMac.
     25. 🛑 Json:
            . 🟢 Lagre person i Json
                 . 🟢 Finne json filen (du kan legge inn url i Safari og se innholdet)
                 . 🟢 For å få tak i filen som blir opprette og kunne se denne i "Filer" på iPhone:
                      Legg til disse i Info.plist:
                        Application supports iTunes file sharing     YES
                        Supports opening documents in place          YES
            . 🟢 Hente person fra Json
            . 🟢 Lagre userRecord i Json
            . 🛑 Hente userRecord fra Json
            . 🛑 Lagre hyttereservasjoner i Json
            . 🛑 Hente hyttereservasjoner fra Json
     26. 🛑 Sjekk visning av fødselsdato når denne blir endret.
     27. 🛑 Sortere personene i person oversikt. (Å skal komme etter Æ)
     28. 🛑 Indexed table view:
            . 🛑 Person
            . 🛑 Brukere
     29. 🛑 Se om sending av e-post kan gjøres på SwiftUI vis.
     30. 🛑 .

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

