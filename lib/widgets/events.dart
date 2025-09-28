import 'package:mns_app/pages/home/components/event_cards.dart';

final List<Event> events = [
  // --- Upcoming Events (10) ---
  Event(
    id: 'ganesh-chaturthi-2025',
    title: 'Ganesh Chaturthi Festival',
    description: 'Grand Ganesh Utsav celebrations with cultural programs.',
    dateTime: DateTime(2025, 9, 22, 18, 0),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Lalbaug, Mumbai',
  ),
  Event(
    id: 'navratri-2025',
    title: 'Navratri Garba Night',
    description: 'Dance, music, and devotion during Navratri.',
    dateTime: DateTime(2025, 10, 5, 19, 0),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Thane, Maharashtra',
  ),
  Event(
    id: 'diwali-2025',
    title: 'Diwali Celebration',
    description: 'Festival of lights celebrated with cultural programs.',
    dateTime: DateTime(2025, 10, 29, 18, 30),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Shivaji Park, Mumbai',
  ),
  Event(
    id: 'shivaji-jayanti-2026',
    title: 'Shivaji Jayanti',
    description:
        'Commemoration of Chhatrapati Shivaji Maharaj’s birth anniversary.',
    dateTime: DateTime(2026, 2, 19, 9, 0),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Raigad Fort, Maharashtra',
  ),
  Event(
    id: 'gudhi-padwa-2026',
    title: 'Gudhi Padwa Celebration',
    description: 'Celebrate Marathi New Year with a grand procession.',
    dateTime: DateTime(2026, 3, 22, 10, 0),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Shivaji Park, Mumbai',
  ),
  Event(
    id: 'maharashtra-day-2026',
    title: 'Maharashtra Day Parade',
    description: 'Celebrating the formation of Maharashtra state.',
    dateTime: DateTime(2026, 5, 1, 8, 0),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Mantralaya, Mumbai',
  ),
  Event(
    id: 'independence-day-2026',
    title: 'Independence Day Parade',
    description: 'Flag hoisting ceremony and cultural performances.',
    dateTime: DateTime(2026, 8, 15, 8, 30),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Gateway of India, Mumbai',
  ),
  Event(
    id: 'dussehra-2026',
    title: 'Dussehra Rally',
    description: 'Grand rally marking the victory of good over evil.',
    dateTime: DateTime(2026, 10, 20, 17, 0),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Shivaji Park, Mumbai',
  ),
  Event(
    id: 'diwali-2026',
    title: 'Diwali Cultural Festival',
    description: 'Lighting diyas, rangoli competitions, and fireworks.',
    dateTime: DateTime(2026, 11, 7, 18, 0),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Pune, Maharashtra',
  ),
  Event(
    id: 'republic-day-2027',
    title: 'Republic Day Celebration',
    description: 'Parade, speeches, and flag hoisting.',
    dateTime: DateTime(2027, 1, 26, 9, 0),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Marine Drive, Mumbai',
  ),

  // --- Completed Events (10) ---
  Event(
    id: 'holi-2025',
    title: 'Holi Festival',
    description: 'Celebration of colors with music and dance.',
    dateTime: DateTime(2025, 3, 25, 10, 0),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Thane, Maharashtra',
  ),
  Event(
    id: 'maharashtra-day-2025',
    title: 'Maharashtra Day Rally',
    description: 'Flag hoisting and cultural procession.',
    dateTime: DateTime(2025, 5, 1, 8, 0),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Mantralaya, Mumbai',
  ),
  Event(
    id: 'independence-day-2025',
    title: 'Independence Day 2025',
    description: 'Flag hoisting and youth programs.',
    dateTime: DateTime(2025, 8, 15, 9, 0),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Gateway of India, Mumbai',
  ),
  Event(
    id: 'dussehra-2025',
    title: 'Dussehra Celebration',
    description: 'Victory of good over evil celebrated with rally.',
    dateTime: DateTime(2025, 10, 2, 17, 0),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Nagpur, Maharashtra',
  ),
  Event(
    id: 'shivaji-jayanti-2025',
    title: 'Shivaji Jayanti 2025',
    description: 'Honoring the legacy of Chhatrapati Shivaji Maharaj.',
    dateTime: DateTime(2025, 2, 19, 9, 0),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Raigad Fort, Maharashtra',
  ),
  Event(
    id: 'gandhi-jayanti-2024',
    title: 'Gandhi Jayanti Cleanliness Drive',
    description: 'Swachh Bharat campaign by MNS volunteers.',
    dateTime: DateTime(2024, 10, 2, 9, 0),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Dadar, Mumbai',
  ),
  Event(
    id: 'diwali-2024',
    title: 'Diwali Celebration 2024',
    description: 'Festival of lights celebrated with cultural programs.',
    dateTime: DateTime(2024, 11, 1, 18, 0),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Shivaji Park, Mumbai',
  ),
  Event(
    id: 'republic-day-2025',
    title: 'Republic Day 2025',
    description: 'Flag hoisting ceremony and parade.',
    dateTime: DateTime(2025, 1, 26, 9, 0),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Marine Drive, Mumbai',
  ),
  Event(
    id: 'new-year-2025',
    title: 'New Year Celebration 2025',
    description: 'Fireworks and cultural performances.',
    dateTime: DateTime(2025, 1, 1, 0, 0),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Mumbai, Maharashtra',
  ),
  Event(
    id: 'ganesh-chaturthi-2024',
    title: 'Ganesh Chaturthi 2024',
    description: 'Ganesh Utsav with traditional processions.',
    dateTime: DateTime(2024, 9, 7, 18, 0),
    imageUrl:
        'http://mnsadhikrut.org/wp-content/uploads/2021/07/mahamorcha-thumb.jpg',
    location: 'Lalbaug, Mumbai',
  ),
];
