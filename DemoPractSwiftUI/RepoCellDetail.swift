//
//  RepoCellDetail.swift
//  DemoPractSwiftUI
//
//  Created by Israrul on 4/2/20.
//  Copyright © 2020 Israrul Haque. All rights reserved.
//

import SwiftUI

struct RepoCellDetail: View {
    let repoDetail: UserRepoLists
    
    var body: some View {
        HStack {
            Text(repoDetail.name)
                .padding(.leading, 20)
            Spacer()
            VStack {
                Text("\(repoDetail.stargazers_count) Stars")
                Text("\(repoDetail.forks_count) Forks")
            }
            .padding(.trailing, 20)
        }
    }
}

struct RepoCellDetail_Previews: PreviewProvider {
    static var previews: some View {
        RepoCellDetail(repoDetail: UserRepoLists(id: 1, name: "Loki", html_url: "lokij", stargazers_count: 2, forks_count: 4))
    }
}
