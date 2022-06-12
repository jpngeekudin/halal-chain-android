import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:halal_chain/services/core_service.dart';

class ProfileDetailUmkmWidget extends StatelessWidget {
  const ProfileDetailUmkmWidget(this.userId, { Key? key }) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    final _core = CoreService();

    Future<UserUmkmData> _umkmData() async {
      try {
        final response = await _core.getUser(UserType.umkm, userId);
        final umkmData = UserUmkmData.fromJSON(response.data);
        return umkmData;
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
      future: _umkmData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          UserUmkmData umkmData = snapshot.data;

          return Column(
            children: [
              _getDetailItem('Username', umkmData.username),
              Divider(),
              _getDetailItem('Company Name', umkmData.companyName),
              Divider(),
              _getDetailItem('Company Address', umkmData.companyAddress),
              Divider(),
              _getDetailItem('Company Number', umkmData.companyNumber),
              Divider(),
              _getDetailItem('Factory Name', umkmData.factoryName),
              Divider(),
              _getDetailItem('Factory Address', umkmData.factoryAddress),
              Divider(),
              _getDetailItem('Email', umkmData.email),
              Divider(),
              _getDetailItem('Product Name', umkmData.productName),
              Divider(),
              _getDetailItem('Product Type', umkmData.productType),
              Divider(),
              _getDetailItem('Marketing Area', umkmData.marketingArea),
              Divider(),
              _getDetailItem('Marketing System', umkmData.marketingSystem),
              Divider(),
              _getDetailItem('Joined at', umkmData.createdAtString()),
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