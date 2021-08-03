//
//  UpcomingLaunchesListView.swift
//  Shared
//
//  Created by Matthew Folbigg on 02/08/2021.
//

import SwiftUI
import CoreData

struct UpcomingLaunchesListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var launches: FetchedResults<Launch>
    @ObservedObject var launchLibrary: LaunchLibraryApiClient
    
    init(_ client: LaunchLibraryApiClient) {
        self.launchLibrary = client
        let request = Launch.requestForAll(sortBy: .date)
        _launches = FetchRequest(fetchRequest: request)
    }

    //MARK: - Main Body
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    List(launches) { launch in
                        LaunchListItem(launch: launch)
                    }
                    if launchLibrary.fetchStatus == .fetching {
                        launchLibraryActivityIndicator
                    }
                }
                .listStyle(PlainListStyle())
                deleteAllButton
            }
            .navigationTitle("Departing Soon")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    refreshButton
                }
            }
        }
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
        let context = PersistenceController.preview.container.viewContext
        UpcomingLaunchesListView(LaunchLibraryApiClient()).environment(\.managedObjectContext, context)
    }
}
