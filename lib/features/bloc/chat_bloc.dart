import 'package:admin_project/features/bloc/chat_event.dart';
import 'package:admin_project/features/bloc/chat_state.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitialState()) {
    on<ChatEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
