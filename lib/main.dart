import 'package:flutter/material.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_todo_redux/model/model.dart';
import 'package:flutter_todo_redux/redux/actions.dart';
import 'package:flutter_todo_redux/redux/reducers.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Store<AppState> store =
        Store<AppState>(appStateReducer, initialState: AppState.initialState());

    return StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: new ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
            // counter didn't reset back to zero; the application is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: new MyHomePage(),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Todo App"),
      ),
      body: StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel model) => Column(children: <Widget>[
          AddItemWidget(model),
          Expanded(
            child: ItemListWidget(model),
          ),
          RemoveItemsButton(model)
        ],),
      ),
    );
  }
}

class AddItemWidget extends StatefulWidget {
  final _ViewModel model;

  AddItemWidget(this.model);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItemWidget> {

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

      return TextField(
        controller: controller,
        decoration: InputDecoration(hintText: "add an Item"),
        onSubmitted: (String s) {
          widget.model.onAddItem(s);
          controller.text = '';
        },
      );
    }
}

class ItemListWidget extends StatelessWidget {

  final _ViewModel model;

  ItemListWidget(this.model);

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return ListView(children: model.items.map((Item item) => 
        ListTile(
          title: Text(item.body),
          leading: IconButton(icon: Icon(Icons.delete), onPressed: () => model.onRemoveItem(item),),
        )
      ).toList(),);
    }
}

class RemoveItemsButton extends StatelessWidget {
  final _ViewModel model;

  RemoveItemsButton(this.model);

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return RaisedButton(onPressed: () => model.onRemoveItems(), child: Text('Delete Items'),);
    }
}

class _ViewModel {
  final List<Item> items;
  final Function(String) onAddItem;
  final Function(Item) onRemoveItem;
  final Function() onRemoveItems;

  _ViewModel({
    this.items,
    this.onAddItem,
    this.onRemoveItem,
    this.onRemoveItems
  });

  factory _ViewModel.create(Store<AppState> store) {
    _onAddItem(String body) {
      store.dispatch(AddItemAction(body));
    }

    _onRemoveItem(Item item) {
      store.dispatch(RemoveItemAction(item));
    }

    _onRemoveItems() {
      store.dispatch(RemoveItemsAction());
    }
     return _ViewModel(
       items: store.state.items,
       onAddItem: _onAddItem,
        onRemoveItem: _onRemoveItem,
        onRemoveItems: _onRemoveItems
     );
  }
}
