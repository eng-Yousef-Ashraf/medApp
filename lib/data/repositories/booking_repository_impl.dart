import 'package:my_flutter_app/domain/entities/booking.dart';
import 'package:my_flutter_app/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final List<Booking> _bookings = [];

  @override
  Future<Booking> createBooking(Booking booking) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final confirmed = booking.copyWith(status: BookingStatus.confirmed);
    _bookings.add(confirmed);
    return confirmed;
  }

  @override
  Future<List<Booking>> getBookings() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_bookings);
  }

  @override
  Future<void> cancelBooking(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(status: BookingStatus.cancelled);
    }
  }
}
