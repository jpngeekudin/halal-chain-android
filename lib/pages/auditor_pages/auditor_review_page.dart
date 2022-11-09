import 'package:flutter/material.dart';
import 'package:halal_chain/widgets/review_list_widget.dart';

class AuditorReviewPage extends StatelessWidget {
  const AuditorReviewPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final umkmId = args['id'];
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Review')
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: ReviewListWidget(
              umkmId: umkmId,
            ),
          ),
        )
      ),
    );
  }
}