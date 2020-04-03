//
//  UserDetail.swift
//  DemoPractSwiftUI
//
//  Created by Israrul on 4/2/20.
//  Copyright © 2020 Israrul Haque. All rights reserved.
//

import SwiftUI
import Combine

let repoList = ["repo1","repo1","repo1","repo1","repo1","repo1"]

struct UserDetail: View {
    let user: User
    init(user: User) {
        self.user = user
    }
    
 //   let user: User
    @ObservedObject var networkManager = NetworkManager2(urlString: self.use)
    @State var searchText = ""
    var body: some View {
            List {
                VStack {
                        HStack{
                            URLImage(url: user.avatar_url)
                                .frame(width: 120, height: 120)
                                .padding(.leading, 10)
                                .clipped()
                                .cornerRadius(10)
                            Spacer()
                            VStack {
                                Text("Name")
                                Text("Email")
                                Text("Location")
                                Text("Join Date")
                                Text("5 Follower")
                                Text("Following 8")
                            }
                            .frame(width: 100, height: 100, alignment: .trailing)
                            .padding(.all)
                        }
                    Text("Description User")
                        .padding(.all)
                    SearchBar(text: $searchText)
                    List {
                        
                        ForEach(networkManager.users, id: \.id) { (users) in
                             RepoCellDetail(repoDetail: UserRepoLists(id: 123, name: "DummyData", html_url: "Google.com", stargazers_count: 45, forks_count: 23))
                        }
                        
                       
//                        ForEach(users.filter({ (user) -> Bool in
//                            searchText.isEmpty ? true : user.login.localizedCaseInsensitiveContains(searchText)
//                                       }), id: \.id) { user in
//                                           NavigationLink(destination:
//                                           UserDetail(user: user, users: self.users)){
//                                           UserRowView(user: user)
//                                           }
//                                       }
                    }.navigationBarTitle("Detail")
                }
            }
    }
}

struct UserDetail_Previews: PreviewProvider {
    
   // var users = [User]()
    
    static var previews: some View {
        UserDetail(user: User(id: 1, avatar_url: "lol", url: "lol2", login: "lok", repos_url: "pol"), networkManager: NetworkManager2())
    }
}
//
//user: User(id: 1, avatar_url: "lol", url: "lol2", login: "lok", repos_url: "pol"), users: [User(id: 1, avatar_url: "lol", url: "lol2", login: "lok", repos_url: "pol"), User(id: 1, avatar_url: "lol", url: "lol2", login: "lok", repos_url: "pol")

struct UserDetails: Codable, Hashable {
    var id: Int
    var avatar_url: String
    var repos_url: String
    var name: String
    var created_at: String
    var email: String
    var location: String
    var following: Int
    var followers: Int
    var bio: String
}

struct UserRepoLists: Codable, Hashable {
    var id: Int
    var name: String
    var html_url: String
    var stargazers_count: Int
    var forks_count: Int
}

class NetworkManager2: ObservableObject {
    var objectWillChange = PassthroughSubject<NetworkManager2, Never>()
    
    var usersDetails = UserDetails.self {
        didSet {
            objectWillChange.send(self)
        }
    }
    init(urlString: String) {
        var urlString = urlString
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            let usersDetails = try? decoder.decode(UserDetails.self, from: data)
            DispatchQueue.main.async {
                self.usersDetails = usersDetails ?? UserDetails(id: 1, avatar_url: "", repos_url: "", name: "", created_at: "", email: "", location: "", following: 3, followers: 3, bio: "")
            }
        }.resume()
    }
}
