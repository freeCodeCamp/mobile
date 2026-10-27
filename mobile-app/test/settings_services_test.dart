import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/services/notification_service.dart';
import 'package:freecodecamp/settings/services/app_preferences.dart';
import 'package:freecodecamp/settings/services/learning_reminder_service.dart';
import 'package:freecodecamp/settings/services/local_data_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class _Reminders extends LearningReminderService {
  _Reminders() : super(NotificationService());
  bool denied = false;
  int scheduled = 0;
  int canceled = 0;
  @override
  Future<void> enable() async {
    if (denied) throw ReminderPermissionDenied();
    scheduled++;
  }

  @override
  Future<void> cancel() async {
    canceled++;
  }
}

class _FailingPreferences implements SharedPreferences {
  _FailingPreferences(this.enabled, this.throws) : cachedEnabled = enabled;
  final bool enabled;
  final bool throws;
  bool cachedEnabled;
  String cachedTheme = 'system';
  @override
  bool? getBool(String key) => cachedEnabled;
  @override
  String? getString(String key) => cachedTheme;
  @override
  Future<bool> setBool(String key, bool value) async {
    cachedEnabled = value;
    if (throws) throw PlatformException(code: 'test_write_failure');
    return false;
  }

  @override
  Future<bool> setString(String key, String value) async {
    cachedTheme = value;
    if (throws) throw PlatformException(code: 'test_write_failure');
    return false;
  }

