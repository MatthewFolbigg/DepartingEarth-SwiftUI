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
        UINavigationBar.appearance().tintColor = UIColor(.ui.greyBlueAccent)
    }

    //MARK: - Main Body
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    LaunchListView(request: launchList.filteredLaunchRequest())    
                }
                .navigationTitle("Departing Soon")
                .navigationBarTitleDisplayMode(.automatic)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        filterMenu
                            .foregroundColor(.ui.greyBlueAccent)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        refreshButton
                    }
                }
            }
            if isDownloading { launchLibraryActivityIndicator }
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
    
//    var filterIndicatorBar: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 10) {
//                filterIndicator(type: "Provider", status: launchList.providerFilter?.compactName ?? "")
//                filterIndicator(type: "Status", status: launchList.statusFilter?.abbreviation ?? "")
//                filterIndicator(type: "Orbit", status: launchList.orbitFilter?.abbreviation ?? "")
//            }
//            Spacer()
//            clearAllFiltersButton
//                .foregroundColor(.red)
//        }
//        .font(.caption2)
//    }
    
    @ViewBuilder
    func filterIndicator(type: String, status: String) -> some View {
        HStack(alignment: .center, spacing: 3) {
            Text("\(type):")
                .fontWeight(.thin)
            Text(launchList.orbitFilter != nil ? "\(status)" : "All")
                .fontWeight(.regular)
            Spacer()
        }
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
            let icon = launchList.isFiltered ? "line.horizontal.3.decrease.circle.fill" : "line.horizontal.3.decrease.circle"
            Label("Filter", systemImage: icon).imageScale(.large)
        }
    }
    
    var clearAllFiltersButton: some View {
        Button(
            action: { launchList.removeAllFilters() },
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
            label: Label(
                launchList.providerFilter != nil ? "\(launchList.providerFilter?.compactName ?? "Provider")" : "All Providers",
                systemImage: "person.2"
            ),
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
            label: Label(
                launchList.statusFilter != nil ? "\(launchList.statusFilter?.currentSituation.filterName ?? "Status")" : "All Statuses",
                systemImage: "calendar"
            ),
            content: {
                if launchList.statusFilter != nil {
                    let tag: Status? = nil
                    Label("Any Status", systemImage: "xmark.circle").tag(tag)
                }
                Divider()
                ForEach(statuses, id: \.self) { status in
                    let tag: Status? = status
                    Text(status.currentSituation.filterName).tag(tag)
                }
            }
        )
        .pickerStyle(MenuPickerStyle())
    }
    
    var orbitPicker: some View {
        Picker(
            selection: $launchList.orbitFilter,
            label: Label(
                launchList.orbitFilter != nil ? "\(launchList.orbitFilter?.name ?? "Orbit")" : "All Orbits",
                systemImage: "circle.dashed"
            ),
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
    
}




//MARK: Previews
struct UpcomingLaunchesListView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingLaunchesView(launchList: UpcomingLaunchList())
    }
}
