import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/http_helper.dart';
import 'package:halal_chain/helpers/modal_helper.dart';
import 'package:halal_chain/models/pelaporan_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:halal_chain/widgets/future_builder_wrapper.dart';
import 'package:logger/logger.dart';

class AuditorPelaporanPage extends StatelessWidget {
  const AuditorPelaporanPage({Key? key}) : super(key: key);

  Future<List<Pelaporan>> _getPelaporan(BuildContext context) async {
    final logger = Logger();
    try {
      final core = CoreService();
      final Map<String, dynamic> params = {};
      final res = await core.genericGet(ApiList.pelaporanGet, params);
      final pelaporanList = res.data.map<Pelaporan>((json) => Pelaporan.fromJSON(json)).toList();
      return pelaporanList;
    }

    catch(err) {
      handleHttpError(context: context, err: err);
      rethrow;
    }
  }

  void _openPelaporanModal({
    required BuildContext context,
    required Pelaporan pelaporan,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: ModalBottomSheetShape,
      builder: (context) {
        final styleBold = TextStyle(fontWeight: FontWeight.bold);
        final styleMuted = TextStyle(color: Colors.grey[600]);
        return getModalBottomSheetWrapper(
          context: context,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Nama UMKM'),
                      Text(pelaporan.umkmName, style: styleBold)
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('User Name'),
                      Text(pelaporan.userName, style: styleBold)
                    ],
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Text('Description'),
                      SizedBox(height: 5),
                      Text(pelaporan.description, style: styleMuted)
                    ],
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Text('Address'),
                      SizedBox(height: 5),
                      Text(pelaporan.address, style: styleMuted),
                    ],
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Text('Address'),
                      SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Image.network(ApiList.utilLoadFile + '?image_name=' + pelaporan.image),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Pelaporan List')
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _getPelaporan(context),
            builder: (context, AsyncSnapshot snapshot) {
              final List<Pelaporan> pelaporanList = snapshot.data;
              return futureBuilderWrapper(
                snapshot: snapshot,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: pelaporanList.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder:(context, index) {
                    final pelaporan = pelaporanList[index];
                    return InkWell(
                      onTap: () => _openPelaporanModal(context: context, pelaporan: pelaporan),
                      child: ListTile(
                        title: Text(pelaporan.umkmName),
                        subtitle: Text('By ' + pelaporan.userName, style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 10,
                        )),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}