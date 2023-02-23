import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'NewsModel.dart';


class TechPg extends StatefulWidget {

  String Query;
  TechPg(
      {Key? key,
        required this.Query,
      })
      : super(key: key);


  @override
  State<TechPg> createState() => _TechPgState();
}

class _TechPgState extends State<TechPg> {
  Future<NewsModel> getNewsApi(String query) async{
    final response = await http.get(Uri.parse('https://newsapi.org/v2/everything?q=$query&apiKey=baea8a5de1a74cfc93627e7a4ca3a4d4'));
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200)
    {
      return NewsModel.fromJson(data);
    }
    else
    {
      return NewsModel.fromJson(data);
    }
  }
  Future<void> _makeSocialMediaRequest(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  void initState() {
    super.initState();
    getNewsApi(widget.Query);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Query,style: GoogleFonts.abel(fontSize: 23),),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body:  FutureBuilder(
        future: getNewsApi(widget.Query),
        builder: (context,snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.articles!.length,
                itemBuilder: (context,index)
                {
                  return Column(
                    children: [
                      GestureDetector(
                          onTap: (){
                            //_launchURL(snapshot.data!.articles![index].url.toString());
                            _makeSocialMediaRequest(snapshot.data!.articles![index].url.toString());
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                            //height: MediaQuery.of(context).size.height*.3,
                            height: 280,
                            width: MediaQuery.of(context).size.width*1,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(
                                      0.0,
                                      10.0,
                                    ),
                                    blurRadius: 10.0,
                                    spreadRadius: -6.0,
                                  ),
                                ],
                                image: DecorationImage(
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.4),
                                      BlendMode.multiply,
                                    ),
                                    image: NetworkImage(snapshot.data!.articles![index].urlToImage.toString()),fit: BoxFit.cover)
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Text(
                                      snapshot.data!.articles![index].title.toString(),
                                      style:
                                      // TextStyle(
                                      //   color: Colors.white,
                                      //   fontSize: 24,
                                      //   fontWeight: FontWeight.w900,
                                      //   fontStyle: FontStyle.italic,
                                      // ),
                                      GoogleFonts.abel(color: Colors.white,fontSize: 24),
                                      //overflow: TextOverflow.ellipsis,
                                      //maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  //alignment: Alignment.center,
                                ),
                              ],
                            ),
                          )
                      )
                    ],
                  );

                });
          }
          else
          {
            return Text("Loading");
          }
        },),
    );
  }
}
