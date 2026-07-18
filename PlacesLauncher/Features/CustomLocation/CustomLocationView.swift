import MapKit
import SwiftUI
import UIKit

struct CustomLocationView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @FocusState private var isSearchFocused: Bool

    @StateObject private var viewModel: CustomLocationViewModel
    @State private var cameraPosition: MapCameraPosition
    @State private var searchTask: Task<Void, Never>?
    @State private var alertMessage: String?

    let wikipediaOpener: any WikipediaOpening

    init(
        viewModel: CustomLocationViewModel,
        wikipediaOpener: any WikipediaOpening
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.wikipediaOpener = wikipediaOpener

        let initial = viewModel.selectedCoordinate
            ?? CLLocationCoordinate2D(latitude: 52.36760, longitude: 4.90410)
        _cameraPosition = State(
            initialValue: .region(
                MKCoordinateRegion(
                    center: initial,
                    span: MKCoordinateSpan(latitudeDelta: 0.12, longitudeDelta: 0.12)
                )
            )
        )
    }

    var body: some View {
        Map(position: $cameraPosition, interactionModes: .all)
            .mapStyle(.standard(elevation: .realistic))
            .mapControls {
                MapCompass()
                MapScaleView()
            }
            .onMapCameraChange(frequency: .onEnd) { context in
                viewModel.updateMapCenter(context.region.center)
            }
            .overlay {
                centerPin
            }
            .overlay(alignment: .top) {
                searchBar
                    .padding(.horizontal, 14)
                    .padding(.top, 10)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                confirmationPanel
            }
            .navigationTitle(L10n.Custom.title)
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                searchTask?.cancel()
            }
            .onChange(of: viewModel.cameraRevision) {
                guard let coordinate = viewModel.selectedCoordinate else { return }
                let update = {
                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                        )
                    )
                }
                if reduceMotion {
                    update()
                } else {
                    withAnimation(.easeInOut(duration: 0.32), update)
                }
                UIAccessibility.post(
                    notification: .announcement,
                    argument: L10n.Custom.Accessibility.mapMoved(
                        viewModel.selectedName ?? L10n.Custom.searchResult
                    )
                )
            }
            .onChange(of: viewModel.errorMessage) {
                guard let message = viewModel.errorMessage else { return }
                UIAccessibility.post(notification: .announcement, argument: message)
            }
            .alert(
                L10n.Wikipedia.Error.title,
                isPresented: Binding(
                    get: { alertMessage != nil },
                    set: { if !$0 { alertMessage = nil } }
                )
            ) {
                Button(L10n.Common.ok, role: .cancel) {}
            } message: {
                Text(alertMessage ?? L10n.Wikipedia.Error.fallback)
            }
    }

    private var searchBar: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)

                TextField(L10n.Custom.Search.placeholder, text: $viewModel.query)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled(false)
                    .submitLabel(.search)
                    .focused($isSearchFocused)
                    .onSubmit(runSearch)
                    .accessibilityHint(L10n.Custom.Accessibility.searchHint)

                if viewModel.isSearching {
                    ProgressView()
                        .controlSize(.small)
                        .accessibilityLabel(L10n.Custom.Accessibility.searching)
                } else if !viewModel.query.isEmpty {
                    Button {
                        viewModel.query = ""
                        viewModel.clearError()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel(L10n.Custom.Accessibility.clearSearch)
                }

                Button(action: runSearch) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title2)
                }
                .buttonStyle(.plain)
                .disabled(viewModel.isSearching)
                .accessibilityLabel(L10n.Custom.Accessibility.search)
            }
            .padding(.horizontal, 12)
            .frame(minHeight: 50)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))

            if let error = viewModel.errorMessage {
                Label(error, systemImage: "exclamationmark.triangle.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                    .accessibilityElement(children: .combine)
            }
        }
    }

    private var centerPin: some View {
        VStack(spacing: 0) {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 46, weight: .semibold))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, AppPalette.blue)
                .shadow(color: .black.opacity(0.24), radius: 4, y: 3)
            Circle()
                .fill(Color.black.opacity(0.22))
                .frame(width: 9, height: 5)
        }
        .offset(y: -22)
        .allowsHitTesting(false)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.Custom.Accessibility.pinLabel)
        .accessibilityValue(L10n.Custom.Accessibility.pinValue)
    }

    private var confirmationPanel: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "mappin")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppPalette.blue)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.selectedName ?? L10n.Custom.droppedPin)
                        .font(.headline)
                    Text(selectedCoordinateText)
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(
                L10n.Custom.Accessibility.selected(
                    viewModel.selectedName ?? L10n.Custom.droppedPinName,
                    selectedCoordinateText
                )
            )

            Button(action: confirmSelection) {
                Label(L10n.Custom.openWikipedia, systemImage: "arrow.up.forward.app.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 50)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.selectedCoordinate == nil)
            .accessibilityHint(L10n.Custom.Accessibility.confirmHint)
        }
        .padding(.horizontal, 18)
        .padding(.top, 16)
        .padding(.bottom, 10)
        .background(.ultraThickMaterial)
    }

    private var selectedCoordinateText: String {
        guard let coordinate = viewModel.selectedCoordinate else {
            return L10n.Custom.moveMapToSelect
        }
        return PlaceLocation(
            name: nil,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        ).formattedCoordinates
    }

    private func runSearch() {
        searchTask?.cancel()
        isSearchFocused = false
        searchTask = Task {
            await viewModel.search()
        }
    }

    private func confirmSelection() {
        Task {
            do {
                let location = try viewModel.confirmedLocation()
                try await wikipediaOpener.open(location: location)
            } catch {
                alertMessage = error.localizedDescription
            }
        }
    }
}
