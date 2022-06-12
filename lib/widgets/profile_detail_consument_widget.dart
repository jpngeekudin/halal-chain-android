import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:halal_chain/services/core_service.dart';

class ProfileDetailConsumentWidget extends StatelessWidget {
  const ProfileDetailConsumentWidget(this.userId, { Key? key }) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    final core = CoreService();

    Future<UserConsumentData> _consumentData() async {
      try {
        final response = await core.getUser(UserType.consument, userId);
        final consumentData = UserConsumentData.fromJSON(response.data);
        return consumentData;
      }

      catch (err) {
        String message = 'Terjadi kesalahan';
        if (err is DioError) message = err.response?.data['detail'];

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(message)
          )
        );

        throw message;
      }
    }

    Widget _getDetailItem(String label, dynamic value) => Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: TextStyle(
            fontWeight: FontWeight.bold
          ))
        ],
      ),
    );

    return FutureBuilder(
      future: _consumentData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          UserConsumentData consumentData = snapshot.data;

          return Column(
            children: [
              _getDetailItem('Name', consumentData.name),
              Divider(),
              _getDetailItem('Username', consumentData.username),
              Divider(),
              _getDetailItem('Email', consumentData.email),
              Divider(),
              _getDetailItem('Role', consumentData.role),
              Divider(),
              _getDetailItem('Phone Number', consumentData.phone),
              Divider(),
              _getDetailItem('Address', consumentData.address),
              Divider(),
              _getDetailItem('Joined at', consumentData.createdAtString()),
            ],
          );
        }

        else if (snapshot.hasError) {
          final message = snapshot.error?.toString() ?? 'Terjadi kesalahan';
          return Align(
            alignment: Alignment.center,
            child: Text(message),
          );
        }

        else {
          return Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
}