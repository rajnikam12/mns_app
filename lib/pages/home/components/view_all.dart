import 'package:flutter/material.dart';
import 'package:mns_app/pages/home/components/event_cards.dart';
import 'package:mns_app/pages/home/components/event_detail_page.dart';

class AllEventsPage extends StatelessWidget {
  final List<Event> events; // all events list

  const AllEventsPage({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final upcomingEvents = events.where((e) => e.isUpcoming).toList();
    final completedEvents = events.where((e) => e.isCompleted).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'All Events',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepOrange,
          bottom: TabBar(
            dividerColor: Colors.transparent,
            indicatorAnimation: TabIndicatorAnimation.elastic,
            indicatorColor: Theme.of(context).primaryColorDark,
            indicatorSize: TabBarIndicatorSize.label,

            labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(),
            labelColor: Theme.of(context).scaffoldBackgroundColor,
            unselectedLabelColor: Colors.black26,
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Upcoming Events Tab
            upcomingEvents.isEmpty
                ? const Center(child: Text('No upcoming events'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: upcomingEvents.length,
                    itemBuilder: (context, index) {
                      final event = upcomingEvents[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: EventCard(
                          event: event,
                          onReadMore: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EventDetailPage(event: event),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

            // Completed Events Tab
            completedEvents.isEmpty
                ? const Center(child: Text('No completed events'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: completedEvents.length,
                    itemBuilder: (context, index) {
                      final event = completedEvents[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: EventCard(
                          event: event,
                          onReadMore: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EventDetailPage(event: event),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
