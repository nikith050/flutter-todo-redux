import 'package:flutter_todo_redux/model/model.dart';
import 'package:flutter_todo_redux/redux/actions.dart';

AppState appStateReducer (AppState state, action) {
  return AppState(
    items: itemReducer(state.items, action)
  );
}

List<Item> itemReducer(List<Item> state, action) {
  if(action is AddItemAction) {
    return []..addAll(state)..add(Item(id: action.id, body: action.item));
  }

  if(action is RemoveItemAction) {
    return List.unmodifiable(List.from(state)..remove(action.item));
  }

  if(action is RemoveItemsAction) {
    return List.unmodifiable([]);
  }

  return state;
}