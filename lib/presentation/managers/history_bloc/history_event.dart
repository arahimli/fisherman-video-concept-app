part of 'bloc.dart';

abstract class HistoryEvent {}

class LoadHistoryEvent extends HistoryEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? language;
  final bool loadMore;

  LoadHistoryEvent({
    this.startDate,
    this.endDate,
    this.language,
    this.loadMore = false,
  });
}

class DeleteVideoEvent extends HistoryEvent {
  final int videoId;

  DeleteVideoEvent(this.videoId);
}

class FilterByDateEvent extends HistoryEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  FilterByDateEvent({this.startDate, this.endDate});
}

class FilterByLanguageEvent extends HistoryEvent {
  final String? language;

  FilterByLanguageEvent({this.language});
}