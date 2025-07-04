import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';

class DailyChallengeWidget extends StatefulWidget {
  const DailyChallengeWidget({super.key});

  @override
  State<DailyChallengeWidget> createState() => DailyChallengeWidgetState();
}

class DailyChallengeWidgetState extends State<DailyChallengeWidget> {
  final Dio _dio = DioService.dio;

  Future<void> init() async {
    Response response = await _dio.get(
      'http://localhost:3000/api/daily-challenge/all',
      options: Options(),
    );

    if (response.statusCode == 200) {
      // Handle the response data
    } else {
      // Handle error
      print('Error fetching daily challenge: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            decoration: BoxDecoration(
              color: FccColors.gray85,
              borderRadius: BorderRadius.circular(8.0),
            ),
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                print('Tapped on Daily Challenge $index');
              },
              title: Text('Daily Challenge $index'),
            ),
          );
        },
      ),
    );
  }
}
