// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Task App`
  String get appTitle {
    return Intl.message('Task App', name: 'appTitle', desc: '', args: []);
  }

  /// `Log In`
  String get logIn {
    return Intl.message('Log In', name: 'logIn', desc: '', args: []);
  }

  /// `Sign In`
  String get signIn {
    return Intl.message('Sign In', name: 'signIn', desc: '', args: []);
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Log Out`
  String get logOut {
    return Intl.message('Log Out', name: 'logOut', desc: '', args: []);
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Account created! Login NOW!`
  String get accountCreated {
    return Intl.message(
      'Account created! Login NOW!',
      name: 'accountCreated',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Email field cannot be empty`
  String get nameFieldEmpty {
    return Intl.message(
      'Email field cannot be empty',
      name: 'nameFieldEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Email field cannot be empty`
  String get emailFieldEmpty {
    return Intl.message(
      'Email field cannot be empty',
      name: 'emailFieldEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password field cannot be empty`
  String get passwordFieldEmpty {
    return Intl.message(
      'Password field cannot be empty',
      name: 'passwordFieldEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Email field is invalid`
  String get invalidEmail {
    return Intl.message(
      'Email field is invalid',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `My Tasks`
  String get tasks {
    return Intl.message('My Tasks', name: 'tasks', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Language Settings`
  String get languageSettings {
    return Intl.message(
      'Language Settings',
      name: 'languageSettings',
      desc: '',
      args: [],
    );
  }

  /// `ThemeSettings`
  String get themeSettings {
    return Intl.message(
      'ThemeSettings',
      name: 'themeSettings',
      desc: '',
      args: [],
    );
  }

  /// `Choose Theme`
  String get chooseTheme {
    return Intl.message(
      'Choose Theme',
      name: 'chooseTheme',
      desc: '',
      args: [],
    );
  }

  /// `Choose Language`
  String get chooseLanguage {
    return Intl.message(
      'Choose Language',
      name: 'chooseLanguage',
      desc: '',
      args: [],
    );
  }

  /// `System Default`
  String get systemDefault {
    return Intl.message(
      'System Default',
      name: 'systemDefault',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message('Dark Mode', name: 'darkMode', desc: '', args: []);
  }

  /// `Light Mode`
  String get lightMode {
    return Intl.message('Light Mode', name: 'lightMode', desc: '', args: []);
  }

  /// `Failed to sync tasks`
  String get syncTaskError {
    return Intl.message(
      'Failed to sync tasks',
      name: 'syncTaskError',
      desc: '',
      args: [],
    );
  }

  /// `Add New Task`
  String get addTask {
    return Intl.message('Add New Task', name: 'addTask', desc: '', args: []);
  }

  /// `Edit Task`
  String get editTask {
    return Intl.message('Edit Task', name: 'editTask', desc: '', args: []);
  }

  /// `Delete Task`
  String get deleteTask {
    return Intl.message('Delete Task', name: 'deleteTask', desc: '', args: []);
  }

  /// `Task Title`
  String get taskTitle {
    return Intl.message('Task Title', name: 'taskTitle', desc: '', args: []);
  }

  /// `Task Description`
  String get taskDescription {
    return Intl.message(
      'Task Description',
      name: 'taskDescription',
      desc: '',
      args: [],
    );
  }

  /// `Task added successfully!`
  String get addTaskSuccess {
    return Intl.message(
      'Task added successfully!',
      name: 'addTaskSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message('Title', name: 'title', desc: '', args: []);
  }

  /// `Title cannot be empty`
  String get titleEmpty {
    return Intl.message(
      'Title cannot be empty',
      name: 'titleEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Description cannot be empty`
  String get descriptionEmpty {
    return Intl.message(
      'Description cannot be empty',
      name: 'descriptionEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Select a color for your task`
  String get selectColorforTask {
    return Intl.message(
      'Select a color for your task',
      name: 'selectColorforTask',
      desc: '',
      args: [],
    );
  }

  /// `Select Color`
  String get selectColor {
    return Intl.message(
      'Select Color',
      name: 'selectColor',
      desc: '',
      args: [],
    );
  }

  /// `Select a different shade`
  String get selectShade {
    return Intl.message(
      'Select a different shade',
      name: 'selectShade',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Welcome to Task Manager`
  String get welcome {
    return Intl.message(
      'Welcome to Task Manager',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message('Get Started', name: 'getStarted', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Create & Organize Tasks`
  String get manageTaskTitle {
    return Intl.message(
      'Create & Organize Tasks',
      name: 'manageTaskTitle',
      desc: '',
      args: [],
    );
  }

  /// `Track Your Progress`
  String get trackProggressTitle {
    return Intl.message(
      'Track Your Progress',
      name: 'trackProggressTitle',
      desc: '',
      args: [],
    );
  }

  /// `Stay Organized`
  String get stayOrganizedTitle {
    return Intl.message(
      'Stay Organized',
      name: 'stayOrganizedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Easily create new tasks, set due dates, and organize them with custom colors`
  String get manageTaskDesc {
    return Intl.message(
      'Easily create new tasks, set due dates, and organize them with custom colors',
      name: 'manageTaskDesc',
      desc: '',
      args: [],
    );
  }

  /// `Filter tasks by date and keep track of your daily achievements`
  String get trackProggressDesc {
    return Intl.message(
      'Filter tasks by date and keep track of your daily achievements',
      name: 'trackProggressDesc',
      desc: '',
      args: [],
    );
  }

  /// `Stay organized and boost your productivity with our intuitive task management app`
  String get stayOrganizedDesc {
    return Intl.message(
      'Stay organized and boost your productivity with our intuitive task management app',
      name: 'stayOrganizedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Sync Across Devices`
  String get syncTaskTitle {
    return Intl.message(
      'Sync Across Devices',
      name: 'syncTaskTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your tasks are automatically synced when you're online, access them anywhere`
  String get syncTaskDesc {
    return Intl.message(
      'Your tasks are automatically synced when you\'re online, access them anywhere',
      name: 'syncTaskDesc',
      desc: '',
      args: [],
    );
  }

  /// `Tap here to select due date`
  String get selectDueDateShowcase {
    return Intl.message(
      'Tap here to select due date',
      name: 'selectDueDateShowcase',
      desc: '',
      args: [],
    );
  }

  /// `Enter your task title here`
  String get enterTaskTitleShowcase {
    return Intl.message(
      'Enter your task title here',
      name: 'enterTaskTitleShowcase',
      desc: '',
      args: [],
    );
  }

  /// `Enter your task description here`
  String get enterTaskDescriptionShowcase {
    return Intl.message(
      'Enter your task description here',
      name: 'enterTaskDescriptionShowcase',
      desc: '',
      args: [],
    );
  }

  /// `Tap here to add a new task`
  String get addTaskShowcase {
    return Intl.message(
      'Tap here to add a new task',
      name: 'addTaskShowcase',
      desc: '',
      args: [],
    );
  }

  /// `Select date to filter tasks by date`
  String get selectDateShowcase {
    return Intl.message(
      'Select date to filter tasks by date',
      name: 'selectDateShowcase',
      desc: '',
      args: [],
    );
  }

  /// `Slide left to delete task`
  String get deleteTaskShowcase {
    return Intl.message(
      'Slide left to delete task',
      name: 'deleteTaskShowcase',
      desc: '',
      args: [],
    );
  }

  /// `You can see your tasks here`
  String get listTaskShowcase {
    return Intl.message(
      'You can see your tasks here',
      name: 'listTaskShowcase',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'tr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
