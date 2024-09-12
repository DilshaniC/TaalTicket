import 'package:flutter/material.dart';
import 'package:rive_animation/communicators/show.dart';
import 'package:rive_animation/communicators/show_list_response.dart';
import 'package:rive_animation/communicators/venue.dart';

import '../../communicators/ticket.dart';
import 'edit_show.dart';

class AdminListCardsScreen extends StatefulWidget {
  const AdminListCardsScreen({super.key});

  @override
  _AdminListCardsScreenState createState() => _AdminListCardsScreenState();
}

class _AdminListCardsScreenState extends State<AdminListCardsScreen> {
  List<Show> shows = [];
  List<Show> searchResults = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _asyncMethod();
  }

  _asyncMethod() async {
    ShowList? showList = await ShowList.getAllShowsHelper();
    setState(() {
      shows = showList?.allShows ?? [];
      searchResults = shows;
    });
  }

  void onQueryChanged(String query) {
    setState(() {
      isSearching = query.isNotEmpty;
      searchResults = shows
          .where((show) =>
          show.showName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget card(Show show, BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 260,
            child: Column(children: [
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text(
                  show.showName,
                  style: const TextStyle(
                    fontSize: 38.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(show.image),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
                  child: Text(show.description,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.justify)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  // Respond to button press
                                  bool? result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditShowPage(
                                        id: show.id,
                                        showName: show.showName,
                                        description: show.description,
                                        image: show.image,
                                        venues: show.venues,
                                        tickets: show.tickets,
                                        artists: show.artists,
                                      ),
                                    ),
                                  );
                                  if (result == true) {
                                    _asyncMethod(); // Refresh the show list
                                  }
                                },
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text("Edit"),
                              ),
                            ),
                          ])),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search Shows...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
          onChanged: onQueryChanged,
        ),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return card(searchResults[index], context);
              },
              itemCount: searchResults.length,
            ),
          ),
        ],
      ),
    );
  }
}
