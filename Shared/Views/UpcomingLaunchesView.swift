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
    @FetchRequest var statuses: FetchedResults<Status>
    @ObservedObject var launchLibrary = LaunchLibraryApiClient.shared
    @State var providerFilter: Provider? = nil
    @State var statusFilter: Status? = nil
    @State var sortAscending: Bool = true
    
    init() {
        let providerRequest = Provider.requestForAll()
        _providers = FetchRequest(fetchRequest: providerRequest)
        let statusRequest = Status.requestForAll()
        _statuses = FetchRequest(fetchRequest: statusRequest)
    }

    //MARK: - Main Body
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    LaunchListView(provider: providerFilter, status: statusFilter, sortAscending: sortAscending)
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
                    filterMenu
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
    
    //MARK: - Menu
    var filterMenu: some View {
        Menu {
            providerPicker
            statusPicker
            if statusFilter != nil || providerFilter != nil {
                Button {
                    providerFilter = nil
                    statusFilter = nil
                } label: {
                    Label(
                        title: { Text("Clear Filters") },
                        icon: { Image(systemName: "xmark.circle") }
                    )
                }
            }
            Divider()
            sortOrderMenuButton
        } label: {
            Image(systemName: "ellipsis.circle").imageScale(.large)
        }
    }
    
    var sortOrderMenuButton: some View {
        Button(action: {
            sortAscending.toggle()
        }, label: {
            Label(
                title: { Text("\(sortAscending ? "Latest" : "Earliest") first") },
                icon: { Image(systemName: "arrow.up.arrow.down") }
            )
        })
    }

    var providerPicker: some View {
        Picker(
            selection: $providerFilter,
            label:
                Label(
                    title: { Text("Launch Provider") },
                    icon: { Image(systemName: "line.horizontal.3.decrease") }
            ),
            content: {
                    if providerFilter != nil {
                        let tag: Provider? = nil
                        Label(
                            title: { Text("All Providers") },
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
    
    var statusPicker: some View {
        Picker(
            selection: $statusFilter,
            label:
                Label(
                    title: { Text("Status") },
                    icon: { Image(systemName: "line.horizontal.3.decrease") }
            ),
            content: {
                    if statusFilter != nil {
                        let tag: Status? = nil
                        Label(
                            title: { Text("Any Status") },
                            icon: { Image(systemName: "xmark.circle") }
                        ).tag(tag)
                        Divider()
                    }
                    ForEach(statuses, id: \.self) { status in
                        let tag: Status? = status
                        Text(status.name!).tag(tag)
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
