import 'package:delivery_changmin/common/const/data.dart';
import 'package:delivery_changmin/restaurant/component/restaurant_card.dart';
import 'package:delivery_changmin/restaurant/model/restaurant_model.dart';
import 'package:delivery_changmin/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List> paginateRestaurant() async {
    final dio = Dio();
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get('http://$ip/restaurant',
      options: Options(
        headers: {
          'authorization' : 'Bearer $accessToken'
        }
      ));

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    //Scaffold를 선언할 필요가 없음 탭바뷰가 포함된 루트 탭에 선언되어있기 때문에 탭뷰만 구성
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder<List>(
            future: paginateRestaurant(),
            builder: (context,AsyncSnapshot<List> snapshot){
              if(!snapshot.hasData){
                return Container();
              }
              return ListView.separated(
                itemCount: snapshot.data!.length,
                  itemBuilder: (_,index){
                    final item = snapshot.data![index];
                    //parsed변환
                    final pItem = RestaurantModel.fromJson(
                      json : item
                    );
                    return GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => RestaurantDetailScreen())
                        );
                      },
                      child: RestaurantCard.fromModel(
                        pItem : pItem
                      ),
                    );
                  },
                  separatorBuilder: (_,index){
                    return SizedBox(height: 16,);
                  },
              );


            },
          )
        ),
      ),
    );
  }
}
