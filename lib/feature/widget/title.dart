import 'package:flutter/material.dart';
import 'package:front/constants/constants.dart';
import 'package:front/states/sharedvalue.dart';
import 'package:front/theme/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;
import 'dart:convert';

import 'package:provider/provider.dart';

class Title {
  int movieId;
  String movieTitle;
  double ratingScore;
  List<String> movieGenre;
  double? myRatingScore;

  Title(
      {required this.movieId,
      required this.movieTitle,
      required this.ratingScore,
      required this.movieGenre,
      this.myRatingScore});

  factory Title.fromJson(Map<String, dynamic> parsedJson) {
    return Title(
        movieId: parsedJson['movieId'],
        movieTitle: parsedJson['movieTitle'],
        ratingScore: parsedJson['ratingScore'],
        movieGenre: parsedJson['movieGenre'].cast<String>() as List<String>,
        myRatingScore: (parsedJson.containsKey('myRatingScore'))
            ? parsedJson['myRatingScore']
            : null);
  }
}

class PosterURL {
  String movieTitle;
  static const String noPosterUrl = "";

  PosterURL({required this.movieTitle});

  String removeYear(String title) {
    return title.replaceAll(RegExp(r' \(\d+\)$'), '');
  }

  Future<String> fetchData() async {
    final response = await http.get(Uri.parse(
        r'https://api.themoviedb.org/3/search/movie?api_key=15d2ea6d0dc1d476efbca3eba2b9bbfb&query=' +
            removeYear(movieTitle)));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['total_results'] == 0) {
        return noPosterUrl;
      }
      return "https://image.tmdb.org/t/p/w500/" +
          jsonData['results'][0]['poster_path'];
    } else {
      return noPosterUrl;
    }
  }
}

class PosterLoader extends StatelessWidget {
  Widget noPoster;
  String movieTitle;
  double? width;
  double? height;

  PosterLoader(
      {required this.noPoster,
      required this.movieTitle,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: PosterURL(movieTitle: movieTitle).fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String url = snapshot.data!;
          if (url == "") return noPoster;
          return Image.network(
            url,
            fit: BoxFit.fill,
            width: width,
            height: height,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          );
        } else {
          return noPoster;
        }
      },
    );
  }
}

class TitleInfo extends StatelessWidget {
  String url;

  TitleInfo({required this.url});

  Future<List<Title>> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<Title> data = [];
      jsonData.forEach((e) => data.add(Title.fromJson(e)));
      return data;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Title>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Title> d = snapshot.data!;
          return Container(height: 308, child: _rowTitleList(context, d));
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _noPoster() {
    return Image.asset(
      "images/noPoster.png",
      fit: BoxFit.fill,
      width: 150,
    );
  }

  Widget _rowTitleList(BuildContext context, List<Title> d) {
    ScrollController _horizontal = ScrollController();
    return Scrollbar(
      controller: _horizontal,
      child: ListView(
        controller: _horizontal,
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: List<Widget>.generate(
          d.length,
          (index) => GestureDetector(
            onTap: () {
              TitleDialog(
                movieId: d[index].movieId,
              ).dialog(context);
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Color(0xff000000), Color(0xff222222)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
                child: Column(
                  children: [
                    //이미지

                    PosterLoader(
                      movieTitle: d[index].movieTitle,
                      noPoster: _noPoster(),
                      width: 150,
                    ),
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: SizedBox(
                          width: 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                d[index].movieTitle,
                                style: MyTheme.themeData.textTheme.titleSmall,
                                overflow: TextOverflow.fade,
                                maxLines: 3,
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TitleDialog {
  int movieId;
  int userId = -1;

  TitleDialog({required this.movieId});

  Widget _noPoster() {
    return Image.asset(
      "images/noPoster.png",
      fit: BoxFit.fill,
      width: 300,
    );
  }

  void dialog(BuildContext context) {
    userId = Provider.of<SharedValue>(context, listen: false).userId;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xff111111),
            title: Text("영화 정보 상세보기"),
            content: FutureBuilder<Title>(
              future: fetchData(),
              builder: (context, data) {
                if (data.hasData) {
                  return _movieDialog(data.data!);
                } else if (data.hasError) {
                  return Center(
                    child: Text('Error: ${data.error}'),
                  );
                } else {
                  return _movieDialog(Title(
                      movieId: 0,
                      movieTitle: "",
                      movieGenre: [],
                      ratingScore: 0.0,
                      myRatingScore: 0.0));
                }
              },
            ),
            actions: [
              TextButton(
                child: Text("닫기"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget _movieDialog(Title d) {
    final icon = [Icons.movie, Icons.abc, Icons.star, Icons.star];
    final column = ["제목", "장르", "유저 평균 점수", "나의 점수"];
    final data = [
      Text(d.movieTitle),
      _genreButton(d.movieGenre),
      Text(d.ratingScore.toString()),
      Text(d.myRatingScore.toString())
    ];
    return SingleChildScrollView(
      child: Column(
        children: [
          PosterLoader(
            noPoster: _noPoster(),
            width: 300,
            movieTitle: d.movieTitle,
          ),
          Column(
            children: List<Widget>.generate(
              icon.length,
              (index) => Row(
                children: [
                  Icon(
                    icon[index],
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8.0),
                  Text(column[index]),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: data[index],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _genreButton(List<String> genres) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
        children: List.generate(
      genres.length,
      (index) => FilterChip(
        label: Text(genres[index]),
        onSelected: (e) {},
        backgroundColor: Colors.red,
      ),
    ));
  }

  Future<Title> fetchData() async {
    final response = await http.get(Uri.parse(MyConst.apiServerUrl +
        r"/api/movieData?movieId=" +
        movieId.toString() +
        r"&userId=" +
        userId.toString()));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Title.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
