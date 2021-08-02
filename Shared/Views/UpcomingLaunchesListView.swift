//
//  UpcomingLaunchesListView.swift
//  Shared
//
//  Created by Matthew Folbigg on 02/08/2021.
//

import SwiftUI
import CoreData

struct UpcomingLaunchesListView: View {
    //MARK: - Environment
    @Environment(\.managedObjectContext) private var viewContext
    
    //MARK: -
    @ObservedObject var launchLibrary: LaunchLibraryApiClient
    @FetchRequest var launches: FetchedResults<Launch>
    
    init(_ client: LaunchLibraryApiClient) {
        let request = NSFetchRequest<Launch>(entityName: "Launch")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        _launches = FetchRequest(fetchRequest: request)
        self.launchLibrary = client
    }
   
    //MARK: - Main Body
    var body: some View {
        VStack {
            if launchLibrary.fetchStatus == .fetching {
                ProgressView()
            }
            List() {
                ForEach(launches) { launch in
                    VStack(alignment: .leading) {
                        Text("\(launch.provider!)")
                        Text("\(launch.name!)")
                            .fontWeight(.thin)
                    }
                }
            }
            Button(action: { launchLibrary.fetchData(.upcomingLaunches) }, label: { Text("Get Launches") })
            Button(action: { Launch.deleteAll(from: viewContext) }, label: { Text("Delete") })
        }
    }
    
}


//MARK: Previews
struct UpcomingLaunchesListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        UpcomingLaunchesListView(LaunchLibraryApiClient(context: context)).environment(\.managedObjectContext, context)
    }
}
