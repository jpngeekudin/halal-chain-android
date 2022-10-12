import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/avatar_helper.dart';
import 'package:halal_chain/models/review_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class ReviewListWidget extends StatefulWidget {
  const ReviewListWidget({Key? key, required this.umkmId}) : super(key: key);
  final String umkmId;

  @override
  State<ReviewListWidget> createState() => _ReviewListWidgetState();
}

class _ReviewListWidgetState extends State<ReviewListWidget> {

  Future<List<Review>?> _getReviewList() async {
    try {
      final core = CoreService();
      final params = { 'umkm_id': widget.umkmId };
      final res = await core.genericGet(ApiList.coreGetReview, params);
      final List<Review> reviewList = res.data.map<Review>((reviewJson) => Review.fromJson(reviewJson)).toList();
      return reviewList;
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
    return FutureBuilder(
      future: _getReviewList(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final List<Review> data = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data.isEmpty) Container(
                alignment: Alignment.center,
                child: Text('No review yet', style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                )),
              ),
              ...data.map((review) {
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(30),
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Theme.of(context).primaryColor,
                            backgroundImage: NetworkImage(getAvatarUrl(review.consument.username)),
                          ),
                        ),
                        
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(review.consument.name, style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                              SizedBox(height: 10),
                              RatingBarIndicator(
                                rating: review.point,
                                itemSize: 20,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                )
                              ),
                              SizedBox(height: 10),
                              Text(review.desc, style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 11,
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
            ],
          );
        }
        
        return SizedBox(
          height: 400,
          child: Center(
            child: snapshot.hasError
              ? Text(snapshot.error.toString(), style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600]
              ))
              : CircularProgressIndicator(),
          ),
        );
      }
    );
  }
}