import 'package:equatable/equatable.dart';
import 'package:my_flutter_app/domain/entities/booking.dart';

abstract class BookingState extends Equatable {
  const BookingState();
  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<Booking> bookings;
  const BookingLoaded(this.bookings);
  @override
  List<Object?> get props => [bookings];
}

class BookingSuccess extends BookingState {
  final Booking booking;
  const BookingSuccess(this.booking);
  @override
  List<Object?> get props => [booking];
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);
  @override
  List<Object?> get props => [message];
}
