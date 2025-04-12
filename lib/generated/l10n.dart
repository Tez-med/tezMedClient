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
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Your phone number`
  String get your_phone_number {
    return Intl.message(
      'Your phone number',
      name: 'your_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `We'll send a verification code to your number`
  String get send_code_phone_number {
    return Intl.message(
      'We\'ll send a verification code to your number',
      name: 'send_code_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phone_number {
    return Intl.message(
      'Phone number',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get input_phone_number {
    return Intl.message(
      'Enter your phone number',
      name: 'input_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Verification code`
  String get verify_code {
    return Intl.message(
      'Verification code',
      name: 'verify_code',
      desc: '',
      args: [],
    );
  }

  /// `Enter the 4-digit code from SMS`
  String get enter_sms {
    return Intl.message(
      'Enter the 4-digit code from SMS',
      name: 'enter_sms',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get Continue {
    return Intl.message(
      'Continue',
      name: 'Continue',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get send_again {
    return Intl.message(
      'Resend',
      name: 'send_again',
      desc: '',
      args: [],
    );
  }

  /// `Add data`
  String get add_data {
    return Intl.message(
      'Add data',
      name: 'add_data',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fio {
    return Intl.message(
      'Full Name',
      name: 'fio',
      desc: '',
      args: [],
    );
  }

  /// `Date of birth`
  String get birthday {
    return Intl.message(
      'Date of birth',
      name: 'birthday',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Enter your full name`
  String get enter_fullname {
    return Intl.message(
      'Enter your full name',
      name: 'enter_fullname',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get choose {
    return Intl.message(
      'Choose',
      name: 'choose',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finish {
    return Intl.message(
      'Finish',
      name: 'finish',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notification {
    return Intl.message(
      'Notifications',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Order history`
  String get order_history {
    return Intl.message(
      'Order history',
      name: 'order_history',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Data update`
  String get data_update {
    return Intl.message(
      'Data update',
      name: 'data_update',
      desc: '',
      args: [],
    );
  }

  /// `Select language`
  String get language {
    return Intl.message(
      'Select language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Uzbek`
  String get uzbek {
    return Intl.message(
      'Uzbek',
      name: 'uzbek',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Russian`
  String get russian {
    return Intl.message(
      'Russian',
      name: 'russian',
      desc: '',
      args: [],
    );
  }

  /// `By registering, you agree to our `
  String get consent1 {
    return Intl.message(
      'By registering, you agree to our ',
      name: 'consent1',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Use `
  String get consent2 {
    return Intl.message(
      'Terms of Use ',
      name: 'consent2',
      desc: '',
      args: [],
    );
  }

  /// `and `
  String get consent3 {
    return Intl.message(
      'and ',
      name: 'consent3',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get consent4 {
    return Intl.message(
      'Privacy Policy',
      name: 'consent4',
      desc: '',
      args: [],
    );
  }

  /// `consent`
  String get consent5 {
    return Intl.message(
      'consent',
      name: 'consent5',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid number`
  String get check_phone {
    return Intl.message(
      'Enter a valid number',
      name: 'check_phone',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully registered`
  String get successfully_register {
    return Intl.message(
      'You have successfully registered',
      name: 'successfully_register',
      desc: '',
      args: [],
    );
  }

  /// `Please select a birth date`
  String get please_date {
    return Intl.message(
      'Please select a birth date',
      name: 'please_date',
      desc: '',
      args: [],
    );
  }

  /// `Please select your gender`
  String get please_gender {
    return Intl.message(
      'Please select your gender',
      name: 'please_gender',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your full name`
  String get please_fullname {
    return Intl.message(
      'Please enter your full name',
      name: 'please_fullname',
      desc: '',
      args: [],
    );
  }

  /// `Information updated`
  String get information_update {
    return Intl.message(
      'Information updated',
      name: 'information_update',
      desc: '',
      args: [],
    );
  }

  /// `Confirm exit`
  String get confirm_exit {
    return Intl.message(
      'Confirm exit',
      name: 'confirm_exit',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to exit?`
  String get really_quit {
    return Intl.message(
      'Do you really want to exit?',
      name: 'really_quit',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Sum`
  String get sum {
    return Intl.message(
      'Sum',
      name: 'sum',
      desc: '',
      args: [],
    );
  }

  /// `There is a problem with the security certificate. It may be related to the server or your internet connection. Please check your internet connection or try a different network.`
  String get badCertificate {
    return Intl.message(
      'There is a problem with the security certificate. It may be related to the server or your internet connection. Please check your internet connection or try a different network.',
      name: 'badCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Connection to the server lost, try again`
  String get connectionError {
    return Intl.message(
      'Connection to the server lost, try again',
      name: 'connectionError',
      desc: '',
      args: [],
    );
  }

  /// `Check the internet and try again.`
  String get sendTimeout {
    return Intl.message(
      'Check the internet and try again.',
      name: 'sendTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Timeout receiving data. This may be due to slow internet speed or server delay. Please try again.`
  String get receiveTimeout {
    return Intl.message(
      'Timeout receiving data. This may be due to slow internet speed or server delay. Please try again.',
      name: 'receiveTimeout',
      desc: '',
      args: [],
    );
  }

  /// `There was an issue with the internet connection. Please check your network and try again.`
  String get connectionTimeout {
    return Intl.message(
      'There was an issue with the internet connection. Please check your network and try again.',
      name: 'connectionTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Internet connection is poor`
  String get no_internet {
    return Intl.message(
      'Internet connection is poor',
      name: 'no_internet',
      desc: '',
      args: [],
    );
  }

  /// `Please check your internet connection`
  String get check_internet {
    return Intl.message(
      'Please check your internet connection',
      name: 'check_internet',
      desc: '',
      args: [],
    );
  }

  /// `Code mismatch, press resend`
  String get error_sms_code {
    return Intl.message(
      'Code mismatch, press resend',
      name: 'error_sms_code',
      desc: '',
      args: [],
    );
  }

  /// `Entered code is incorrect`
  String get code_error {
    return Intl.message(
      'Entered code is incorrect',
      name: 'code_error',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred`
  String get unexpected_error {
    return Intl.message(
      'An unexpected error occurred',
      name: 'unexpected_error',
      desc: '',
      args: [],
    );
  }

  /// `No notifications available`
  String get no_notification {
    return Intl.message(
      'No notifications available',
      name: 'no_notification',
      desc: '',
      args: [],
    );
  }

  /// `Stay tuned for news and updates!`
  String get no_notification_subtitle {
    return Intl.message(
      'Stay tuned for news and updates!',
      name: 'no_notification_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get current_order {
    return Intl.message(
      'Orders',
      name: 'current_order',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get order {
    return Intl.message(
      'Order',
      name: 'order',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Refusal`
  String get refusal {
    return Intl.message(
      'Refusal',
      name: 'refusal',
      desc: '',
      args: [],
    );
  }

  /// `Notification settings`
  String get notification_settings {
    return Intl.message(
      'Notification settings',
      name: 'notification_settings',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Open settings`
  String get open_settings {
    return Intl.message(
      'Open settings',
      name: 'open_settings',
      desc: '',
      args: [],
    );
  }

  /// `Term`
  String get term {
    return Intl.message(
      'Term',
      name: 'term',
      desc: '',
      args: [],
    );
  }

  /// `Select map`
  String get select_map {
    return Intl.message(
      'Select map',
      name: 'select_map',
      desc: '',
      args: [],
    );
  }

  /// `Map application not found.`
  String get map_not_found {
    return Intl.message(
      'Map application not found.',
      name: 'map_not_found',
      desc: '',
      args: [],
    );
  }

  /// `House`
  String get house {
    return Intl.message(
      'House',
      name: 'house',
      desc: '',
      args: [],
    );
  }

  /// `Floor`
  String get floor {
    return Intl.message(
      'Floor',
      name: 'floor',
      desc: '',
      args: [],
    );
  }

  /// `Apartment`
  String get apartment {
    return Intl.message(
      'Apartment',
      name: 'apartment',
      desc: '',
      args: [],
    );
  }

  /// `Entrance`
  String get entrance {
    return Intl.message(
      'Entrance',
      name: 'entrance',
      desc: '',
      args: [],
    );
  }

  /// `Please enter location`
  String get please_location {
    return Intl.message(
      'Please enter location',
      name: 'please_location',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get sign_up {
    return Intl.message(
      'Sign up',
      name: 'sign_up',
      desc: '',
      args: [],
    );
  }

  /// `Location successfully obtained`
  String get location_successfully {
    return Intl.message(
      'Location successfully obtained',
      name: 'location_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Error obtaining location`
  String get location_error {
    return Intl.message(
      'Error obtaining location',
      name: 'location_error',
      desc: '',
      args: [],
    );
  }

  /// `Location selected`
  String get location_selected {
    return Intl.message(
      'Location selected',
      name: 'location_selected',
      desc: '',
      args: [],
    );
  }

  /// `Select location`
  String get select_location {
    return Intl.message(
      'Select location',
      name: 'select_location',
      desc: '',
      args: [],
    );
  }

  /// `Coordinates`
  String get coordinates {
    return Intl.message(
      'Coordinates',
      name: 'coordinates',
      desc: '',
      args: [],
    );
  }

  /// `No current orders`
  String get no_current_order {
    return Intl.message(
      'No current orders',
      name: 'no_current_order',
      desc: '',
      args: [],
    );
  }

  /// `No completed orders`
  String get no_complated_order {
    return Intl.message(
      'No completed orders',
      name: 'no_complated_order',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get day {
    return Intl.message(
      'Day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Select service`
  String get select_service {
    return Intl.message(
      'Select service',
      name: 'select_service',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Order details`
  String get order_details {
    return Intl.message(
      'Order details',
      name: 'order_details',
      desc: '',
      args: [],
    );
  }

  /// `Order information`
  String get order_information {
    return Intl.message(
      'Order information',
      name: 'order_information',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Total price`
  String get total_price {
    return Intl.message(
      'Total price',
      name: 'total_price',
      desc: '',
      args: [],
    );
  }

  /// `Start time`
  String get start_time {
    return Intl.message(
      'Start time',
      name: 'start_time',
      desc: '',
      args: [],
    );
  }

  /// `Order photos`
  String get order_photo {
    return Intl.message(
      'Order photos',
      name: 'order_photo',
      desc: '',
      args: [],
    );
  }

  /// `Call help center`
  String get call_help_center {
    return Intl.message(
      'Call help center',
      name: 'call_help_center',
      desc: '',
      args: [],
    );
  }

  /// `Error uploading photo`
  String get photo_error {
    return Intl.message(
      'Error uploading photo',
      name: 'photo_error',
      desc: '',
      args: [],
    );
  }

  /// `Image not loaded`
  String get image_not_loaded {
    return Intl.message(
      'Image not loaded',
      name: 'image_not_loaded',
      desc: '',
      args: [],
    );
  }

  /// `Personal information`
  String get personal_information {
    return Intl.message(
      'Personal information',
      name: 'personal_information',
      desc: '',
      args: [],
    );
  }

  /// `Choose profile picture`
  String get choose_profile_picture {
    return Intl.message(
      'Choose profile picture',
      name: 'choose_profile_picture',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Taking pictures`
  String get taking_pictures {
    return Intl.message(
      'Taking pictures',
      name: 'taking_pictures',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Select photo`
  String get select_photo {
    return Intl.message(
      'Select photo',
      name: 'select_photo',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Please wait`
  String get please_wait {
    return Intl.message(
      'Please wait',
      name: 'please_wait',
      desc: '',
      args: [],
    );
  }

  /// `Successful`
  String get successful {
    return Intl.message(
      'Successful',
      name: 'successful',
      desc: '',
      args: [],
    );
  }

  /// `Order created successfully!`
  String get order_successfully_created {
    return Intl.message(
      'Order created successfully!',
      name: 'order_successfully_created',
      desc: '',
      args: [],
    );
  }

  /// `Please select an address`
  String get please_select_address {
    return Intl.message(
      'Please select an address',
      name: 'please_select_address',
      desc: '',
      args: [],
    );
  }

  /// `Please select a time`
  String get please_select_time {
    return Intl.message(
      'Please select a time',
      name: 'please_select_time',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Your check`
  String get your_check {
    return Intl.message(
      'Your check',
      name: 'your_check',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Select address`
  String get select_address {
    return Intl.message(
      'Select address',
      name: 'select_address',
      desc: '',
      args: [],
    );
  }

  /// `Landmark or additional info`
  String get destination_additional_information {
    return Intl.message(
      'Landmark or additional info',
      name: 'destination_additional_information',
      desc: '',
      args: [],
    );
  }

  /// `Example: Opposite the street`
  String get example {
    return Intl.message(
      'Example: Opposite the street',
      name: 'example',
      desc: '',
      args: [],
    );
  }

  /// `Payment type`
  String get payment_type {
    return Intl.message(
      'Payment type',
      name: 'payment_type',
      desc: '',
      args: [],
    );
  }

  /// `Currently, you can only pay in cash. Other payment types will be added soon`
  String get payment_other {
    return Intl.message(
      'Currently, you can only pay in cash. Other payment types will be added soon',
      name: 'payment_other',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get cash {
    return Intl.message(
      'Cash',
      name: 'cash',
      desc: '',
      args: [],
    );
  }

  /// `Selected services`
  String get selected_services {
    return Intl.message(
      'Selected services',
      name: 'selected_services',
      desc: '',
      args: [],
    );
  }

  /// `Select time`
  String get select_time {
    return Intl.message(
      'Select time',
      name: 'select_time',
      desc: '',
      args: [],
    );
  }

  /// `Ready`
  String get ready {
    return Intl.message(
      'Ready',
      name: 'ready',
      desc: '',
      args: [],
    );
  }

  /// `Current time`
  String get current_time {
    return Intl.message(
      'Current time',
      name: 'current_time',
      desc: '',
      args: [],
    );
  }

  /// `Set by schedule`
  String get setting_according_table {
    return Intl.message(
      'Set by schedule',
      name: 'setting_according_table',
      desc: '',
      args: [],
    );
  }

  /// `Search address`
  String get search_address {
    return Intl.message(
      'Search address',
      name: 'search_address',
      desc: '',
      args: [],
    );
  }

  /// `Selected address`
  String get selected_address {
    return Intl.message(
      'Selected address',
      name: 'selected_address',
      desc: '',
      args: [],
    );
  }

  /// `No address selected`
  String get no_selected_address {
    return Intl.message(
      'No address selected',
      name: 'no_selected_address',
      desc: '',
      args: [],
    );
  }

  /// `Patient information`
  String get your_details {
    return Intl.message(
      'Patient information',
      name: 'your_details',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get full_name {
    return Intl.message(
      'Full name',
      name: 'full_name',
      desc: '',
      args: [],
    );
  }

  /// `Doctor prescription`
  String get doctor_prescription {
    return Intl.message(
      'Doctor prescription',
      name: 'doctor_prescription',
      desc: '',
      args: [],
    );
  }

  /// `Open camera`
  String get open_camera {
    return Intl.message(
      'Open camera',
      name: 'open_camera',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get neww {
    return Intl.message(
      'New',
      name: 'neww',
      desc: '',
      args: [],
    );
  }

  /// `Came`
  String get came {
    return Intl.message(
      'Came',
      name: 'came',
      desc: '',
      args: [],
    );
  }

  /// `Accepted`
  String get attached {
    return Intl.message(
      'Accepted',
      name: 'attached',
      desc: '',
      args: [],
    );
  }

  /// `On the way`
  String get ontheway {
    return Intl.message(
      'On the way',
      name: 'ontheway',
      desc: '',
      args: [],
    );
  }

  /// `Finished`
  String get finished {
    return Intl.message(
      'Finished',
      name: 'finished',
      desc: '',
      args: [],
    );
  }

  /// `In process`
  String get in_process {
    return Intl.message(
      'In process',
      name: 'in_process',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message(
      'Pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Nurse information`
  String get nurse_info {
    return Intl.message(
      'Nurse information',
      name: 'nurse_info',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get general {
    return Intl.message(
      'General',
      name: 'general',
      desc: '',
      args: [],
    );
  }

  /// `Senior`
  String get supreme {
    return Intl.message(
      'Senior',
      name: 'supreme',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Additional number`
  String get additional_number {
    return Intl.message(
      'Additional number',
      name: 'additional_number',
      desc: '',
      args: [],
    );
  }

  /// `Required field`
  String get required_field {
    return Intl.message(
      'Required field',
      name: 'required_field',
      desc: '',
      args: [],
    );
  }

  /// `Form submitted`
  String get form_submitted {
    return Intl.message(
      'Form submitted',
      name: 'form_submitted',
      desc: '',
      args: [],
    );
  }

  /// `Access code`
  String get access_code {
    return Intl.message(
      'Access code',
      name: 'access_code',
      desc: '',
      args: [],
    );
  }

  /// `Optional`
  String get optional {
    return Intl.message(
      'Optional',
      name: 'optional',
      desc: '',
      args: [],
    );
  }

  /// `Services`
  String get services {
    return Intl.message(
      'Services',
      name: 'services',
      desc: '',
      args: [],
    );
  }

  /// `Hour`
  String get hour {
    return Intl.message(
      'Hour',
      name: 'hour',
      desc: '',
      args: [],
    );
  }

  /// `Expert Guidance`
  String get expert_guidance {
    return Intl.message(
      'Expert Guidance',
      name: 'expert_guidance',
      desc: '',
      args: [],
    );
  }

  /// `The TezMed platform provides a solution to painful issues like visiting medical institutions and waiting in long queues for hours.`
  String get expert_guidance_desc {
    return Intl.message(
      'The TezMed platform provides a solution to painful issues like visiting medical institutions and waiting in long queues for hours.',
      name: 'expert_guidance_desc',
      desc: '',
      args: [],
    );
  }

  /// `24/7 Support`
  String get support {
    return Intl.message(
      '24/7 Support',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// `You can contact our qualified doctors at any time of the day and get advice about your health.`
  String get support_desc {
    return Intl.message(
      'You can contact our qualified doctors at any time of the day and get advice about your health.',
      name: 'support_desc',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Application version`
  String get app_version {
    return Intl.message(
      'Application version',
      name: 'app_version',
      desc: '',
      args: [],
    );
  }

  /// `Additional phone number`
  String get additional_phone_number {
    return Intl.message(
      'Additional phone number',
      name: 'additional_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Please select a region`
  String get please_region {
    return Intl.message(
      'Please select a region',
      name: 'please_region',
      desc: '',
      args: [],
    );
  }

  /// `Name and surname must consist of only letters`
  String get name_only_letter {
    return Intl.message(
      'Name and surname must consist of only letters',
      name: 'name_only_letter',
      desc: '',
      args: [],
    );
  }

  /// `Select your region`
  String get select_region {
    return Intl.message(
      'Select your region',
      name: 'select_region',
      desc: '',
      args: [],
    );
  }

  /// `Search by region name`
  String get search_region {
    return Intl.message(
      'Search by region name',
      name: 'search_region',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get region_error {
    return Intl.message(
      'An error occurred',
      name: 'region_error',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while loading the data`
  String get region_error_desc {
    return Intl.message(
      'An error occurred while loading the data',
      name: 'region_error_desc',
      desc: '',
      args: [],
    );
  }

  /// `Region not found`
  String get region_empty {
    return Intl.message(
      'Region not found',
      name: 'region_empty',
      desc: '',
      args: [],
    );
  }

  /// `Try searching with a different keyword`
  String get region_empty_desc {
    return Intl.message(
      'Try searching with a different keyword',
      name: 'region_empty_desc',
      desc: '',
      args: [],
    );
  }

  /// `My addresses`
  String get my_address {
    return Intl.message(
      'My addresses',
      name: 'my_address',
      desc: '',
      args: [],
    );
  }

  /// `Addresses not found`
  String get address_not_found {
    return Intl.message(
      'Addresses not found',
      name: 'address_not_found',
      desc: '',
      args: [],
    );
  }

  /// `You currently have no addresses. You can add a new address.`
  String get address_not_found_desc {
    return Intl.message(
      'You currently have no addresses. You can add a new address.',
      name: 'address_not_found_desc',
      desc: '',
      args: [],
    );
  }

  /// `Choose another address`
  String get another_address {
    return Intl.message(
      'Choose another address',
      name: 'another_address',
      desc: '',
      args: [],
    );
  }

  /// `Enter text`
  String get enter_text {
    return Intl.message(
      'Enter text',
      name: 'enter_text',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for your feedback! Your opinion is very important to us.`
  String get raiting_succes {
    return Intl.message(
      'Thank you for your feedback! Your opinion is very important to us.',
      name: 'raiting_succes',
      desc: '',
      args: [],
    );
  }

  /// `Leave a comment`
  String get leave_comment {
    return Intl.message(
      'Leave a comment',
      name: 'leave_comment',
      desc: '',
      args: [],
    );
  }

  /// `Discount price`
  String get discount_price {
    return Intl.message(
      'Discount price',
      name: 'discount_price',
      desc: '',
      args: [],
    );
  }

  /// `Service price`
  String get price_going {
    return Intl.message(
      'Service price',
      name: 'price_going',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Invalid promo code.`
  String get invalid_promo_code {
    return Intl.message(
      'Invalid promo code.',
      name: 'invalid_promo_code',
      desc: '',
      args: [],
    );
  }

  /// `Promo-code`
  String get promocode {
    return Intl.message(
      'Promo-code',
      name: 'promocode',
      desc: '',
      args: [],
    );
  }

  /// `Rate Us`
  String get rate_us {
    return Intl.message(
      'Rate Us',
      name: 'rate_us',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get helpSupport {
    return Intl.message(
      'Contact',
      name: 'helpSupport',
      desc: '',
      args: [],
    );
  }

  /// `Contact us through any of these platforms for assistance`
  String get contactPlatforms {
    return Intl.message(
      'Contact us through any of these platforms for assistance',
      name: 'contactPlatforms',
      desc: '',
      args: [],
    );
  }

  /// `YouTube`
  String get youtube {
    return Intl.message(
      'YouTube',
      name: 'youtube',
      desc: '',
      args: [],
    );
  }

  /// `Video guides & tutorials`
  String get videoGuides {
    return Intl.message(
      'Video guides & tutorials',
      name: 'videoGuides',
      desc: '',
      args: [],
    );
  }

  /// `Instagram`
  String get instagram {
    return Intl.message(
      'Instagram',
      name: 'instagram',
      desc: '',
      args: [],
    );
  }

  /// `Follow us for latest updates`
  String get latestUpdates {
    return Intl.message(
      'Follow us for latest updates',
      name: 'latestUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Telegram`
  String get telegram {
    return Intl.message(
      'Telegram',
      name: 'telegram',
      desc: '',
      args: [],
    );
  }

  /// `24/7 Chat Support`
  String get chatSupport {
    return Intl.message(
      '24/7 Chat Support',
      name: 'chatSupport',
      desc: '',
      args: [],
    );
  }

  /// `Call Center`
  String get callCenter {
    return Intl.message(
      'Call Center',
      name: 'callCenter',
      desc: '',
      args: [],
    );
  }

  /// `Share App`
  String get share_app {
    return Intl.message(
      'Share App',
      name: 'share_app',
      desc: '',
      args: [],
    );
  }

  /// `The promo code usage time has expired!`
  String get promocode_time {
    return Intl.message(
      'The promo code usage time has expired!',
      name: 'promocode_time',
      desc: '',
      args: [],
    );
  }

  /// `You have already used the promo code.`
  String get promocode_count {
    return Intl.message(
      'You have already used the promo code.',
      name: 'promocode_count',
      desc: '',
      args: [],
    );
  }

  /// `Our services`
  String get our_service {
    return Intl.message(
      'Our services',
      name: 'our_service',
      desc: '',
      args: [],
    );
  }

  /// `Will be added soon.`
  String get added_soon {
    return Intl.message(
      'Will be added soon.',
      name: 'added_soon',
      desc: '',
      args: [],
    );
  }

  /// `Select gender`
  String get select_gender {
    return Intl.message(
      'Select gender',
      name: 'select_gender',
      desc: '',
      args: [],
    );
  }

  /// `For myself`
  String get my_self {
    return Intl.message(
      'For myself',
      name: 'my_self',
      desc: '',
      args: [],
    );
  }

  /// `For another`
  String get for_another {
    return Intl.message(
      'For another',
      name: 'for_another',
      desc: '',
      args: [],
    );
  }

  /// `Book a consultation`
  String get consultation {
    return Intl.message(
      'Book a consultation',
      name: 'consultation',
      desc: '',
      args: [],
    );
  }

  /// `Experience`
  String get experience {
    return Intl.message(
      'Experience',
      name: 'experience',
      desc: '',
      args: [],
    );
  }

  /// `year`
  String get year {
    return Intl.message(
      'year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `Work experience`
  String get work_experience {
    return Intl.message(
      'Work experience',
      name: 'work_experience',
      desc: '',
      args: [],
    );
  }

  /// `Rating`
  String get rating {
    return Intl.message(
      'Rating',
      name: 'rating',
      desc: '',
      args: [],
    );
  }

  /// `Choose date and time`
  String get choose_date_time {
    return Intl.message(
      'Choose date and time',
      name: 'choose_date_time',
      desc: '',
      args: [],
    );
  }

  /// `Nurse`
  String get nurse {
    return Intl.message(
      'Nurse',
      name: 'nurse',
      desc: '',
      args: [],
    );
  }

  /// `Doctor`
  String get doctor {
    return Intl.message(
      'Doctor',
      name: 'doctor',
      desc: '',
      args: [],
    );
  }

  /// `No doctor types found`
  String get no_doctor_types_found {
    return Intl.message(
      'No doctor types found',
      name: 'no_doctor_types_found',
      desc: '',
      args: [],
    );
  }

  /// `Detecting location...`
  String get location_detecting {
    return Intl.message(
      'Detecting location...',
      name: 'location_detecting',
      desc: '',
      args: [],
    );
  }

  /// `Exit Dialog`
  String get exitDialog {
    return Intl.message(
      'Exit Dialog',
      name: 'exitDialog',
      desc: '',
      args: [],
    );
  }

  /// `End Video Call`
  String get exitTitle {
    return Intl.message(
      'End Video Call',
      name: 'exitTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to end the video call?`
  String get exitDescription {
    return Intl.message(
      'Are you sure you want to end the video call?',
      name: 'exitDescription',
      desc: '',
      args: [],
    );
  }

  /// `End`
  String get endText {
    return Intl.message(
      'End',
      name: 'endText',
      desc: '',
      args: [],
    );
  }

  /// `Info Dialog`
  String get infoDialog {
    return Intl.message(
      'Info Dialog',
      name: 'infoDialog',
      desc: '',
      args: [],
    );
  }

  /// `About Video Call`
  String get infoTitle {
    return Intl.message(
      'About Video Call',
      name: 'infoTitle',
      desc: '',
      args: [],
    );
  }

  /// `On this screen, you can communicate via video. During the video call, you can use the following features:`
  String get infoDescription {
    return Intl.message(
      'On this screen, you can communicate via video. During the video call, you can use the following features:',
      name: 'infoDescription',
      desc: '',
      args: [],
    );
  }

  /// `Enlarge or reduce the screen`
  String get fullscreenText {
    return Intl.message(
      'Enlarge or reduce the screen',
      name: 'fullscreenText',
      desc: '',
      args: [],
    );
  }

  /// `End video call`
  String get endCallText {
    return Intl.message(
      'End video call',
      name: 'endCallText',
      desc: '',
      args: [],
    );
  }

  /// `Got it`
  String get understoodText {
    return Intl.message(
      'Got it',
      name: 'understoodText',
      desc: '',
      args: [],
    );
  }

  /// `Video Chat`
  String get video_chat {
    return Intl.message(
      'Video Chat',
      name: 'video_chat',
      desc: '',
      args: [],
    );
  }

  /// `Zoom Out`
  String get zoom_out {
    return Intl.message(
      'Zoom Out',
      name: 'zoom_out',
      desc: '',
      args: [],
    );
  }

  /// `Zoom In`
  String get zoom_in {
    return Intl.message(
      'Zoom In',
      name: 'zoom_in',
      desc: '',
      args: [],
    );
  }

  /// `Loading video`
  String get loading_video {
    return Intl.message(
      'Loading video',
      name: 'loading_video',
      desc: '',
      args: [],
    );
  }

  /// `Permission Required`
  String get permission_required {
    return Intl.message(
      'Permission Required',
      name: 'permission_required',
      desc: '',
      args: [],
    );
  }

  /// `Camera and microphone permissions are required for a video call. Please go to app settings to grant permissions.`
  String get permission_description {
    return Intl.message(
      'Camera and microphone permissions are required for a video call. Please go to app settings to grant permissions.',
      name: 'permission_description',
      desc: '',
      args: [],
    );
  }

  /// `Order Information`
  String get order_info {
    return Intl.message(
      'Order Information',
      name: 'order_info',
      desc: '',
      args: [],
    );
  }

  /// `Order Date`
  String get order_date {
    return Intl.message(
      'Order Date',
      name: 'order_date',
      desc: '',
      args: [],
    );
  }

  /// `Start Time`
  String get startTimeLabel {
    return Intl.message(
      'Start Time',
      name: 'startTimeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get priceLabel {
    return Intl.message(
      'Price',
      name: 'priceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Patient Medical Card`
  String get patient_medical_card {
    return Intl.message(
      'Patient Medical Card',
      name: 'patient_medical_card',
      desc: '',
      args: [],
    );
  }

  /// `Attached Images`
  String get attached_images {
    return Intl.message(
      'Attached Images',
      name: 'attached_images',
      desc: '',
      args: [],
    );
  }

  /// `Disease Cards`
  String get diseaseCards {
    return Intl.message(
      'Disease Cards',
      name: 'diseaseCards',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for data...`
  String get waitingForData {
    return Intl.message(
      'Waiting for data...',
      name: 'waitingForData',
      desc: '',
      args: [],
    );
  }

  /// `No disease cards available`
  String get noDiseaseCardsAvailable {
    return Intl.message(
      'No disease cards available',
      name: 'noDiseaseCardsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Click the add button to create a new disease card`
  String get clickAddButtonToCreateDisease {
    return Intl.message(
      'Click the add button to create a new disease card',
      name: 'clickAddButtonToCreateDisease',
      desc: '',
      args: [],
    );
  }

  /// `Add Disease Card`
  String get addDiseaseCard {
    return Intl.message(
      'Add Disease Card',
      name: 'addDiseaseCard',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get errorOccurred {
    return Intl.message(
      'An error occurred',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get tryAgain {
    return Intl.message(
      'Try Again',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Add new disease`
  String get addNewDisease {
    return Intl.message(
      'Add new disease',
      name: 'addNewDisease',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Photos`
  String get photos {
    return Intl.message(
      'Photos',
      name: 'photos',
      desc: '',
      args: [],
    );
  }

  /// `Created at`
  String get createdAt {
    return Intl.message(
      'Created at',
      name: 'createdAt',
      desc: '',
      args: [],
    );
  }

  /// `Schedule ID`
  String get scheduleId {
    return Intl.message(
      'Schedule ID',
      name: 'scheduleId',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get statusNew {
    return Intl.message(
      'New',
      name: 'statusNew',
      desc: '',
      args: [],
    );
  }

  /// `In Progress`
  String get statusInProgress {
    return Intl.message(
      'In Progress',
      name: 'statusInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Resolved`
  String get statusResolved {
    return Intl.message(
      'Resolved',
      name: 'statusResolved',
      desc: '',
      args: [],
    );
  }

  /// `Closed`
  String get statusClosed {
    return Intl.message(
      'Closed',
      name: 'statusClosed',
      desc: '',
      args: [],
    );
  }

  /// `Services Not Available Yet`
  String get no_services_available {
    return Intl.message(
      'Services Not Available Yet',
      name: 'no_services_available',
      desc: '',
      args: [],
    );
  }

  /// `Our services are not yet available in this area. We are working hard to expand our coverage. Please check back later.`
  String get no_services_description {
    return Intl.message(
      'Our services are not yet available in this area. We are working hard to expand our coverage. Please check back later.',
      name: 'no_services_description',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `If you delete your account, all personal information and access to the system will be lost.`
  String get deleteAccountDescription {
    return Intl.message(
      'If you delete your account, all personal information and access to the system will be lost.',
      name: 'deleteAccountDescription',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccountTitle {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccountTitle',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete your account? This action cannot be undone and all your data will be lost.`
  String get deleteAccountConfirmation {
    return Intl.message(
      'Do you want to delete your account? This action cannot be undone and all your data will be lost.',
      name: 'deleteAccountConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `This action cannot be undone. Your account and all your data will be completely deleted. Do you want to continue?`
  String get deleteAccountFinalWarning {
    return Intl.message(
      'This action cannot be undone. Your account and all your data will be completely deleted. Do you want to continue?',
      name: 'deleteAccountFinalWarning',
      desc: '',
      args: [],
    );
  }

  /// `Deleting your account...`
  String get deletingAccount {
    return Intl.message(
      'Deleting your account...',
      name: 'deletingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Your account has been successfully deleted`
  String get accountDeletedSuccessfully {
    return Intl.message(
      'Your account has been successfully deleted',
      name: 'accountDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `View Disease Information`
  String get disease_info {
    return Intl.message(
      'View Disease Information',
      name: 'disease_info',
      desc: '',
      args: [],
    );
  }

  /// `The call has ended`
  String get video_call_ended {
    return Intl.message(
      'The call has ended',
      name: 'video_call_ended',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all the fields`
  String get fill_all_fields {
    return Intl.message(
      'Please fill in all the fields',
      name: 'fill_all_fields',
      desc: '',
      args: [],
    );
  }

  /// `Data saved successfully`
  String get data_saved_successfully {
    return Intl.message(
      'Data saved successfully',
      name: 'data_saved_successfully',
      desc: '',
      args: [],
    );
  }

  /// `You have exited the video call. Please enter the disease information.`
  String get video_call_exit_message {
    return Intl.message(
      'You have exited the video call. Please enter the disease information.',
      name: 'video_call_exit_message',
      desc: '',
      args: [],
    );
  }

  /// `Disease name`
  String get disease_name {
    return Intl.message(
      'Disease name',
      name: 'disease_name',
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
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'uz'),
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
