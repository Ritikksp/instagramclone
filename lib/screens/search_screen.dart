
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() {
    return SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isShowUser = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
                icon: Icon(Icons.search)),
            onFieldSubmitted: (String _) {
              setState(() {
                _isShowUser = true;
              });
            },
          ),
        ),
      ),
      body: _isShowUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: _searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreens(uid: (snapshot.data! as dynamic).docs[index]['uid'],),),);
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(
                                (snapshot.data! as dynamic).docs[index]
                                    ['photoUrl']),
                          ),
                          title: Text(
                            (snapshot.data! as dynamic).docs[index]['username'],
                          ),
                        ),
                      );
                    });
              },
            )
          : Padding(
              padding: const EdgeInsets.all(4),
              child: FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return MasonryGridView.builder(
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      gridDelegate:
                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            // 'https://source.unsplash.com/random?sig=$index',
                            (snapshot.data as dynamic).docs[index]['postUrl']
                          ),
                        );
                      });
                },
              ),
            ),
    );
  }
}
