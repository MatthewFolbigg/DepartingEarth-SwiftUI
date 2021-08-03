//
//  UpcomingLaunchesView.swift
//  Shared
//
//  Created by Matthew Folbigg on 02/08/2021.
//

import SwiftUI
import CoreData

struct UpcomingLaunchesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var providers: FetchedResults<Provider>
    @ObservedObject var launchLibrary = LaunchLibraryApiClient.shared
    @State var providerFilter: Provider? = nil
    
    init() {
        let providerRequest = Provider.requestForAll()
        _providers = FetchRequest(fetchRequest: providerRequest)
    }

    //MARK: - Main Body
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    LaunchListView(filter: providerFilter)
                    deleteAllButton
                }
                if launchLibrary.fetchStatus == .fetching {
                    launchLibraryActivityIndicator
                }
            }
            .navigationTitle("Departing Soon")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    providerMenu
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    refreshButton
                }
            }
        }
    }
    
    //MARK: - Views
    var launchLibraryActivityIndicator: some View {
        VStack {
            ProgressView()
                .padding(.top)
            Text("Getting Launches")
                .padding(.vertical)
        }
        .frame(width: 200, height: 120, alignment: .center)
        .foregroundColor(.secondary)
        .background(
            Color(UIColor.tertiarySystemGroupedBackground)
                .opacity(0.9)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
        
    var providerMenu: some View {
        Picker(selection: $providerFilter,
               label: Image(systemName: "line.horizontal.3.decrease.circle").imageScale(.large),
                content: {
                    if providerFilter != nil {
                        let tag: Provider? = nil
                        Label(
                            title: { Text("Show All") },
                            icon: { Image(systemName: "xmark.circle") }
                        ).tag(tag)
                        Divider()
                    }
                    ForEach(providers, id: \.self) { provider in
                        let tag: Provider? = provider
                        Text(provider.compactName!).tag(tag)
                    }
               }
        ).pickerStyle(MenuPickerStyle())
    }
    
    //MARK: - Buttons
    var refreshButton: some View {
        Button {
            launchLibrary.fetchData(.upcomingLaunches)
        } label: {
            Label(
                title: { Text("Refresh") },
                icon: { Image(systemName: "arrow.clockwise.circle") }
            )
        }
    }
    
    var deleteAllButton: some View {
        Button(action: { Launch.deleteAll(from: viewContext) }, label: { Text("Delete") })
            .foregroundColor(.red)
    }
    
}




//MARK: Previews
struct UpcomingLaunchesListView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingLaunchesView()
    }
}
