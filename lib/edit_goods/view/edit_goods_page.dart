import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store/edit_goods/edit_goods.dart';
import 'package:goods_repository/goods_repository.dart';

class EditGoodsPage extends StatelessWidget {
  const EditGoodsPage({super.key});

  static Route<void> route({Goods? initialGoods}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => EditGoodsBloc(
          goodsRepository: context.read<GoodsRepository>(),
          initialGoods: initialGoods,
        ),
        child: const EditGoodsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditGoodsBloc, EditGoodsState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditGoodsStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const EditGoodsView(),
    );
  }
}

class EditGoodsView extends StatelessWidget {
  const EditGoodsView({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((EditGoodsBloc bloc) => bloc.state.status);
    final isNewGoods = context.select(
      (EditGoodsBloc bloc) => bloc.state.isNewGoods,
    );
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewGoods ? '新增精油' : '編輯精油',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        backgroundColor: status.isLoadingOrSuccess
            ? fabBackgroundColor.withOpacity(0.5)
            : fabBackgroundColor,
        onPressed: status.isLoadingOrSuccess
            ? null
            : () =>
                context.read<EditGoodsBloc>().add(const EditGoodsSubmitted()),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const _NameField(),
                _CapacityField(),
                _UnitPriceField(),
                _QuantityField(),
                if (isNewGoods) const SizedBox() else _SoldQuantityField(),
                _PurchaseDateField(),
                _ExpirationDateField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditGoodsBloc>().state;
    final hintText = state.initialGoods?.name ?? '';

    return TextFormField(
      key: const Key('editGoodsForm_nameInput_textField'),
      initialValue: state.name,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: '名稱',
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        // FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onChanged: (value) {
        context.read<EditGoodsBloc>().add(EditGoodsNameChanged(value));
      },
    );
  }
}

class _CapacityField extends StatefulWidget {
  @override
  _CapacityFieldState createState() => _CapacityFieldState();
}

class _CapacityFieldState extends State<_CapacityField> {
  late int _selectedCapacity;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final editGoodsBloc = context.watch<EditGoodsBloc>();
    final state = editGoodsBloc.state;
    if (!_initialized) {
      _selectedCapacity = state.initialGoods?.capacity ?? 0;
      _initialized = true;
    }

    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            showModalBottomSheet<Widget>(
              context: context,
              builder: (context) {
                return SizedBox(
                  height: 200,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: _selectedCapacity,
                    ),
                    itemExtent: 32,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedCapacity = index;
                        editGoodsBloc.add(EditGoodsCapacityChanged(index * 10));
                      });
                    },
                    children: List.generate(
                      500,
                      (index) => Text(
                        (index * 10).toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: const Text('設定容量'),
        ),
        const SizedBox(width: 20),
        Text((_selectedCapacity * 10).toString()),
      ],
    );
  }
}

class _UnitPriceField extends StatefulWidget {
  @override
  _UnitPriceFieldState createState() => _UnitPriceFieldState();
}

class _UnitPriceFieldState extends State<_UnitPriceField> {
  late int _selectedUnitPrice;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final editGoodsBloc = context.watch<EditGoodsBloc>();
    final state = editGoodsBloc.state;
    if (!_initialized) {
      _selectedUnitPrice = state.initialGoods?.unitPrice ?? 0;
      _initialized = true;
    }

    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            showModalBottomSheet<Widget>(
              context: context,
              builder: (context) {
                return SizedBox(
                  height: 200,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: _selectedUnitPrice,
                    ),
                    itemExtent: 32,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedUnitPrice = index;
                        editGoodsBloc.add(EditGoodsUnitPriceChanged(index));
                      });
                    },
                    children: List.generate(
                      3000,
                      (index) => Text(
                        index.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: const Text('設定單價'),
        ),
        const SizedBox(width: 20),
        Text(_selectedUnitPrice.toString()),
      ],
    );
  }
}

class _QuantityField extends StatefulWidget {
  @override
  _QuantityFieldState createState() => _QuantityFieldState();
}

