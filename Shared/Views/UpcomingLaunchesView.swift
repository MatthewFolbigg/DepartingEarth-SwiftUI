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
    @FetchRequest var orbits: FetchedResults<Orbit>
    @ObservedObject var launchLibrary = LaunchLibraryApiClient.shared
    @State var providerFilter: Provider? = nil
    @State var statusFilter: Status? = nil
    @State var orbitFilter: Orbit? = nil
    var isFiltered: Bool { providerFilter != nil || statusFilter != nil || orbitFilter != nil }
    @State var sortAscending: Bool = true
    
    init() {
        let providerRequest = Provider.requestForAll()
        _providers = FetchRequest(fetchRequest: providerRequest)
        let statusRequest = Status.requestForAll()
        _statuses = FetchRequest(fetchRequest: statusRequest)
        let orbitRequest = Orbit.requestForAll()
        _orbits = FetchRequest(fetchRequest: orbitRequest)
    }

    //MARK: - Main Body
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    LaunchListView(provider: $providerFilter, status: $statusFilter, orbit: $orbitFilter, sortAscending: sortAscending)
                    if launchLibrary.fetchStatus == .fetching {
                        launchLibraryActivityIndicator
                    }
                }
                if isFiltered {
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
                Text(providerFilter != nil ? "\(providerFilter?.compactName ?? "")" : "All")
                    .fontWeight(.regular)
                Spacer()
            }
            HStack(alignment: .center, spacing: 3) {
                Text("Status:")
                    .fontWeight(.thin)
                Text(statusFilter != nil ? "\(statusFilter?.abbreviation ?? "")" : "All")
                    .fontWeight(.regular)
                Spacer()
            }
            HStack(alignment: .center, spacing: 3) {
                Text("Orbit:")
                    .fontWeight(.thin)
                Text(orbitFilter != nil ? "\(orbitFilter?.abbreviation ?? "")" : "All")
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
            if isFiltered {
                clearAllFiltersButton
            }
        } label: {
            Label("Filter", systemImage: "ellipsis.circle").imageScale(.large)
        }
    }
    
    var clearAllFiltersButton: some View {
        Button(
            action: {
                providerFilter = nil
                statusFilter = nil
                orbitFilter = nil
            },
            label: { Label("Clear Filters", systemImage: "xmark.circle") }
        )
    }
    
    var sortOrderMenuButton: some View {
        Button(
            action: { sortAscending.toggle() },
            label: { Label("\(sortAscending ? "Latest" : "Earliest") first", systemImage: "arrow.up.arrow.down") }
        )
    }

    var providerPicker: some View {
        Picker(
            selection: $providerFilter,
            label: Label("Launch Provider", systemImage: "line.horizontal.3.decrease"),
            content: {
                    if providerFilter != nil {
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
            selection: $statusFilter,
            label: Label("Status", systemImage: "line.horizontal.3.decrease"),
            content: {
                if statusFilter != nil {
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
            selection: $orbitFilter,
            label: Label("Orbit", systemImage: "line.horizontal.3.decrease"),
            content: {
                if statusFilter != nil {
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
            action: { launchLibrary.fetchData(.upcomingLaunches) },
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
        UpcomingLaunchesView()
    }
}
