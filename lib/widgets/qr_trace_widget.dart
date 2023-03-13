import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/models/qr_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';
import 'package:timelines/timelines.dart';

class QrTraceWidget extends StatefulWidget {
  const QrTraceWidget({Key? key, required this.umkmId}) : super(key: key);
  final String umkmId;

  @override
  State<QrTraceWidget> createState() => _QrTraceWidgetState();
}

class _QrTraceWidgetState extends State<QrTraceWidget> {

  Future _getTrace() async {
    try {
      final core = CoreService();
      final params = { 'umkm_id': widget.umkmId };
      final res = await core.genericGet(ApiList.coreTracing, params);
      final data = QrDetailCore.fromJson(res.data);
      return data;  
    }

    catch(err, trace) {
      final logger = Logger();
      logger.e(err);
      logger.e(trace);
      
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data?['message'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw(message);
    }
  }

  Widget _getTimelineContentCard({required Widget child}) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Tracing', style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18
        )),
        SizedBox(height: 10),
        FutureBuilder(
          future: _getTrace(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final QrDetailCore data = snapshot.data;
              final timelineNode = TimelineNode(
                indicator: DotIndicator(),
                startConnector: SolidLineConnector(),
                endConnector: SolidLineConnector(),
              );

              return FixedTimeline(
                children: [

                  // registration
                  TimelineTile(
                    contents: _getTimelineContentCard(
                      child: Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Text('Registartion', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                          SizedBox(height: 10),
                          Wrap(
                            children: [
                              Text('Status: '),
                              Text(data.registration.status ? 'Sudah' : 'Belum')
                            ],
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            children: [
                              Text('Tanggal: '),
                              Text(defaultDateFormat.format(data.registration.date))
                            ],
                          )
                        ],
                      ),
                    ),
                    node: timelineNode,
                    nodeAlign: TimelineNodeAlign.start,
                  ),

                  // bpjph checking
                  TimelineTile(
                    contents: _getTimelineContentCard(
                      child: Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Text('Checked by BPJPH', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                          SizedBox(height: 10),
                          Wrap(
                            children: [
                              Text('Status: '),
                              Text(data.bpjphChecked.status ? 'Sudah' : 'Belum')
                            ],
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            children: [
                              Text('Tanggal: '),
                              Text(defaultDateFormat.format(data.bpjphChecked.date)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(data.bpjphChecked.desc, style: TextStyle(
                            color: Colors.grey[600]
                          ))
                        ],
                      ),
                    ),
                    node: timelineNode,
                    nodeAlign: TimelineNodeAlign.start,
                  ),

                  // lph appointment
                  TimelineTile(
                    contents: _getTimelineContentCard(
                      child: Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Text('LPH Appointment', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                          SizedBox(height: 10),
                          Wrap(children: [
                            Text('BPJPH: '),
                            Text(data.lphAppointment.bpjphId)
                          ],),
                          SizedBox(height: 10),
                          Wrap(children: [
                            Text('LPH: '),
                            Text(data.lphAppointment.lphId)
                          ],),
                          SizedBox(height: 10),
                          Wrap(children: [
                            Text('Tanggal: '),
                            Text(defaultDateFormat.format(data.lphAppointment.date))
                          ],)
                        ],
                      ),
                    ),
                    node: timelineNode,
                    nodeAlign: TimelineNodeAlign.start,
                  ),

                  // lph checking
                  TimelineTile(
                    contents: _getTimelineContentCard(
                      child: Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Text('Checked by LPH', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                          SizedBox(height: 10),
                          Wrap(children: [
                            Text('Status: '),
                            Text(data.lphChecked.status.toString()),
                          ],),
                          SizedBox(height: 10),
                          Wrap(children: [
                            Text('Survey Location: '),
                            Text(data.lphChecked.surveyLocation ? 'Sudah' : 'belum')
                          ],),
                          SizedBox(height: 10),
                          Wrap(children: [
                            Text('Tanggal: '),
                            Text(defaultDateFormat.format(data.lphChecked.date))
                          ],),
                          SizedBox(height: 10),
                          Text(data.lphChecked.desc, style: TextStyle(
                            color: Colors.grey[600]
                          ),)
                        ],
                      ),
                    ),
                    node: timelineNode,
                    nodeAlign: TimelineNodeAlign.start,
                  ),

                  // mui checking
                  TimelineTile(
                    node: timelineNode,
                    nodeAlign: TimelineNodeAlign.start,
                    contents: _getTimelineContentCard(
                      child: Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Text('Checked by MUI', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                          SizedBox(height: 10),
                          Wrap(children: [
                            Text('Status: '),
                            Text(data.mui.checkedStatus ? 'Sudah' : 'Belum')
                          ],),
                          SizedBox(height: 10),
                          Wrap(children: [
                            Text('Approved: '),
                            Text(data.mui.approved)
                          ],),
                          SizedBox(height: 10),
                          Wrap(children: [
                            Text('Tanggal: '),
                            Text(defaultDateFormat.format(data.mui.date))
                          ],),
                          SizedBox(height: 10),
                          Text(data.mui.decisionDesc, style: TextStyle(
                            color: Colors.grey[600]
                          ))
                        ],
                      ),
                    ),
                  ),

                  // certificate
                  TimelineTile(
                    node: timelineNode,
                    nodeAlign: TimelineNodeAlign.start,
                    contents: _getTimelineContentCard(
                      child: Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Text('Certificate', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                          SizedBox(height: 10),
                          Wrap(children: [
                            Text('Status: '),
                            Text(data.certificate.status ? 'Sudah' : 'Belum')
                          ]),
                          SizedBox(height: 10),
                          Wrap(children: [
                            Text('Created: '),
                            Text(defaultDateFormat.format(data.certificate.createdDate))
                          ],),
                          SizedBox(height: 10,),
                          Wrap(children: [
                            Text('Expired: '),
                            Text(defaultDateFormat.format(data.certificate.expiredDate))
                          ],),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }

            else if (snapshot.hasError) {
              final messageStyle = TextStyle(
                fontSize: 24,
                color: Colors.grey[600]
              );
              final message = snapshot.error?.toString() ?? 'Something went wrong';
              return Center(
                child: Text(message, style: messageStyle,),
              );
            }

            else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
      ]
    );
  }
}