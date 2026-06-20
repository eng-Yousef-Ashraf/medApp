import 'package:my_flutter_app/domain/entities/booking.dart';

abstract class BookingRepository {
  Future<Booking> createBooking(Booking booking);
  Future<List<Booking>> getBookings();
  Future<void> cancelBooking(String id);
}
