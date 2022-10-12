import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/helpers/modal_helper.dart';
import 'package:halal_chain/helpers/typography_helper.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class ReviewFormWidget extends StatefulWidget {
  ReviewFormWidget({Key? key, required this.umkmId, this.onSuccess}) : super(key: key);
  String umkmId;
  Function? onSuccess;

  @override
  State<ReviewFormWidget> createState() => _ReviewFormWidgetState();
}

class _ReviewFormWidgetState extends State<ReviewFormWidget> {

  bool _loading = false;
  double _ratingModel = 0;
  final _descController = TextEditingController();

  Future _submit() async {
    try {
      final user = await getUserData();
      final core = CoreService();
      final params = {
        'umkm_id': widget.umkmId,
        'consumen_id': user?.id,
        'point': _ratingModel,
        'review': _descController.text,
      };
      final res = await core.genericPost(ApiList.coreCreateReview, null, params); 
      if (widget.onSuccess != null) widget.onSuccess!();
      const snackBar = SnackBar(content: Text('Success uploading review'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    catch(err, trace) {
      final logger = Logger();
      logger.e(err);
      logger.e(trace);
      
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'];
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return getModalBottomSheetWrapper(
      context: context,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              getHeader(context: context, text: 'Give Review'),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: RatingBar.builder(
                  initialRating: _ratingModel,
                  allowHalfRating: true,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber
                  ),
                  onRatingUpdate: (rating) {
                    _ratingModel = rating;
                  }
                ),
              ),
              getInputWrapper(
                label: 'Review',
                input: TextField(
                  controller: _descController,
                  decoration: getInputDecoration(label: 'Review'),
                  style: inputTextStyle,
                )
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _submit(),
                  child:  _loading
                    ? SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      )
                    ) : Text('Submit')
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}