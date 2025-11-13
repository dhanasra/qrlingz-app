import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:qrlingz_app/network/models/feedback_data.dart';
import 'package:screenshot/screenshot.dart';

import '../../../network/firebase_client.dart';
import '../../../network/models/review_data.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc() : super(FeedbackInitial()) {
    on<GetReviewsEvent>(_onGetReviews);
    on<DownloadReviewReportEvent>(_onDownloadReviewReport);
  }
  
  final FirebaseClient _client = FirebaseClient();

  _onDownloadReviewReport(DownloadReviewReportEvent event, Emitter emit)async{
    try{
      emit(Exporting());

      var result = await _client.feedbackDB.doc(event.id).get();
      var feedback = FeedbackData.fromMap(result.data());

      var res = await _client.feedbackDB.doc(event.id).collection(Collection.reviews).get();
      var data =  res.docs.map((e){
        var review = ReviewData.fromMap(e.data());
        var map = {
          "email": review.email ?? "Unknown",
          "phone": review.phone ?? "Unknown",
        };

        for (var item in feedback.categories) {
          map[item.name] = "rating: ${review.reviews[item.name]?["rating"]?? ''}, comment: ${review.reviews[item.name]?["comment"]?? ''}";
        }
        return map;
      }).toList();

      exportListToExcel(data);

      emit(ExportSuccess());
    }catch(e){
      emit(Failure());
    }
  }

  Future<void> exportListToExcel(List<Map> dataList) async {
    
    final excel = Excel.createExcel();
    final Sheet sheet = excel['Feedback Reviews'];
    for (var key in dataList.first.keys) {
      sheet.cell(CellIndex.indexByString('${String.fromCharCode('A'.codeUnitAt(0) + dataList.first.keys.toList().indexOf(key) + 1)}1')).value = TextCellValue(key);
    }
    for (int i = 0; i < dataList.length; i++) {
      final rowData = dataList[i];
      rowData.forEach((key, value) {
        sheet.cell(CellIndex.indexByString('${String.fromCharCode('A'.codeUnitAt(0) + rowData.keys.toList().indexOf(key) + 1)}${i + 2}')).value = TextCellValue(value);
      });
    }
    final directory = Directory('/storage/emulated/0/Download');
    final file = File('${directory.path}/feedback-reviews-qrlingz.xlsx');
    var fileBytes = excel.save();
    await file.writeAsBytes(fileBytes??[]);
    OpenFilex.open(file.path);
  }

  _onGetReviews(GetReviewsEvent event, Emitter emit) async {
    try{
      emit(Loading());

      var res = await _client.feedbackDB.doc(event.id).collection(Collection.reviews).get();
      var data =  res.docs.map((e) => ReviewData.fromMap(e.data())).toList();
      Map averages = calculateAverageRatings(data.map((e) => e.toMap()).toList());

      emit(ReviewsFetched(rating: "${averages['rating']}",categories: averages['categories'], reviews: data));
    }catch(e){
      emit(Failure());
    }
  }

  Map calculateAverageRatings(List<Map<String, dynamic>> data) {
    Map<String, int> categorySums = {};
    Map<String, int> categoryCounts = {};

    int totalSum = 0;
    int totalCount = 0;

    // Iterate through the data
    for (var entry in data) {
      var reviews = entry['reviews'] ?? {};
      reviews.forEach((category, review) {
        int rating = int.tryParse(review['rating'] ?? '0') ?? 0;
        
        // Update the sum and count for each category
        if (!categorySums.containsKey(category)) {
          categorySums[category] = 0;
          categoryCounts[category] = 0;
        }
        categorySums[category] = categorySums[category]! + rating;
        categoryCounts[category] = categoryCounts[category]! + 1;

        totalSum += rating;
        totalCount += 1;
      });
    }

    // Calculate the average rating for each category
    Map<String, double> categoryAverages = {};
    categorySums.forEach((category, sum) {
      if (categoryCounts[category]! > 0) {
        categoryAverages[category] = (sum / categoryCounts[category]!).toPrecision(1);
      }
    });

    double overallAverage = (totalCount > 0 ? totalSum / totalCount : 0.0).toPrecision(1);

    return {
      "rating": overallAverage,
      "categories": categoryAverages
    };
  }
}
