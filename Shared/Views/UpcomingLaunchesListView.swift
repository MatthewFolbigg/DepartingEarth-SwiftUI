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
    @ObservedObject var LaunchLibrary: LaunchLibraryApiClient
    
    @FetchRequest var launches: FetchedResults<Launch>
    init(_ client: LaunchLibraryApiClient) {
        let request = NSFetchRequest<Launch>(entityName: "Launch")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        _launches = FetchRequest(fetchRequest: request)
        self.LaunchLibrary = client
    }
   
    //MARK: - Main Body
    var body: some View {
        VStack {
            if LaunchLibrary.fetchStatus == .fetching {
                ProgressView()
            }
            List {
                ForEach(launches) { launch in
                    Text("\(launch.name!) - \(launch.provider!)")
                }
            }
        }
        .onAppear() {
            print("Appear")
            LaunchLibrary.fetchData(.upcomingLaunches)
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
