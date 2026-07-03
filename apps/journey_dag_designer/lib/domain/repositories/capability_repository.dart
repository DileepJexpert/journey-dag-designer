/// Abstract capability registry repository (build doc §9). Feeds the editor
/// palette and [DagValidator]. The palette is populated ONLY from this list, so
/// an unregistered capability cannot be placed on the canvas.
library;

import '../models/capability.dart';
import '../models/scope_dimensions.dart';

abstract interface class CapabilityRepository {
  Future<List<Capability>> listCapabilities();

  // Scoping dimensions (config), build doc §0 / §9.
  Future<List<BusinessLine>> listBusinessLines();
  Future<List<Product>> listProducts();
  Future<List<Partner>> listPartners();
}
