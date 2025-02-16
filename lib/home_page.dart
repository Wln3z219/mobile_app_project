import 'package:flutter/material.dart';
import 'package:mobile_app_project/questionpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> inventory = ['Hint: Skip a Question', 'Extra Life', 'Time Freeze'];
  List<String> selectedItems = [];

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  // Load inventory from shared_preferences
  void _loadInventory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? loadedItems = prefs.getStringList('inventory');
    if (loadedItems != null) {
      setState(() {
        inventory = loadedItems;
      });
    }
  }

  // Save inventory to shared_preferences
  void _saveInventory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('inventory', inventory);
  }

  // Function to toggle item selection
  void toggleItem(String item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item); // Deselect item
      } else {
        selectedItems.add(item); // Select item
      }
    });
  }

  // Function to show inventory bag as a modal
  void _showInventoryBag() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Inventory Bag'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Tap on an item to view details and select it:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Display inventory items as icons
              Container(
                height: 200, // Fixed height for the grid
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 items per row
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: inventory.length,
                  itemBuilder: (context, index) {
                    final item = inventory[index];
                    return GestureDetector(
                      onTap: () => _showItemDetails(item),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag, // Default bag icon
                              size: 40,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the inventory bag
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Function to show item details when tapped
  void _showItemDetails(String item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Details about the item "$item"'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    toggleItem(item); // Use the item
                    Navigator.of(context).pop();
                  },
                  child: const Text('Use'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Do nothing, close the dialog
                  },
                  child: const Text('Not Use'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Quiz App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory),
            onPressed: _showInventoryBag, // Open the inventory bag on button press
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ready for the quiz?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to QuestionPage and pass selected items
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionPage(selectedItems: selectedItems),
                  ),
                );
              },
              child: const Text('Start Quiz'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveInventory, // Save inventory to shared_preferences
              child: const Text('Save Inventory'),
            ),
          ],
        ),
      ),
    );
  }
}
