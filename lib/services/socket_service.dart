import 'dart:io';

import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}



class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket = IO.io('http://localhost');

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  SocketService(){
    this._initConfig();
  }

  void _initConfig(){

    // Dart client
    //IO.Socket socket = IO.io('http://192.168.8.11:3000', {
    
    this._socket = IO.io('http://localhost:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    

    this._socket.onConnect((_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    /*
    socket.on('nuevo-mensaje', (payload){
      print('nuevo-mensaje:');
      print('nombre: ' + payload['nombre']);
      print('mensaje: ' + payload['mensaje']);
      //print('mensaje: ' + payload['mensaje2']); //revienta la app porque no existe mensaje2
      print(payload.containsKey('mensaje2') ? 'mensaje2: ' + payload['mensaje2'] : 'No existe');
    });
    */


  }

}