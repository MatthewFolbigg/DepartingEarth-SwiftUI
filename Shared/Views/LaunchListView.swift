//
//  LaunchListView.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 03/08/2021.
//

import SwiftUI
import CoreData

struct LaunchListView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest var launches: FetchedResults<Launch>
    
    init(request: NSFetchRequest<Launch>) {
        _launches = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        ZStack {
            if launches.count == 0 {
                Spacer()
                Text("No Launches")
                    .font(.system(.title3, design: .rounded))
                    .foregroundColor(.secondary)
                    .fontWeight(.light)
                Spacer()
                Spacer()
            } else {
                List {
                    ForEach(launches) { launch in
                        ZStack {
                            LaunchListItemView(launch: launch)
                            NavigationLink(destination: LaunchDetailView(launch: launch)) { EmptyView() }.hidden()
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                }
                .listStyle(PlainListStyle())
                .background(Color.ui.greyBlueBackground)
                .onAppear {
                    if launches.isEmpty {
                        print("Data Downloaded")
                        LaunchLibraryApiClient.shared.fetchData(.upcomingLaunches)
                    } else {
                        //TODO: Check for stale Date
                        print("Data Loaded")
                    }
                }
            }
        }}
}




//struct LaunchListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = PersistenceController.shared.container.viewContext
//        LaunchListView(request: Launch.requestForAll(sortBy: .date)).environment(\.managedObjectContext, context)
//    }
//}
