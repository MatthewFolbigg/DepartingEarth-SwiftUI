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
    
    @ObservedObject var launchList: UpcomingLaunchList
    @ObservedObject var launchLibraryClient = LaunchLibraryApiClient.shared
    @FetchRequest var providers: FetchedResults<Provider>
    @FetchRequest var statuses: FetchedResults<Status>
    @FetchRequest var orbits: FetchedResults<Orbit>
    var isDownloading: Bool { launchLibraryClient.fetchStatus == .fetching ? true : false }
    
    init(launchList: UpcomingLaunchList) {
        self.launchList = launchList
        _providers = FetchRequest(fetchRequest: Provider.requestForAll())
        _statuses = FetchRequest(fetchRequest: Status.requestForAll())
        _orbits = FetchRequest(fetchRequest: Orbit.requestForAll())
    }

    //MARK: - Main Body
    var body: some View {
        NavigationView {
            VStack {
                
                ZStack {
                    LaunchListView(request: launchList.filteredLaunchRequest())
                    if isDownloading { launchLibraryActivityIndicator }
                }
                if launchList.isFiltered {
                    filterIndicatorBar
                        .padding(.horizontal)
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
    
    var filterIndicatorBar: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 3) {
                Text("Provider:")
                    .fontWeight(.thin)
                Text(launchList.providerFilter != nil ? "\(launchList.providerFilter?.compactName ?? "")" : "All")
                    .fontWeight(.regular)
                Spacer()
            }
            HStack(alignment: .center, spacing: 3) {
                Text("Status:")
                    .fontWeight(.thin)
                Text(launchList.statusFilter != nil ? "\(launchList.statusFilter?.abbreviation ?? "")" : "All")
                    .fontWeight(.regular)
                Spacer()
            }
            HStack(alignment: .center, spacing: 3) {
                Text("Orbit:")
                    .fontWeight(.thin)
                Text(launchList.orbitFilter != nil ? "\(launchList.orbitFilter?.abbreviation ?? "")" : "All")
                    .fontWeight(.regular)
                Spacer()
            }
        }
        .font(.caption2)
    }
    
    //MARK: - Menu
    var filterMenu: some View {
        Menu {
            sortOrderMenuButton
            Divider()
            providerPicker
            statusPicker
            orbitPicker
            if launchList.isFiltered {
                clearAllFiltersButton
            }
        } label: {
            Label("Filter", systemImage: "ellipsis.circle").imageScale(.large)
        }
    }
    
    var clearAllFiltersButton: some View {
        Button(
            action: {
                launchList.removeAllFilters()
            },
            label: { Label("Clear Filters", systemImage: "xmark.circle") }
        )
    }
    
    var sortOrderMenuButton: some View {
        Button(
            action: {
                launchList.sortAscending.toggle()
            },
            label: { Label("\(launchList.sortAscending ? "Latest" : "Earliest") first", systemImage: "arrow.up.arrow.down") }
        )
    }

    var providerPicker: some View {
        Picker(
            selection: $launchList.providerFilter,
            label: Label("Launch Provider", systemImage: "person.2"),
            content: {
                if launchList.providerFilter != nil {
                        let tag: Provider? = nil
                        Label("All Providers", systemImage: "xmark.circle").tag(tag)
                        Divider()
                    }
                    ForEach(providers, id: \.self) { provider in
                        let tag: Provider? = provider
                        Text(provider.compactName!).tag(tag)
                    }
               }
        )
        .pickerStyle(MenuPickerStyle())
    }
    
    var statusPicker: some View {
        Picker(
            selection: $launchList.statusFilter,
            label: Label("Status", systemImage: "calendar"),
            content: {
                if launchList.statusFilter != nil {
                    let tag: Status? = nil
                    Label("Any Status", systemImage: "xmark.circle").tag(tag)
                }
                Divider()
                ForEach(statuses, id: \.self) { status in
                    let tag: Status? = status
                    Text(status.abbreviation ?? status.name!).tag(tag)
                }
            }
        )
        .pickerStyle(MenuPickerStyle())
    }
    
    var orbitPicker: some View {
        Picker(
            selection: $launchList.orbitFilter,
            label: Label("Orbit", systemImage: "circle.dashed"),
            content: {
                if launchList.statusFilter != nil {
                    let tag: Status? = nil
                    Label("Any Orbit", systemImage: "xmark.circle").tag(tag)
                }
                Divider()
                ForEach(orbits, id: \.self) { orbit in
                    let tag: Orbit? = orbit
                    Text(orbit.name!).tag(tag)
                }
            }
        )
        .pickerStyle(MenuPickerStyle())
    }
    
    //MARK: - Buttons
    var refreshButton: some View {
        Button(
            action: {
                Launch.deleteAll(from: viewContext)
                launchLibraryClient.fetchData(.upcomingLaunches)
            },
            label: { Label("Refresh", systemImage: "arrow.clockwise.circle") }
        )
    }
    
    var deleteAllButton: some View {
        Button(
            action: { Launch.deleteAll(from: viewContext) },
            label: { Text("Delete") }
        )
        .foregroundColor(.red)
    }
}




//MARK: Previews
struct UpcomingLaunchesListView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingLaunchesView(launchList: UpcomingLaunchList())
    }
}
