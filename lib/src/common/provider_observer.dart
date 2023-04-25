import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 0,
    colors: true,
    printEmojis: false,
    printTime: false,
    noBoxingByDefault: true,
  ),
);

class LoggerObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    _logger.w('''
{

PROVIDER($provider) [PREVIOUS ${previousValue == newValue ? '==' : '!='} CURRENT]:
''');
    _logger.v(''' 
${provider.name ?? provider.runtimeType}
''');
    _logger.w('''
PREVIOUS($provider):
''');
    _logger.v(''' 
$previousValue,
''');

    _logger.w('''
CURRENT($provider):
''');
    _logger.v(''' 
$newValue
''');
    _logger.w('''
}''');
  }
}
