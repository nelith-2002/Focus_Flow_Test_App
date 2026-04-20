import 'package:flutter/material.dart';
import 'package:test_observer_sdk/test_observer_sdk.dart';

class SdkInitializer extends StatefulWidget {
  final Widget child;

  const SdkInitializer({
    super.key,
    required this.child,
  });

  @override
  State<SdkInitializer> createState() => _SdkInitializerState();
}

class _SdkInitializerState extends State<SdkInitializer> {
  AppStartupReport? _startupReport;

  AppStartupReport? get startupReport => _startupReport;

  @override
  void initState() {
    super.initState();

    TestObserverSdk.instance.initialize(
      onStartupMeasured: (report) {
        if (!mounted) return;

        setState(() {
          _startupReport = report;
        });

        debugPrint(
          'Startup time: ${report.startupDuration.inMilliseconds} ms',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StartupReportProvider(
      report: _startupReport,
      child: widget.child,
    );
  }
}

class StartupReportProvider extends InheritedWidget {
  final AppStartupReport? report;

  const StartupReportProvider({
    super.key,
    required this.report,
    required super.child,
  });

  static StartupReportProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StartupReportProvider>();
  }

  @override
  bool updateShouldNotify(covariant StartupReportProvider oldWidget) {
    return oldWidget.report != report;
  }
}