  @override
  Future<void> reload() async {
    cachedEnabled = enabled;
    cachedTheme = 'system';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  setUpAll(tz_data.initializeTimeZones);

  test(
    'theme modes survive fresh provider containers and invalid values fall back',
    () async {
      for (final mode in ThemeMode.values) {
        final first = ProviderContainer();
        await first.read(appPreferencesProvider.future);
        await first.read(appPreferencesProvider.notifier).setTheme(mode);
        first.dispose();
        final reopened = ProviderContainer();
        expect(
          (await reopened.read(appPreferencesProvider.future)).themeMode,
          mode,
        );
        reopened.dispose();
      }
      await (await SharedPreferences.getInstance()).setString(
        AppPreferencesNotifier.themeKey,
        'invalid',
      );
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(
        (await container.read(appPreferencesProvider.future)).themeMode,
        ThemeMode.system,
      );
    },
  );

  test(
    'reminder permission failures do not persist an enabled toggle',
    () async {
      final reminders = _Reminders()..denied = true;
      final container = ProviderContainer(
        overrides: [
          learningReminderServiceProvider.overrideWithValue(reminders),
        ],
      );
      addTearDown(container.dispose);
      await container.read(appPreferencesProvider.future);
      await expectLater(
        container.read(appPreferencesProvider.notifier).setDailyReminder(true),
        throwsA(isA<ReminderPermissionDenied>()),
      );
      expect(
        (await container.read(appPreferencesProvider.future)).dailyReminder,
        isFalse,
      );
      expect(
        (await SharedPreferences.getInstance()).getBool(
          AppPreferencesNotifier.reminderKey,
        ),
        isNull,
      );
      reminders.denied = false;
      await container
          .read(appPreferencesProvider.notifier)
          .setDailyReminder(true);
      expect(reminders.scheduled, 1);
      final reopened = ProviderContainer();
      expect(
        (await reopened.read(appPreferencesProvider.future)).dailyReminder,
        isTrue,
      );
      reopened.dispose();
      await container
          .read(appPreferencesProvider.notifier)
          .setDailyReminder(false);
      expect(reminders.canceled, 1);
      expect(
        (await SharedPreferences.getInstance()).getBool(
          AppPreferencesNotifier.reminderKey,
        ),
        isFalse,
      );
    },
  );

  test(
    'daily reminder remains at local 9am across DST and month boundaries',
    () {
      final amsterdam = tz.getLocation('Europe/Amsterdam');
      for (final now in [
        tz.TZDateTime(amsterdam, 2026, 3, 28, 22),
        tz.TZDateTime(amsterdam, 2026, 10, 24, 22),
        tz.TZDateTime(amsterdam, 2026, 12, 31, 23),
      ]) {
        final next = nextReminderTime(now);
        expect(next.hour, 9);
        expect(next.isAfter(now), isTrue);
        expect(next.day, now.day == 31 ? 1 : now.day + 1);
      }
      expect(
        nextReminderTime(tz.TZDateTime(amsterdam, 2026, 10, 15, 8)).day,
        15,
      );
      expect(
        nextReminderTime(tz.TZDateTime(amsterdam, 2026, 10, 15, 9)).day,
        16,
      );
    },
  );

  test(
    'reset drains playback before clearing data and refreshes state',
    () async {
      final events = <String>[];
      final playback = Completer<void>();
      final service = LocalDataResetService(
        downloadsInProgress: () => false,
        stopPlayback: () async {
          events.add('stop');
          await playback.future;
        },
        clearBookmarks: () async {
          events.add('bookmarks');
        },
        clearDownloads: () async {
          events.add('downloads');
        },
        cancelReminder: () async {
          events.add('reminder');
        },
        signOut: () async {
          events.add('sign-out');
        },
        clearPreferences: () async {
          events.add('preferences');
        },
        refreshState: () {
          events.add('refresh');
        },
      );
      final reset = service.reset();
      await Future<void>.delayed(Duration.zero);
      expect(events, ['stop']);
      await expectLater(service.reset(), throwsStateError);
      playback.complete();
      await reset;
      expect(events, [
        'stop',
        'bookmarks',
        'downloads',
        'reminder',
        'sign-out',
        'preferences',
        'refresh',
      ]);
    },
  );

  test(
    'active transfers prevent reset and partial failures are not success',
    () async {
      var active = true;
      var refreshed = 0;
      var cleared = false;
      final service = LocalDataResetService(
        downloadsInProgress: () => active,
        stopPlayback: () async {},
        clearBookmarks: () async {
          throw const FileSystemException('test failure');
        },
        clearDownloads: () async {
          cleared = true;
        },
        cancelReminder: () async {},
        signOut: () async {},
        clearPreferences: () async {},
        refreshState: () {
          refreshed++;
        },
      );
      await expectLater(service.reset(), throwsA(isA<DownloadsInProgress>()));
      expect(refreshed, 0);
      active = false;
      await expectLater(service.reset(), throwsA(isA<FileSystemException>()));
      expect(refreshed, 1);
      expect(cleared, isFalse);
    },
  );

  test(
    'storage size and reset cover audio/artwork without deleting other documents',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'fcc-local-reset-test-',
      );
      addTearDown(() => root.delete(recursive: true));
      final audio = File('${root.path}/episodes/podcast/episode.mp3');
      await audio.parent.create(recursive: true);
      await audio.writeAsBytes(List.filled(1024, 1));
      final artwork = File('${root.path}/images/podcast/cover.jpg');
      await artwork.parent.create(recursive: true);
      await artwork.writeAsBytes(List.filled(512, 1));
      final other = await File(
        '${root.path}/my-project.txt',
      ).writeAsString('keep');
      final files = LocalDataFiles(documentsDirectory: () async => root);
      expect(await files.downloadedBytes(), 1536);
      await files.clearDownloads();
      expect(await files.downloadedBytes(), 0);
      expect(await other.readAsString(), 'keep');
      await files.clearDownloads();
    },
  );
  for (final initial in [false, true]) {
    for (final throws in [false, true]) {
      test(
        'reminder write ${throws ? 'exception' : 'false'} restores ${initial ? 'enabled' : 'disabled'} schedule',
        () async {
          final reminders = _Reminders();
          final container = ProviderContainer(
            overrides: [
              settingsPreferencesStoreProvider.overrideWith(
                (ref) async => _FailingPreferences(initial, throws),
              ),
              learningReminderServiceProvider.overrideWithValue(reminders),
            ],
          );
          addTearDown(container.dispose);
          await container.read(appPreferencesProvider.future);
          await expectLater(
            container
                .read(appPreferencesProvider.notifier)
                .setDailyReminder(!initial),
            throwsA(throws ? isA<PlatformException>() : isA<StateError>()),
          );
          expect(reminders.scheduled, 1);
          expect(reminders.canceled, 1);
          expect(
            container.read(appPreferencesProvider).requireValue.dailyReminder,
            initial,
          );
          container.invalidate(appPreferencesProvider);
          expect(
            (await container.read(appPreferencesProvider.future)).dailyReminder,
            initial,
          );
        },
      );
    }
  }
  for (final throws in [false, true]) {
    test(
      'theme write ${throws ? 'exception' : 'false'} reloads the platform cache',
      () async {
        final prefs = _FailingPreferences(false, throws);
        final container = ProviderContainer(
          overrides: [
            settingsPreferencesStoreProvider.overrideWith((ref) async => prefs),
          ],
        );
        addTearDown(container.dispose);
        await container.read(appPreferencesProvider.future);
        await expectLater(
          container
              .read(appPreferencesProvider.notifier)
              .setTheme(ThemeMode.dark),
          throwsA(throws ? isA<PlatformException>() : isA<StateError>()),
        );
        expect(prefs.cachedTheme, 'system');
        container.invalidate(appPreferencesProvider);
        expect(
          (await container.read(appPreferencesProvider.future)).themeMode,
          ThemeMode.system,
        );
      },
    );
  }
}
