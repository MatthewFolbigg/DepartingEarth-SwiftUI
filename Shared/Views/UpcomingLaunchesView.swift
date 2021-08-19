//
//  UpcomingLaunchesView.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 14/08/2021.
//

import SwiftUI

struct UpcomingLaunchesView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var launchLibraryClient = LaunchLibraryApiClient.shared
    var isDownloading: Bool { launchLibraryClient.fetchStatus == .fetching ? true : false }
    
    @State var sortOrderAscending = true
    @FetchRequest var providers: FetchedResults<Provider>
    @State var providerFilter: String? = nil
    @FetchRequest var orbits: FetchedResults<Orbit>
    @State var orbitFilter: String? = nil
    @FetchRequest var statuses: FetchedResults<Status>
    @State var statusFilter: String? = nil
    var isFiltered: Bool { providerFilter != nil || orbitFilter != nil || statusFilter != nil}
    func removeAllFilters() { providerFilter = nil; orbitFilter = nil; statusFilter = nil }
    
    init() {
        _providers = FetchRequest(fetchRequest: Provider.requestForAll())
        _orbits = FetchRequest(fetchRequest: Orbit.requestForAll())
        _statuses = FetchRequest(fetchRequest: Status.requestForAll())
        UINavigationBar.appearance().tintColor = UIColor(.ui.greyBlueAccent)
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                //MARK: - Main View
                VStack {
                    FilteredLaunchList(providerFilter: $providerFilter, statusFilter: $statusFilter, orbitFilter: $orbitFilter, sortAscending: sortOrderAscending)
                }
                //MARK: - On Appear
                .onAppear {
                    if Launch.count(in: viewContext) == 0 {
                        refreshLaunches(deletingFirst: false)
                    } else {
                        //Check for stale data
                    }
                }
                //MARK: - Navigation and ToolBar
                .navigationTitle("Departing Soon")
                .navigationBarTitleDisplayMode(.automatic)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        filterMenu
                            .foregroundColor(.ui.greyBlueAccent)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        refreshButton
                            .foregroundColor(.ui.greyBlueAccent)
                    }
                }
            }
            if isDownloading { launchLibraryActivityIndicator }
        }
    }
    
    //MARK: Refreshing data
    func refreshLaunches(deletingFirst: Bool = true) {
        withAnimation {
            if deletingFirst { Launch.deleteAll(from: viewContext) }
            launchLibraryClient.fetchAndUpdateData(.upcomingLaunches)
        }

    }
    
    var refreshButton: some View {
        Button(
            action: { refreshLaunches() },
            label: { Label("Refresh", systemImage: "arrow.clockwise.circle") }
        )
    }
    
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
    
    
}


//MARK:- List Filtering Controls
extension UpcomingLaunchesView {
    
    //MARK: Filter Menu
    var filterMenu: some View {
        Menu {
            sortOrderMenuButton
            Divider()
            providerPicker
            statusPicker
            orbitPicker
            if isFiltered { clearAllFiltersButton }
        } label: {
            let icon = isFiltered ? "line.horizontal.3.decrease.circle.fill" : "line.horizontal.3.decrease.circle"
            Label("Filter", systemImage: icon)
                .imageScale(.large)
        }
    }
    
    //MARK: Sort Order
    var sortOrderMenuButton: some View {
        Button(
            action: {
                withAnimation {
                    sortOrderAscending.toggle()
                }
            },
            label: { Label("\(sortOrderAscending ? "Latest" : "Earliest") first", systemImage: "arrow.up.arrow.down") }
        )
    }
    
    //MARK: Clear Filters Button
    var clearAllFiltersButton: some View {
        Button(
            action: {
                withAnimation {
                    removeAllFilters()
                }
            },
            label: { Label("Clear Filters", systemImage: "xmark.circle") }
        )
    }
    
    //MARK: Provider Filter
    var providerPicker: some View {
        Picker(
            selection: $providerFilter.animation(),
            label: Label(
                providerFilter != nil ? Provider.providerFor(name: providerFilter!, context: viewContext)?.compactName ?? "" : "All Providers",
                systemImage: "person.2"
            ),
            content: {
                if providerFilter != nil {
                        let tag: String? = nil
                        Label("All Providers", systemImage: "xmark.circle").tag(tag)
                        Divider()
                    }
                    ForEach(providers, id: \.self) { provider in
                        let tag: String? = provider.name ?? nil
                        Text(provider.compactName).tag(tag)
                    }
               }
        )
        .pickerStyle(MenuPickerStyle())
    }
    
    //MARK: Status Filter
    var statusPicker: some View {
        Picker(
            selection: $statusFilter.animation(),
            label: Label(
                statusFilter != nil ? statusFilter! : "All Statuses",
                systemImage: "calendar"
            ),
            content: {
                if statusFilter != nil {
                    let tag: String? = nil
                    Label("Any Status", systemImage: "xmark.circle").tag(tag)
                }
                Divider()
                ForEach(statuses, id: \.self) { status in
                    let tag: String? = status.name
                        Text(status.name ?? status.currentSituation.filterName).tag(tag)
                }
            }
        )
        .pickerStyle(MenuPickerStyle())
    }
    
    //MARK: Orbit Filter
    var orbitPicker: some View {
        Picker(
            selection: $orbitFilter.animation(),
            label: Label(
                orbitFilter != nil ? orbitFilter! : "All Orbits",
                systemImage: "circle.dashed"
            ),
            content: {
                if orbitFilter != nil {
                    let tag: String? = nil
                    Label("Any Orbit", systemImage: "xmark.circle").tag(tag)
                }
                Divider()
                ForEach(orbits, id: \.self) { orbit in
                    let tag: String? = orbit.name
                    Text(orbit.name!).tag(tag)
                }
            }
        )
        .pickerStyle(MenuPickerStyle())
    }

}






struct NEWUpcomingLaunchesView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingLaunchesView()
    }
}
