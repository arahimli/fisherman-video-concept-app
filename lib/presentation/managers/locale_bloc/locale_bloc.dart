part of 'bloc.dart';

const _supportedCodes = {'ar', 'az', 'en', 'es', 'fr', 'hi', 'ru', 'tr', 'zh'};

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  static const _key = 'app_locale';

  LocaleBloc() : super(const LocaleState(Locale('en'))) {
    on<LoadLocaleEvent>(_onLoad);
    on<ChangeLocaleEvent>(_onChange);
    add(LoadLocaleEvent());
  }

  Future<void> _onLoad(
    LoadLocaleEvent event,
    Emitter<LocaleState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);

    if (saved != null) {
      emit(LocaleState(Locale(saved)));
      return;
    }

    // No saved preference — detect from system locales
    final systemLocales =
        WidgetsBinding.instance.platformDispatcher.locales;
    for (final locale in systemLocales) {
      if (_supportedCodes.contains(locale.languageCode)) {
        emit(LocaleState(Locale(locale.languageCode)));
        return;
      }
    }

    // Fallback to English
    emit(const LocaleState(Locale('en')));
  }

  Future<void> _onChange(
    ChangeLocaleEvent event,
    Emitter<LocaleState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, event.locale.languageCode);
    emit(LocaleState(event.locale));
  }
}
