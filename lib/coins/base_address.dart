
import 'package:safepal_example/coins/hd_node.dart';

class BaseAddress {

  final HDNode node;

  BaseAddress({required this.node});

  Future<String> getAddress() async {
    throw("Subclass must implement getAddress");
  }
  
}