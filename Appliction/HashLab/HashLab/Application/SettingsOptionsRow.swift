//
//  SettingsOptionsRow.swift
//  HashLab
//
//  Created by Thejas Kasaba on 27/07/26.
//
import SwiftUI

struct SettingOptionRow: View {

    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            HStack(alignment: .top, spacing: 16) {

                Image(systemName: isSelected
                      ? "largecircle.fill.circle"
                      : "circle")
                    .font(.title3)
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 6) {

                    Text(title)
                        .font(.headline)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
    }
}
