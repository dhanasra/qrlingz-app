import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../network/firebase_client.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountInitial()) {
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<LogoutEvent>(_onLogout);
    on<SaveProfileEvent>(_onSaveProfile);
  }

  final FirebaseClient _client = FirebaseClient();

  _onSaveProfile(SaveProfileEvent event, Emitter emit)async{
   try{
      emit(Loading());
      await _client.userDB.doc(_client.userId).update({
        "firstName": event.fname,
        "lastName": event.lname,
        "phone": event.phone
      });
      emit(ProfileUpdated());
    }catch(e){
      emit(Error());
    }
  }

  _onDeleteAccount(DeleteAccountEvent event, Emitter emit)async{
    try{
      emit(Loading());
      await _client.userDB.doc(_client.userId).delete();
      await _client.delete();
      emit(AccountDeleted());
    }catch(e){
      emit(Error());
    }
  }

  _onLogout(LogoutEvent event, Emitter emit)async{
    try{
      emit(Loading());
      await _client.logout();
      emit(LoggedOut());
    }catch(e){
      emit(Error());
    }
  }
}
