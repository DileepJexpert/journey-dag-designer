/// In-memory [CapabilityRepository] seeded with the real backend capability
/// module names + scoping dimensions (build doc §9).
library;

import '../../domain/models/capability.dart';
import '../../domain/models/scope_dimensions.dart';
import '../../domain/repositories/capability_repository.dart';
import '../seed_data.dart';

class MockCapabilityRepository implements CapabilityRepository {
  const MockCapabilityRepository();

  @override
  Future<List<Capability>> listCapabilities() async => seedCapabilities;

  @override
  Future<List<BusinessLine>> listBusinessLines() async => seedBusinessLines;

  @override
  Future<List<Product>> listProducts() async => seedProducts;

  @override
  Future<List<Partner>> listPartners() async => seedPartners;
}
