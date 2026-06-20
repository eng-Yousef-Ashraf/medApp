import 'package:my_flutter_app/domain/entities/booking.dart';
import 'package:my_flutter_app/domain/repositories/booking_repository.dart';

class CreateBookingUseCase {
  final BookingRepository repository;
  CreateBookingUseCase(this.repository);
  Future<Booking> call(Booking booking) => repository.createBooking(booking);
}

class GetBookingsUseCase {
  final BookingRepository repository;
  GetBookingsUseCase(this.repository);
  Future<List<Booking>> call() => repository.getBookings();
}

class CancelBookingUseCase {
  final BookingRepository repository;
  CancelBookingUseCase(this.repository);
  Future<void> call(String id) => repository.cancelBooking(id);
}
