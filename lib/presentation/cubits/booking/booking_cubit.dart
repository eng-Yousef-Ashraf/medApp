import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/domain/entities/booking.dart';
import 'package:my_flutter_app/domain/usecases/booking_usecases.dart';
import 'package:my_flutter_app/presentation/cubits/booking/booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final CreateBookingUseCase createBookingUseCase;
  final GetBookingsUseCase getBookingsUseCase;
  final CancelBookingUseCase cancelBookingUseCase;

  BookingCubit({
    required this.createBookingUseCase,
    required this.getBookingsUseCase,
    required this.cancelBookingUseCase,
  }) : super(BookingInitial());

  Future<void> createBooking(Booking booking) async {
    emit(BookingLoading());
    try {
      final confirmed = await createBookingUseCase(booking);
      emit(BookingSuccess(confirmed));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> loadBookings() async {
    emit(BookingLoading());
    try {
      final bookings = await getBookingsUseCase();
      emit(BookingLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> cancelBooking(String id) async {
    emit(BookingLoading());
    try {
      await cancelBookingUseCase(id);
      final bookings = await getBookingsUseCase();
      emit(BookingLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
