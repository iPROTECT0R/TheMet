// WidgetView.swift
// Created by Raymond Shelton on 9/26/24.
// This view displays the content of the widget, showcasing objects from The Met.


import SwiftUI
import WidgetKit
struct WidgetView: View {
    let entry: Provider.Entry

    var body: some View {
        VStack {
            Text("The Met")  // Title of the widget
                .font(.headline)
                .padding(.top)
            Divider()  // Visual separation line

            // Display different views based on the object's public domain status
            if !entry.object.isPublicDomain {
                WebIndicatorView(title: entry.object.title)
                    .padding()
                    .background(Color.metBackground)
                    .foregroundColor(.white)
            } else {
                DetailIndicatorView(title: entry.object.title)
                    .padding()
                    .background(Color.metForeground)
            }
        }
        .truncationMode(.middle)  // Truncates the text in the middle if it's too long
        .fontWeight(.semibold)
        .widgetURL(URL(string: "themet://\(entry.object.objectID)"))  // URL for widget interaction
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WidgetView(
                entry: SimpleEntry(
                    date: Date(),
                    object: Object.sample(isPublicDomain: true)))
            .previewContext(WidgetPreviewContext(family: .systemLarge))

            WidgetView(
                entry: SimpleEntry(
                    date: Date(),
                    object: Object.sample(isPublicDomain: false)))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}


struct DetailIndicatorView: View {
    let title: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)  // Display the title of the object
            Spacer()
            Image(systemName: "doc.text.image.fill")  // Icon indicating image content
        }
    }
}
