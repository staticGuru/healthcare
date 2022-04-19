import 'package:flutter/material.dart';
import 'package:meddashboard/bloc/patient_data_stream_bloc.dart';
import 'package:meddashboard/model_views/card_component.dart';
import 'package:meddashboard/models/card.dart';
import 'package:meddashboard/service/api/device.dart';
import 'package:meddashboard/service/models/device_model.dart';
import 'package:meddashboard/service/models/group_model.dart';
import 'package:meddashboard/utils/StreamSocket.dart';


class PatientsGrid extends StatelessWidget {
  final List<CardModel> models;
  final List<GroupDataModel> groupList;
  final String hospitalId;

  // todo use bloc or provider to update parent widget's state
  PatientsGrid(
    this.models,
    this.groupList,
    this.hospitalId,
  );


  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (ctx, sizes) {
        const w = 440 + (4 * 2);
        int patients = models.length;
        print('total--------------'+patients.toString());

        var perOne = sizes.maxWidth / (sizes.maxWidth ~/ w);

        var rows = 1;

//        if (sizes.maxWidth > w * 4)
//          rows = 4;

        if (sizes.maxWidth > w * 3)
          rows = 3;
        else if (sizes.maxWidth > w * 2) rows = 2;

        var columns = patients ~/ rows;
        if (columns * rows != patients) {
          columns++;
        }

        print('total columns-------'+columns.toString());

        var j = -1;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int i in Iterable.generate(columns))

                  Row(
                    children: List.generate(
                        i == columns - 1 ? rows - (columns * rows - patients) : rows, (index) {

                      j++;
                      print('total row------- ' + j.toString());
                      return Container(
                        width: perOne,
                        child: CardComponent(
                          models[j],
                          groupList,
                          hospitalId,
                          data: '',
                          //  snapshot.data != null? snapshot.data : 'blank'
                        ),
                      );
                    }),
                  ),
              ],
            );
          }
    );
  }
}
