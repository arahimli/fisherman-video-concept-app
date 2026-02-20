part of 'bloc.dart';

abstract class HistoryEvent {}

class LoadHistoryEvent extends HistoryEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final bool loadMore;

  LoadHistoryEvent({
    this.startDate,
    this.endDate,
    this.loadMore = false,
  });
}

class LoadRecentVideosEvent extends HistoryEvent {}

class DeleteVideoEvent extends HistoryEvent {
  final int videoId;

  DeleteVideoEvent(this.videoId);
}

class FilterByDateEvent extends HistoryEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  FilterByDateEvent({this.startDate, this.endDate});
}