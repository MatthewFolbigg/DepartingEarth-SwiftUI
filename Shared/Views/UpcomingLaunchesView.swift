//
//  UpcomingLaunchesView.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 14/08/2021.
//

import SwiftUI

struct UpcomingLaunchesView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var pinned: PinnedLaunches
    
    @State var showPinned: Bool = false
        
    //Launch Library API States
    @ObservedObject var launchLibraryClient = LaunchLibraryApiClient.shared
    var isDownloading: Bool { launchLibraryClient.fetchStatus == .fetching ? true : false }
    
    //Filter States
    @State var sortOrderAscending = true
    @FetchRequest var providers: FetchedResults<Provider>
    @State var providerFilter: String? = nil
    @FetchRequest var orbits: FetchedResults<Orbit>
    @State var orbitFilter: String? = nil
    
    var statuses = Status.Filter.allCases
    @State var statusFilter: String? = nil
    
    var isFiltered: Bool { providerFilter != nil || orbitFilter != nil || statusFilter != nil }
    var currentFilters: [String] {
        var filters: [String] = []
        if orbitFilter != nil { filters.append(orbitFilter ?? "") }
        if statusFilter != nil { filters.append(statusFilter ?? "") }
        if providerFilter != nil {
            filters.append(Provider.providerFor(name: providerFilter!, context: viewContext)?.compactName ?? "")
        }
        return filters
    }
    func removeAllFilters() { providerFilter = nil; orbitFilter = nil; statusFilter = nil }
        
    init() {
        _providers = FetchRequest(fetchRequest: Provider.requestForAll())
        _orbits = FetchRequest(fetchRequest: Orbit.requestForAll())
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                //MARK: - Main View
                FilteredLaunchListView(pinnedIDs: pinned.launchIDs, showPinned: $showPinned, providerFilter: $providerFilter, statusFilter: $statusFilter, orbitFilter: $orbitFilter, sortAscending: sortOrderAscending)
                    .id(launchLibraryClient.lastSuccessfulFetch)
                //MARK: - On Appear
                .onAppear { onViewAppear() }
                //MARK: - Alerts
                .alert(item: $launchLibraryClient.fetchError) { fetchError in
                    fetchError.alert
                }
                //MARK: - Navigation and ToolBar
                .navigationBarTitleDisplayMode(.inline)
                //TODO: Not available on MacOS
                .toolbar {
                    //Navigation ToolBar
                    ToolbarItem(placement: .principal) { toolBarTitle }
                    ToolbarItem(placement: .automatic) { refreshToolBarItem }
                    
                    //Bottom ToolBar
                    ToolbarItem(placement: .bottomBar) { filterToolBarItem }
                    ToolbarItem(placement: .bottomBar) { Spacer() }
                    ToolbarItem(placement: .bottomBar) { currentFiltersToolBarItem }
                    ToolbarItem(placement: .bottomBar) { Spacer() }
                    ToolbarItem(placement: .bottomBar) { pinToolBarItem }
                }
            }
            .accentColor(.app.control)
            if isDownloading { LaunchLibraryActivityIndicator() }
        }
    }
    
    //MARK: Refreshing data
    func onViewAppear() {
        if Launch.count(in: viewContext) == 0 {
            refreshLaunches(deletingFirst: true)
        }
    }
    
    func refreshLaunches(deletingFirst: Bool = false) {
        withAnimation {
            launchLibraryClient.fetchData(.upcomingLaunches)
        }
    }
            
}

//MARK: ToolBar Items
extension UpcomingLaunchesView {
    var toolBarTitle: some View {
        HStack() {
//                            Image(showPinned ? "nosecone.fill" : "nosecone.fill")
            Text(showPinned ? "Tracking" : "Departing Earth")
                .font(.system(size: 18, weight: .bold, design: .monospaced))
        }
        .foregroundColor(.app.textAccented)
    }
    
    var filterToolBarItem: some View {
        filterMenu
            .foregroundColor(.app.control)
    }
    
    var refreshToolBarItem: some View {
        Button(
            action: { refreshLaunches(deletingFirst: true) },
            label: { Label("Refresh", systemImage: "arrow.clockwise.circle") }
        )
    }
    
    var pinToolBarItem: some View {
        Button(
            action: { withAnimation { showPinned.toggle() } },
            label: { Label("Pinned", systemImage: showPinned ? "pin.circle.fill" : "pin.circle") }
        )
        .disabled(showPinned == false && pinned.launchIDs.count == 0)
    }
    
    var currentFiltersToolBarItem: some View {
        HStack {
            Text(isFiltered ? "Filtered: " : "")
            VStack() {
                ForEach(currentFilters, id: \.self) { filter in
                    Text(filter)
                }
                .foregroundColor(.gray)
            }
            Spacer()
        }
        .font(.app.rowDetail)
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
                    let tag: String? = status.rawValue
                        Text(status.rawValue).tag(tag)
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
            .environmentObject(PinnedLaunches.shared)
    }
}
