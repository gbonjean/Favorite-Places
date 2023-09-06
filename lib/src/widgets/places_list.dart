import 'package:favorite_places/src/screens/place_detail.dart';
import 'package:flutter/material.dart';

import '../models/place.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    return places.isEmpty
        ? Center(
            child: Text(
              'No places added yet',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
          )
        : ListView.builder(
            itemCount: places.length,
            itemBuilder: ((context, index) => ListTile(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) =>
                          PlaceDetailScreen(place: places[index]))),
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundImage: FileImage(places[index].image),
                  ),
                  title: Text(
                    places[index].title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  subtitle: Text(
                    places[index].location.address,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                )),
          );
  }
}
