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
        VStack {
            if launches.count == 0 {
                Spacer()
                Text("No Launches")
                    .foregroundColor(.gray)
                    .fontWeight(.thin)
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
//        LaunchListView().environment(\.managedObjectContext, context)
//    }
//}
