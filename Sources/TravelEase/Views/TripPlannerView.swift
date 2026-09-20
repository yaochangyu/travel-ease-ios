#if canImport(SwiftUI)
import SwiftUI

public struct TripPlannerView: View {
    @Bindable var viewModel: TravelViewModel

    public init(viewModel: TravelViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Day Selector Tabs
            daySelectorBar

            // MARK: - Timeline Activities
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    if let currentSchedule = currentSchedule {
                        // Day Header
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(currentSchedule.dateTitle)
                                    .font(AppTypography.headline)
                                    .foregroundColor(AppColors.foreground)
                                Text("已規劃 \(currentSchedule.activities.count) 個行程點")
                                    .font(AppTypography.caption)
                                    .foregroundColor(AppColors.mutedText)
                            }
                            Spacer()
                            Button(action: {
                                // Add custom activity
                            }) {
                                Label("新增景點", systemImage: "plus")
                                    .font(AppTypography.callout)
                                    .foregroundColor(AppColors.primary)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(AppColors.primary.opacity(0.1))
                                    .cornerRadius(AppCornerRadius.sm)
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.top, AppSpacing.md)

                        // Timeline Nodes
                        VStack(spacing: 0) {
                            ForEach(Array(currentSchedule.activities.enumerated()), id: \.element.id) { index, activity in
                                TimelineActivityNode(
                                    activity: activity,
                                    isLast: index == currentSchedule.activities.count - 1,
                                    onToggleComplete: {
                                        viewModel.toggleActivityCompleted(
                                            dayIndex: viewModel.selectedDayIndex,
                                            activityId: activity.id
                                        )
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                    }
                }
                .padding(.bottom, AppSpacing.xxl)
            }
        }
        .background(AppColors.background)
        .navigationTitle("行程時間軸")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var currentSchedule: TripDaySchedule? {
        guard viewModel.selectedDayIndex < viewModel.tripSchedules.count else { return nil }
        return viewModel.tripSchedules[viewModel.selectedDayIndex]
    }

    private var daySelectorBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                ForEach(0..<viewModel.tripSchedules.count, id: \.self) { idx in
                    let schedule = viewModel.tripSchedules[idx]
                    Button(action: {
                        withAnimation(.spring(duration: 0.2)) {
                            viewModel.selectedDayIndex = idx
                        }
                    }) {
                        VStack(spacing: 2) {
                            Text("Day \(schedule.dayNumber)")
                                .font(AppTypography.callout)
                                .fontWeight(.bold)
                            Text("\(schedule.activities.count) 景點")
                                .font(AppTypography.caption)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            viewModel.selectedDayIndex == idx ?
                            AppColors.primary : Color.white
                        )
                        .foregroundColor(
                            viewModel.selectedDayIndex == idx ?
                            Color.white : AppColors.bodyText
                        )
                        .cornerRadius(AppCornerRadius.md)
                        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
        }
        .background(Color.white)
        .overlay(Divider(), alignment: .bottom)
    }
}

// MARK: - Timeline Activity Node Component
struct TimelineActivityNode: View {
    let activity: TripActivity
    let isLast: Bool
    let onToggleComplete: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            // Time and Vertical Line
            VStack(spacing: 4) {
                Text(activity.timeString)
                    .font(AppTypography.captionBold)
                    .foregroundColor(AppColors.primary)

                Circle()
                    .fill(activity.isCompleted ? AppColors.success : AppColors.primary)
                    .frame(width: 12, height: 12)

                if !isLast {
                    Rectangle()
                        .fill(AppColors.muted)
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(width: 48)

            // Content Card
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(activity.title)
                        .font(AppTypography.headline)
                        .foregroundColor(activity.isCompleted ? AppColors.mutedText : AppColors.foreground)
                        .strikethrough(activity.isCompleted)
                    Spacer()
                    Button(action: onToggleComplete) {
                        Image(systemName: activity.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(activity.isCompleted ? AppColors.success : AppColors.mutedText)
                            .font(.system(size: 18))
                    }
                }

                Text(activity.subtitle)
                    .font(AppTypography.subheadline)
                    .foregroundColor(AppColors.mutedText)

                if let transit = activity.transitInfo {
                    HStack(spacing: 4) {
                        Image(systemName: "figure.walk")
                            .font(.system(size: 11))
                        Text(transit)
                            .font(AppTypography.caption)
                    }
                    .foregroundColor(AppColors.accent)
                    .padding(.top, 2)
                }
            }
            .padding(14)
            .appCard()
            .padding(.bottom, AppSpacing.md)
        }
    }
}
#endif
