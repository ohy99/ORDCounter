class MyStrings {
  static const String sp_firsttime = "first_time?";
  static const String sp_birthdate = "birthdate";
  static const String sp_enlistmentdate = "enlistmentdate";
  static const String sp_orddate = "orddate";
  static const String sp_date_format = "dd MM yy";
  static const String sp_enlistmenttype = 'enlistmenttype';
  static const String sp_name = 'user_name';
  static const String sp_popdate = "popdate";
  static const String sp_serviceterm = "serviceterm";
  static const String sp_eventscount = 'events_count';
  static const String sp_eventskey = 'events_key';

  //save format
  //0: type
  //1: name
  // ...+
  //2: min
  //3: max
  //4: date ...
  static const String eventtype_range = 'event_range';
  //2: count?
  //3: date ...
  static const String eventtype_multipledates = 'event_manydates';
  //2: date
  static const String eventtype_date = 'event_date';
  //2: count
  static const String eventtype_counter = 'event_counter';

  //new save format
  //0: name
  //1: repeat count - min '0'
  //2: lastdate - default to ''
  //3: min - default to ''
  //4: max - default to ''
  //5: date count - min '1'
  //6: date...
  
  
  static const String addevent_displaydate_format = "EEE, dd MMM yyyy";
}

