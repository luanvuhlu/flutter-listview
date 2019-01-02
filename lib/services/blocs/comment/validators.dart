import 'dart:async';

class Validators {
  final validateContent = StreamTransformer<String, String>.fromHandlers(handleData: (String content, EventSink<String> sink){
    if(content.length < 10){
      sink.addError('Must be at least 10 characters');
    } else{
      sink.add(content);
    }
  });
}