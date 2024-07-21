// lib/core/di/locator.dart

import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Register your dependencies here
  locator.registerLazySingleton(() => GlobalKey<NavigatorState>());
  // Add other dependencies as needed
}
