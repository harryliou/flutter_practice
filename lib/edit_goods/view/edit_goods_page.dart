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
                const _CapacityField(),
                const _UnitPriceField(),
                const _QuantityField(),
                if (isNewGoods)
                  const SizedBox()
                else
                  const _SoldQuantityField(),
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

class _CapacityField extends StatelessWidget {
  const _CapacityField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditGoodsBloc>().state;

    return TextFormField(
      key: const Key('editGoodsForm_capacityInput_textField'),
      keyboardType: TextInputType.number,
      initialValue: (state.initialGoods?.capacity ?? 0).toString(),
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: '設定容量',
      ),
      maxLength: 25,
      inputFormatters: [
        LengthLimitingTextInputFormatter(25),
        FilteringTextInputFormatter.allow(RegExp(r'[Z0-9\s]')),
      ],
      onChanged: (value) {
        if (value == '') {
          value = '0';
        }
        context.read<EditGoodsBloc>().add(
              EditGoodsCapacityChanged(int.parse(value)),
            );
      },
    );
  }
}

class _UnitPriceField extends StatelessWidget {
  const _UnitPriceField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditGoodsBloc>().state;

    return TextFormField(
      key: const Key('editGoodsForm_unitPriceInput_textField'),
      keyboardType: TextInputType.number,
      initialValue: (state.initialGoods?.unitPrice ?? 0).toString(),
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: '設定單價',
      ),
      maxLength: 25,
      inputFormatters: [
        LengthLimitingTextInputFormatter(25),
        FilteringTextInputFormatter.allow(RegExp(r'[Z0-9\s]')),
      ],
      onChanged: (value) {
        if (value == '') {
          value = '0';
        }
        context.read<EditGoodsBloc>().add(
              EditGoodsUnitPriceChanged(int.parse(value)),
            );
      },
    );
  }
}

class _QuantityField extends StatelessWidget {
  const _QuantityField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditGoodsBloc>().state;

    return TextFormField(
      key: const Key('editGoodsForm_quantityInput_textField'),
      keyboardType: TextInputType.number,
      initialValue: (state.initialGoods?.quantity ?? 0).toString(),
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: '設定進貨數量',
      ),
      maxLength: 25,
      inputFormatters: [
        LengthLimitingTextInputFormatter(25),
        FilteringTextInputFormatter.allow(RegExp(r'[Z0-9\s]')),
      ],
      onChanged: (value) {
        if (value == '') {
          value = '0';
        }
        context.read<EditGoodsBloc>().add(
              EditGoodsQuantityChanged(int.parse(value)),
            );
      },
    );
  }
}

class _SoldQuantityField extends StatelessWidget {
  const _SoldQuantityField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditGoodsBloc>().state;

    return TextFormField(
      key: const Key('editGoodsForm_soldQuantityInput_textField'),
      keyboardType: TextInputType.number,
      initialValue: (state.initialGoods?.soldQuantity ?? 0).toString(),
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: '設定已售出數量',
      ),
      maxLength: 25,
      inputFormatters: [
        LengthLimitingTextInputFormatter(25),
        FilteringTextInputFormatter.allow(RegExp(r'[Z0-9\s]')),
      ],
      onChanged: (value) {
        if (value == '') {
          value = '0';
        }
        context.read<EditGoodsBloc>().add(
              EditGoodsSoldQuantityChanged(int.parse(value)),
            );
      },
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