class _QuantityFieldState extends State<_QuantityField> {
  late int _selectedQuantity;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final editGoodsBloc = context.watch<EditGoodsBloc>();
    final state = editGoodsBloc.state;
    if (!_initialized) {
      _selectedQuantity = state.initialGoods?.quantity ?? 0;
      _initialized = true;
    }

    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            showModalBottomSheet<Widget>(
              context: context,
              builder: (context) {
                return SizedBox(
                  height: 200,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: _selectedQuantity,
                    ),
                    itemExtent: 32,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedQuantity = index;
                        editGoodsBloc.add(EditGoodsQuantityChanged(index));
                      });
                    },
                    children: List.generate(
                      500,
                      (index) => Text(
                        index.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: const Text('設定數量'),
        ),
        const SizedBox(width: 20),
        Text(_selectedQuantity.toString()),
      ],
    );
  }
}

class _SoldQuantityField extends StatefulWidget {
  @override
  _SoldQuantityFieldState createState() => _SoldQuantityFieldState();
}

class _SoldQuantityFieldState extends State<_SoldQuantityField> {
  late int _selectedSoldQuantity;
  late int _setQuantity;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final editGoodsBloc = context.watch<EditGoodsBloc>();
    final state = editGoodsBloc.state;
    if (!_initialized) {
      _selectedSoldQuantity = state.initialGoods?.soldQuantity ?? 0;
      _setQuantity = state.initialGoods?.quantity ?? 0;
      _initialized = true;
    }

    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            showModalBottomSheet<Widget>(
              context: context,
              builder: (context) {
                return SizedBox(
                  height: 200,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: _selectedSoldQuantity,
                    ),
                    itemExtent: 32,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedSoldQuantity = index;
                        editGoodsBloc.add(EditGoodsSoldQuantityChanged(index));
                      });
                    },
                    children: List.generate(
                      _setQuantity + 1,
                      (index) => Text(
                        index.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: const Text('設定已售出數量'),
        ),
        const SizedBox(width: 20),
        Text(_selectedSoldQuantity.toString()),
      ],
    );
  }
}

class _ExpirationDateField extends StatefulWidget {
  @override
  _ExpirationDateFieldState createState() => _ExpirationDateFieldState();
}

class _ExpirationDateFieldState extends State<_ExpirationDateField> {
  late DateTime _selectedDate;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditGoodsBloc>().state;
    if (!_initialized) {
      _selectedDate = state.initialGoods?.expirationDate ?? DateTime.now();
      _initialized = true;
    }

    void dateSelected(DateTime? date) {
      setState(() {
        _selectedDate = date ?? _selectedDate;
        context
            .read<EditGoodsBloc>()
            .add(EditGoodsExpirationDateChanged(_selectedDate));
      });
    }

    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              locale: const Locale('zh', 'TW'),
            ).then(dateSelected);
          },
          child: const Text('設定過期日期'),
        ),
        const SizedBox(width: 20),
        Text('${_selectedDate.toLocal()}'.split(' ')[0]),
      ],
    );
  }
}

class _PurchaseDateField extends StatefulWidget {
  @override
  _PurchaseDateFieldState createState() => _PurchaseDateFieldState();
}

class _PurchaseDateFieldState extends State<_PurchaseDateField> {
  late DateTime _selectedDate;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditGoodsBloc>().state;
    if (!_initialized) {
      _selectedDate = state.initialGoods?.purchaseDate ?? DateTime.now();
      _initialized = true;
    }

    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              locale: const Locale('zh', 'TW'),
            ).then((date) {
              setState(() {
                _selectedDate = date ?? _selectedDate;
                context
                    .read<EditGoodsBloc>()
                    .add(EditGoodsPurchaseDateChanged(_selectedDate));
              });
            });
          },
          child: const Text('設定進貨日期'),
        ),
        const SizedBox(width: 20),
        Text('${_selectedDate.toLocal()}'.split(' ')[0]),
      ],
    );
  }
}
