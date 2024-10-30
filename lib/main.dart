import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyToDo());
}

class MyToDo extends StatelessWidget { 
  const MyToDo({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const TodoList(title: 'My Todo List'),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key, required this.title});
  final String title;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _todoController = TextEditingController();

  void _handleAddTodo() {
    if (_todoController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('todos').add({
        'title': _todoController.text,
        'completed': false,
        'timestamp': FieldValue.serverTimestamp(),
        'isDeleted': false,
      });
      _todoController.clear();
    }
  }

  void _toggleTodo(String docId, bool currentStatus) {
    FirebaseFirestore.instance
        .collection('todos')
        .doc(docId)
        .update({'completed': !currentStatus});
  }

  void _deleteTodo(String docId) {
    FirebaseFirestore.instance
        .collection('todos')
        .doc(docId)
        .update({'isDeleted': true});
  }

  void _restoreTodo(String docId) {
    FirebaseFirestore.instance
        .collection('todos')
        .doc(docId)
        .update({'isDeleted': false});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Deleted Items'),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('todos')
                          .where('isDeleted', isEqualTo: true)
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.data!.docs.isEmpty) {
                          return const Text('No deleted items');
                        }
                        
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final doc = snapshot.data!.docs[index];
                            final todo = doc.data() as Map<String, dynamic>;
                            
                            return ListTile(
                              title: Text(todo['title'] ?? ''),
                              trailing: IconButton(
                                icon: const Icon(Icons.restore),
                                onPressed: () {
                                  _restoreTodo(doc.id);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                      hintText: 'Add a new ToDo',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleAddTodo(),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: _handleAddTodo,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('todos')
                  .where('isDeleted', isEqualTo: false)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint('Error: ${snapshot.error}');
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final todo = doc.data() as Map<String, dynamic>;
                    
                    return Dismissible(
                      key: Key(doc.id),
                      onDismissed: (_) => _deleteTodo(doc.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          value: todo['completed'] ?? false,
                          onChanged: (bool? value) {
                            _toggleTodo(doc.id, todo['completed'] ?? false);
                          },
                        ),
                        title: Text(
                          todo['title'] ?? '',
                          style: TextStyle(
                            decoration: todo['completed'] ?? false
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _deleteTodo(doc.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
