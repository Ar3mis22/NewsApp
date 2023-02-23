import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutternews/TechPg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'NewsModel.dart';

class FlutterNews extends StatefulWidget {
  const FlutterNews({Key? key}) : super(key: key);

  @override
  State<FlutterNews> createState() => _FlutterNewsState();
}

class _FlutterNewsState extends State<FlutterNews> {
   //String? url;

  // Future<void> launchUrlStart({String? url}) async {
  //   if (!await launchUrl(Uri.parse(url?),mode: LaunchMode.externalApplication)) {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<void> _makeSocialMediaRequest(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  // Future<void> _launchUrl(String url) async{
  //   final Uri uri = Uri(scheme: "https",host: url);
  //   if(!await launchUrl(
  //     uri,
  //     mode: LaunchMode.externalApplication,
  //   )){
  //     throw "Cannot launch Url";
  //   }
  // }

  Future<NewsModel> getNewsApi() async{
    final response = await http.get(Uri.parse('https://newsapi.org/v2/top-headlines?country=in&apiKey=baea8a5de1a74cfc93627e7a4ca3a4d4'));
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
  List<String> navBarItem = ["Technology" , "India" , "Lifestyle" , "Finance" , "Health"];



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("FlutterNews"),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: 55,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: navBarItem.length,
                    itemBuilder : (context , index){
                      return InkWell(
                        onTap: () {
                          print(navBarItem[index]);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TechPg(Query: navBarItem[index],)));

                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20 ),
                          margin: EdgeInsets.symmetric(horizontal : 5),
                          decoration : BoxDecoration(
                              color: Colors.blueGrey.shade600,
                              borderRadius : BorderRadius.circular(10)
                          ),

                          child : Center(
                            child: Text(
                                navBarItem[index] ,
                                style: GoogleFonts.abel(color: Colors.white,fontSize: 19)
                            ),
                          ),
                        ),
                      );
                    }
                )
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getNewsApi(),
              builder: (context,snapshot) {
                if(snapshot.hasData){
                  return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context,index)
                      {
                        return RefreshIndicator(
                          onRefresh: () async { await getNewsApi(); },
                          child: Column(
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
                          ),
                        );

                      });
                }
                else
                  {
                    return Text("Loading");
                  }
            },),
          )
        ],
      ),
    );
  }
}
