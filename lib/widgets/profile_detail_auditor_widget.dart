import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:halal_chain/services/core_service.dart';

class ProfileDetailAuditorWidget extends StatelessWidget {
  const ProfileDetailAuditorWidget(this.userId, { Key? key }) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    final core = CoreService();

    Future<UserAuditorData> _auditorData() async {
      try {
        final response = await core.getUser(UserType.auditor, userId);
        final auditorData = UserAuditorData.fromJSON(response.data);
        return auditorData;
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
      future: _auditorData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          UserAuditorData auditorData = snapshot.data;

          return Column(
            children: [
              _getDetailItem('No. KTP', auditorData.noKtp),
              Divider(),
              _getDetailItem('Name', auditorData.name),
              Divider(),
              _getDetailItem('Username', auditorData.username),
              Divider(),
              _getDetailItem('Type', auditorData.getType()),
              Divider(),
              _getDetailItem('Role', auditorData.role),
              Divider(),
              _getDetailItem('Religion', auditorData.religion),
              Divider(),
              _getDetailItem('Address', auditorData.address),
              Divider(),
              _getDetailItem('Institution', auditorData.institution),
              Divider(),
              _getDetailItem('Competence', auditorData.competence),
              Divider(),
              _getDetailItem('Experience', auditorData.experience),
              Divider(),
              _getDetailItem('Cert Competence', auditorData.certCompetence),
              Divider(),
              _getDetailItem('Auditor Competence', auditorData.auditorExperience),
              Divider(),
              _getDetailItem('Expired Certificate', auditorData.expiredCertString()),
              Divider(),
              _getDetailItem('Joined at', auditorData.createdAtString()),
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