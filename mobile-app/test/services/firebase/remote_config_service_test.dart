import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/service/firebase/remote_config_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RemoteConfigService activation overrides', () {
    test('reads superblock override from activation_overrides', () {
      final service = RemoteConfigService.withConfigReader(
        (_) => '{"javascript-algorithms-and-data-structures": false}',
      );

      expect(
        service.getActivationOverride(
          superBlockDashedName: 'javascript-algorithms-and-data-structures',
        ),
        isFalse,
      );

      expect(
        service.isActive(
          superBlockDashedName: 'javascript-algorithms-and-data-structures',
          fallbackValue: true,
        ),
        isFalse,
      );
    });

    test('reads block override from superblock/block scoped key', () {
      final service = RemoteConfigService.withConfigReader(
        (_) =>
            '{"javascript-algorithms-and-data-structures/basic-javascript": false}',
      );

      expect(
        service.getActivationOverride(
          superBlockDashedName: 'javascript-algorithms-and-data-structures',
          blockDashedName: 'basic-javascript',
        ),
        isFalse,
      );

      expect(
        service.isActive(
          superBlockDashedName: 'javascript-algorithms-and-data-structures',
          blockDashedName: 'basic-javascript',
          fallbackValue: true,
        ),
        isFalse,
      );
    });

    test('returns fallback when override is missing', () {
      final service = RemoteConfigService.withConfigReader((_) => '{}');

      expect(
        service.isActive(
          superBlockDashedName: 'javascript-algorithms-and-data-structures',
          fallbackValue: true,
        ),
        isTrue,
      );

      expect(
        service.isActive(
          superBlockDashedName: 'javascript-algorithms-and-data-structures',
          blockDashedName: 'basic-javascript',
          fallbackValue: false,
        ),
        isFalse,
      );
    });

    test('ignores invalid override config payloads', () {
      final invalidShapeService = RemoteConfigService.withConfigReader(
        (_) => '["not-a-map"]',
      );

      expect(
        invalidShapeService.getActivationOverride(
          superBlockDashedName: 'javascript-algorithms-and-data-structures',
        ),
        isNull,
      );

      final nonBooleanValueService = RemoteConfigService.withConfigReader(
        (_) => '{"javascript-algorithms-and-data-structures": "false"}',
      );

      expect(
        nonBooleanValueService.getActivationOverride(
          superBlockDashedName: 'javascript-algorithms-and-data-structures',
        ),
        isNull,
      );
    });
  });
}
