import 'package:ditonton/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Constants', () {
    test('BASE_IMAGE_URL should have the correct value', () {
      expect(baseUrlImage, 'https://image.tmdb.org/t/p/w500');
    });

    group('Colors', () {
      test('kRichBlack should have the correct value', () {
        expect(kRichBlack, const Color(0xFF000814));
      });

      test('kOxfordBlue should have the correct value', () {
        expect(kOxfordBlue, const Color(0xFF001D3D));
      });

      test('kPrussianBlue should have the correct value', () {
        expect(kPrussianBlue, const Color(0xFF003566));
      });

      test('kMikadoYellow should have the correct value', () {
        expect(kMikadoYellow, const Color(0xFFffc300));
      });

      test('kDavysGrey should have the correct value', () {
        expect(kDavysGrey, const Color(0xFF4B5358));
      });

      test('kGrey should have the correct value', () {
        expect(kGrey, const Color(0xFF303030));
      });
    });

    test('kDrawerTheme should have the correct background color', () {
      expect(kDrawerTheme.backgroundColor, Colors.grey.shade700);
    });

    group('Color Scheme', () {
      test('kColorScheme should have the correct primary color', () {
        expect(kColorScheme.primary, kMikadoYellow);
      });

      test('kColorScheme should have the correct secondary color', () {
        expect(kColorScheme.secondary, kPrussianBlue);
      });

      test('kColorScheme should have the correct secondaryContainer color', () {
        expect(kColorScheme.secondaryContainer, kPrussianBlue);
      });

      test('kColorScheme should have the correct surface color', () {
        expect(kColorScheme.surface, kRichBlack);
      });

      test('kColorScheme should have the correct error color', () {
        expect(kColorScheme.error, Colors.red);
      });

      test('kColorScheme should have the correct onPrimary color', () {
        expect(kColorScheme.onPrimary, kRichBlack);
      });

      test('kColorScheme should have the correct onSecondary color', () {
        expect(kColorScheme.onSecondary, Colors.white);
      });

      test('kColorScheme should have the correct onSurface color', () {
        expect(kColorScheme.onSurface, Colors.white);
      });

      test('kColorScheme should have the correct onError color', () {
        expect(kColorScheme.onError, Colors.white);
      });

      test('kColorScheme should have the correct brightness', () {
        expect(kColorScheme.brightness, Brightness.dark);
      });
    });
  });
}
