import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cafein_beta/home_page.dart';
import 'package:cafein_beta/page_store/11-11gallery_page.dart';
import 'package:cafein_beta/page_store/Mind-k_page.dart';
import 'package:cafein_beta/page_store/Mypapilio_page.dart';
import 'package:cafein_beta/page_store/abe_page.dart';
import 'package:cafein_beta/page_store/amarna_page.dart';
import 'package:cafein_beta/page_store/anna_page.dart';
import 'package:cafein_beta/page_store/attaroast_page.dart';
import 'package:cafein_beta/page_store/balcony_page.dart';
import 'package:cafein_beta/page_store/bann_page.dart';
import 'package:cafein_beta/page_store/blendstorm_page.dart';
import 'package:cafein_beta/page_store/bluescoffee_page.dart';
import 'package:cafein_beta/page_store/bossa_page.dart';
import 'package:cafein_beta/page_store/commune_page.dart';
import 'package:cafein_beta/page_store/godfather_page.dart';
import 'package:cafein_beta/page_store/impression_page.dart';
import 'package:cafein_beta/page_store/lava_page.dart';
import 'package:cafein_beta/page_store/life_page.dart';
import 'package:cafein_beta/page_store/napcoffee_page.dart';
import 'package:cafein_beta/page_store/napwarin_page.dart';
import 'package:cafein_beta/page_store/penser_page.dart';
import 'package:cafein_beta/page_store/phantae_page.dart';
import 'package:cafein_beta/page_store/red_page.dart';
import 'package:cafein_beta/page_store/rogue_page.dart';
import 'package:cafein_beta/page_store/roof_page.dart';
import 'package:cafein_beta/page_store/rosieholm_page.dart';
import 'package:cafein_beta/page_store/round_page.dart';
import 'package:cafein_beta/page_store/saereesook_page.dart';
import 'package:cafein_beta/page_store/sangob_page.dart';
import 'package:cafein_beta/page_store/snoopcat_page.dart';
import 'package:cafein_beta/page_store/songsarn_page.dart';
import 'package:cafein_beta/page_store/stufe_page.dart';
import 'package:cafein_beta/page_store/treecaferimmoon_Page.dart';
import 'package:cafein_beta/page_store/yuanjai_page.dart';

class CoffeePage extends StatefulWidget {
  const CoffeePage({super.key});

  @override
  State<CoffeePage> createState() => _CoffeePageState();
}

class _CoffeePageState extends State<CoffeePage> {
  final maxLines = 5;
  final ShawdowColor = Color.fromRGBO(0, 0, 0, 0.25);
  final SecondColor = Color.fromRGBO(0, 0, 0, 0.50);
  final BgColor = Color(0xFFE6E6E6);
  final MainColor = Color(0xFFF2D1AF);
  final TestIMG = ImageIcon(
    AssetImage(
      'assets/ratting.png',
    ),
    color: Color(0xFFF2D1AF),
    size: 1,
  );
  final Logo = Image(
    image: AssetImage('assets/cafein_logo.png'),
    fit: BoxFit.cover,
  );

  void gotoPage(String pageName) {
    switch (pageName) {
      case 'Home':
        {
          //statements;
          Navigator.push(
              context, CupertinoPageRoute(builder: (redContext) => HomePage()));
        }
        break;

      case "Nap x Warin":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => NapswarinPage()));
        }
        break;

      case "Sangob":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => SagnobPage()));
        }
        break;

      case "Tree Cafe Rim Moon":
        {
          //statements;
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (redContext) => TreecaferimmoonPage()));
        }
        break;

      case "MiND-K coffee and bake":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => MindkPage()));
        }
        break;

      case "NAP's Coffee & Roasters":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => NapcoffeePage()));
        }
        break;

      case "Yuanjai Café":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => YuanjaiPage()));
        }
        break;

      case "Amarna":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => AmarnaPage()));
        }
        break;

      case "11.11 Gallery and Coffee":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => GalleryPage()));
        }
        break;

      case "Phantae Coffee":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => PhantaePage()));
        }
        break;

      case "ROSIEHOLM":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => RosieholmPage()));
        }
        break;

      case "SongSarn":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => SongsarnPage()));
        }
        break;

      case "Blues Coffee":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => BluescoffeePage()));
        }
        break;

      case "Blendstorm Coffee Roasters":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => BlendstormPage()));
        }
        break;

      case "Commune Drink/Talk/Share":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => CommunePage()));
        }
        break;

      case "Abe Specialty Coffee":
        {
          //statements;
          Navigator.push(
              context, CupertinoPageRoute(builder: (redContext) => AbePage()));
        }
        break;

      case "Rogue Roasters":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => RoguePage()));
        }
        break;

      case "REDCOFFEE":
        {
          //statements;
          Navigator.push(
              context, CupertinoPageRoute(builder: (redContext) => RedPage()));
        }
        break;

      case "PENSER CAFE":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => PenserPage()));
        }
        break;

      case "Snoopcat Cafe":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => SnoopcatPage()));
        }
        break;

      case "Stufe coffee":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => StufePage()));
        }
        break;

      case "Attaroast":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => AttaroastPage()));
        }
        break;

      case "GODFATHER COFFEE":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => GodfatherPage()));
        }
        break;

      case "LAVA  JAVA Coffee Roasters":
        {
          //statements;
          Navigator.push(
              context, CupertinoPageRoute(builder: (redContext) => LavaPage()));
        }
        break;

      case "Saereesook":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => SaereesookPage()));
        }
        break;

      case "LIFE Roasters":
        {
          //statements;
          Navigator.push(
              context, CupertinoPageRoute(builder: (redContext) => LifePage()));
        }
        break;

      case "BaanHuakham Cafe & Farmstay":
        {
          //statements;
          Navigator.push(
              context, CupertinoPageRoute(builder: (redContext) => BannPage()));
        }
        break;

      case "Bossa cafe":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => BossaPage()));
        }
        break;

      case "ROOF COFFEE":
        {
          //statements;
          Navigator.push(
              context, CupertinoPageRoute(builder: (redContext) => RoofPage()));
        }
        break;

      case "Impression Sunrise":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => ImpressionPage()));
        }
        break;

      case "Anna Roasters":
        {
          //statements;
          Navigator.push(
              context, CupertinoPageRoute(builder: (redContext) => AnnaPage()));
        }
        break;

      case "My Papilio":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => MypapilioPage()));
        }
        break;

      case "BalconyKiss Coffee":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => BalconyPage()));
        }
        break;

      case "r o u n d":
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => RoundPage()));
        }
        break;

      default:
        {
          throw Exception("Path ${pageName} not supported");
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee'),
        toolbarHeight: 70,
        elevation: 0,
      ),
      body: StreamBuilder(
          //reviews
          stream: FirebaseFirestore.instance
              .collection("search")
              .orderBy("rating", descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    var data = snapshot.data!.docs[i];
                    var rt = data["rating"];
                    return Card(
                      child: ListTile(
                        leading: FittedBox(
                            child: Image(
                                image: AssetImage('assets/coffee03.jpg'),
                                fit: BoxFit.fill)),
                        title: Text(data["string_name"]),
                        subtitle: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Address : ${data["address"]}'),
                              Text('Type : ${data["type"]}'),
                              RatingBarIndicator(
                                rating: double.parse(rt),
                                itemBuilder: (context, index) => TestIMG,
                                itemCount: 5,
                                itemSize: 20,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 0),
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Icon(Icons.arrow_forward_ios),
                        ),
                        onTap: () {
                          gotoPage(data["string_name"]);
                        },
                      ),
                    );
                  });
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
