/// Local data source (conditional)
library;

export 'local_data_source_isar.dart'
    if (dart.library.html) 'local_data_source_web.dart';
