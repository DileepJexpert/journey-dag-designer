/// Abstract bindings repository (build doc §8, §9). Binds journeys by
/// (businessLine x product x partner) -> journey/version. NO tenant, NO cell.
library;

import '../models/binding.dart';

abstract interface class BindingRepository {
  Future<List<Binding>> listBindings({
    String? businessLine,
    String? product,
    String? partner,
  });

  Future<Binding> putBinding(Binding binding);
}
