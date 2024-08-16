import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../home/data/entity/product_post_model.dart';
import '../../home/data/repository/home_repository.dart';

part 'card_event.dart';

part 'card_state.dart';
// Bloc
class CardBloc extends Bloc<CardEvent, CardState> {
  CardBloc() : super(const CardState()) {
    on<GetBasketProductList>(_getData);
    on<DeleteBasketItem>(_deleteBasketItem);
  }

  Future<void> _deleteBasketItem(DeleteBasketItem event, Emitter<CardState> emit) async {
    emit(state.copyWith(cardPageState: CardPageState.loading));
    log("card bloc delete item");
    try {
      if (event.list.isNotEmpty) {
        await HomeRepository.deleteProduct(id: event.list.first.id!);
        await _getData(const GetBasketProductList(list: []), emit);
      }
    } catch (error) {
      emit(state.copyWith(cardPageState: CardPageState.error));
    }
  }

  Future<void> _getData(GetBasketProductList event, Emitter<CardState> emit) async {
    log("bloc getData");
    emit(state.copyWith(cardPageState: CardPageState.loading));
    try {
      List<ProductPostModel> result = await HomeRepository.getBasketData();
      log("Card bloc result ==> $result");
      if (result.isNotEmpty) {
        emit(state.copyWith(cardPageState: CardPageState.success, basketList: result));
        log("Card bloc result ==> success");
      } else {
        emit(state.copyWith(cardPageState: CardPageState.error, basketList: []));
      }
    } catch (error) {
      emit(state.copyWith(cardPageState: CardPageState.error, basketList: []));
    }
  }
}
