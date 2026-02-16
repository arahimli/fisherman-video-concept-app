// blocs/video_bloc.dart
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../data/database/app_database.dart';
import '../../../data/services/image_service.dart';
import '../../../data/services/video_service.dart' show VideoService;
import 'package:drift/drift.dart' as drift;

part 'video_event.dart';
part 'video_state.dart';
part 'video_bloc.dart';