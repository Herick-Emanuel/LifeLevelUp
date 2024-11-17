import 'package:flutter/material.dart';
import '../models/customization_item.dart';
import '../services/api_service.dart';

class CustomizationScreen extends StatefulWidget {
  const CustomizationScreen({super.key});

  @override
  _CustomizationScreenState createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends State<CustomizationScreen> {
  List<CustomizationItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      List<CustomizationItem> items =
          await ApiService.getAvailableCustomizationItems();
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _purchaseItem(int itemId) async {
    bool success = await ApiService.purchaseCustomizationItem(itemId);
    if (success) {
      _fetchItems();
    }
  }

  Widget _buildItem(CustomizationItem item) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('Custo: ${item.pointsCost} pontos'),
      trailing: ElevatedButton(
        onPressed: () => _purchaseItem(item.id),
        child: Text('Comprar'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customização'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? Center(child: Text('Nenhum item disponível.'))
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return _buildItem(_items[index]);
                  },
                ),
    );
  }
}
