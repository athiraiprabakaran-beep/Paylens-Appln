import 'package:flutter/material.dart';

import 'analyzing_payments_screen.dart';
import 'history_screen.dart';
import 'profile_settings_screen.dart';
import 'subscription_screen.dart';
import 'upload_statement_screen.dart';

const Color payLensBlue = Color(0xFF2929C9);

class DashboardScreen extends StatefulWidget {
  final List<BankTransaction> payments;
  final String pdfFileName;
  final String pdfText;
  final String userName;
  final String userEmail;

  const DashboardScreen({
    super.key,
    this.payments = const [],
    this.pdfFileName = '',
    this.pdfText = '',
    this.userName = '',
    this.userEmail = '',
  });

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
  int selectedBottom = 0;

  // ============================================================
  // ONLY SHOW REAL SUBSCRIPTION APPS
  // ============================================================

  List<BankTransaction> get subscriptionPayments {
    return widget.payments.where((item) {
      return _isRealSubscription(item.description);
    }).toList();
  }

  bool _isRealSubscription(String description) {
    final text = description
        .toLowerCase()
        .trim();

    // Remove generic statement/header rows.
    if (text.contains('subscription transactions')) {
      return false;
    }

    if (text.contains('currency')) {
      return false;
    }

    if (text.contains('subscription transaction')) {
      return false;
    }

    if (text.contains('statement')) {
      return false;
    }

    if (text.contains('total')) {
      return false;
    }

    if (text.contains('opening balance')) {
      return false;
    }

    if (text.contains('closing balance')) {
      return false;
    }

    if (text.isEmpty) {
      return false;
    }

    // Reject rows that are only generic words.
    final cleaned = text
        .replaceAll(
      RegExp(r'\binr\b'),
      '',
    )
        .replaceAll(
      RegExp(r'\brs\.?\b'),
      '',
    )
        .replaceAll('₹', '')
        .replaceAll(
      RegExp(r'\(\s*n\s*\)'),
      '',
    )
        .replaceAll(
      RegExp(r'\bsubscription\b'),
      '',
    )
        .replaceAll(
      RegExp(r'\btransactions?\b'),
      '',
    )
        .replaceAll(
      RegExp(r'\s+'),
      ' ',
    )
        .trim();

    const genericWords = [
      'september',
      'october',
      'november',
      'december',
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'n',
    ];

    if (genericWords.contains(cleaned)) {
      return false;
    }

    return true;
  }

  // ============================================================
  // CLEAN SUBSCRIPTION NAME
  // ============================================================

  String _cleanSubscriptionName(
      String value,
      ) {
    var text = value;

    text = text.replaceAll(
      RegExp(
        r'\bCurrency\b',
        caseSensitive: false,
      ),
      '',
    );

    text = text.replaceAll(
      RegExp(
        r'\bINR\b',
        caseSensitive: false,
      ),
      '',
    );

    text = text.replaceAll(
      RegExp(
        r'\bRs\.?\b',
        caseSensitive: false,
      ),
      '',
    );

    text = text.replaceAll(
      '₹',
      '',
    );

    text = text.replaceAll(
      RegExp(
        r'\(\s*n\s*\)',
        caseSensitive: false,
      ),
      '',
    );

    text = text.replaceAll(
      RegExp(
        r'\bSubscription\s+Transactions?\b',
        caseSensitive: false,
      ),
      '',
    );

    text = text.replaceAll(
      RegExp(
        r'\bSubscription\b',
        caseSensitive: false,
      ),
      '',
    );

    text = text.replaceAll(
      RegExp(r'\s+'),
      ' ',
    );

    return text.trim();
  }

  // ============================================================
  // TOTAL
  // ============================================================

  double get totalSubscriptionSpend {
    return subscriptionPayments.fold(
      0.0,
          (sum, item) => sum + item.amount,
    );
  }

  // ============================================================
  // UPLOAD
  // ============================================================

  void openUpload() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const UploadStatementScreen(),
      ),
    );
  }

  // ============================================================
  // PROFILE
  // ============================================================

  void openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileSettingsScreen(
          payments: subscriptionPayments,
          userName: '',
          userEmail: '',
        ),
      ),
    );
  }

  // ============================================================
  // HISTORY
  // ============================================================

  void openHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const HistoryScreen(),
      ),
    );
  }

  // ============================================================
  // SUBSCRIPTIONS
  // ============================================================

  void openSubscriptions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubscriptionScreen(
          payments: subscriptionPayments,
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    final subscriptions =
        subscriptionPayments;

    return Scaffold(
      backgroundColor:
      const Color(0xFFF7F8FC),
      body: SafeArea(
        child: LayoutBuilder(
          builder:
              (context, screen) {
            final compact =
                screen.maxHeight < 650;

            return Column(
              children: [
                // ==================================================
                // MAIN CONTENT
                // ==================================================

                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Column(
                      children: [
                        // ==========================================
                        // HEADER
                        // ==========================================

                        SizedBox(
                          height:
                          compact ? 54 : 62,
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/paylens_logo.png',
                                width:
                                compact
                                    ? 31
                                    : 35,
                                height:
                                compact
                                    ? 31
                                    : 35,
                                fit:
                                BoxFit.contain,
                                errorBuilder:
                                    (
                                    context,
                                    error,
                                    stackTrace,
                                    ) {
                                  return const Icon(
                                    Icons
                                        .account_balance_wallet_rounded,
                                    color:
                                    payLensBlue,
                                    size: 30,
                                  );
                                },
                              ),

                              const SizedBox(
                                width: 6,
                              ),

                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Pay',
                                      style:
                                      TextStyle(
                                        color:
                                        Colors.black,
                                        fontSize:
                                        compact
                                            ? 22
                                            : 25,
                                        fontWeight:
                                        FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Lens',
                                      style:
                                      TextStyle(
                                        color:
                                        payLensBlue,
                                        fontSize:
                                        compact
                                            ? 22
                                            : 25,
                                        fontWeight:
                                        FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Spacer(),

                              // ======================================
                              // TOP PROFILE BUTTON
                              // ======================================

                              GestureDetector(
                                onTap:
                                openProfile,
                                behavior:
                                HitTestBehavior
                                    .opaque,
                                child:
                                Container(
                                  width:
                                  compact
                                      ? 38
                                      : 42,
                                  height:
                                  compact
                                      ? 38
                                      : 42,
                                  decoration:
                                  const BoxDecoration(
                                    color:
                                    Color(
                                      0xFFEDEDFF,
                                    ),
                                    shape:
                                    BoxShape
                                        .circle,
                                  ),
                                  child:
                                  const Icon(
                                    Icons
                                        .person_outline_rounded,
                                    color:
                                    payLensBlue,
                                    size: 21,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ==========================================
                        // SPEND CARD
                        // ==========================================

                        Container(
                          width:
                          double.infinity,
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration:
                          BoxDecoration(
                            color:
                            payLensBlue,
                            borderRadius:
                            BorderRadius
                                .circular(
                              17,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    const Text(
                                      'Your subscription spend',
                                      style:
                                      TextStyle(
                                        color:
                                        Colors
                                            .white70,
                                        fontSize:
                                        12,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 3,
                                    ),

                                    Text(
                                      '₹${totalSubscriptionSpend.toStringAsFixed(2)}',
                                      style:
                                      const TextStyle(
                                        color:
                                        Colors.white,
                                        fontSize: 26,
                                        fontWeight:
                                        FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 2,
                                    ),

                                    Text(
                                      '${subscriptions.length} subscription${subscriptions.length == 1 ? '' : 's'} detected',
                                      style:
                                      const TextStyle(
                                        color:
                                        Colors
                                            .white70,
                                        fontSize:
                                        10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                width: 44,
                                height: 44,
                                decoration:
                                BoxDecoration(
                                  color: Colors
                                      .white
                                      .withValues(
                                    alpha: 0.15,
                                  ),
                                  shape:
                                  BoxShape
                                      .circle,
                                ),
                                child:
                                const Icon(
                                  Icons
                                      .subscriptions_rounded,
                                  color:
                                  Colors.white,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ==========================================
                        // FILE NAME
                        // ==========================================

                        if (widget
                            .pdfFileName
                            .isNotEmpty)
                          SizedBox(
                            height: 26,
                            child: Align(
                              alignment:
                              Alignment
                                  .centerLeft,
                              child: Text(
                                'Analyzed: ${widget.pdfFileName}',
                                maxLines: 1,
                                overflow:
                                TextOverflow
                                    .ellipsis,
                                style:
                                const TextStyle(
                                  color:
                                  Color(
                                    0xFF888888,
                                  ),
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ),

                        // ==========================================
                        // SUBSCRIPTIONS TITLE
                        // ==========================================

                        SizedBox(
                          height:
                          compact ? 34 : 38,
                          child: Row(
                            children: [
                              const Icon(
                                Icons
                                    .subscriptions_rounded,
                                color:
                                payLensBlue,
                                size: 21,
                              ),

                              const SizedBox(
                                width: 7,
                              ),

                              const Text(
                                'Subscriptions',
                                style:
                                TextStyle(
                                  color:
                                  Colors.black,
                                  fontSize: 19,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),

                              const SizedBox(
                                width: 7,
                              ),

                              Container(
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration:
                                BoxDecoration(
                                  color:
                                  const Color(
                                    0xFFEDEEFF,
                                  ),
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    20,
                                  ),
                                ),
                                child:
                                Text(
                                  '${subscriptions.length}',
                                  style:
                                  const TextStyle(
                                    color:
                                    payLensBlue,
                                    fontSize:
                                    10,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ==========================================
                        // SUBSCRIPTION LIST
                        // ==========================================

                        Expanded(
                          child:
                          LayoutBuilder(
                            builder:
                                (
                                context,
                                box,
                                ) {
                              return _subscriptionSection(
                                box.maxHeight,
                                subscriptions,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ==================================================
                // BOTTOM BAR + PLUS BUTTON
                // ==================================================

                SizedBox(
                  height: 110,
                  child: Stack(
                    clipBehavior:
                    Clip.none,
                    children: [
                      // ==========================================
                      // BOTTOM NAVIGATION BAR
                      // ==========================================

                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 50,
                          decoration:
                          const BoxDecoration(
                            color:
                            Colors.white,
                            border:
                            Border(
                              top:
                              BorderSide(
                                color:
                                Color(
                                  0xFFE2E2E2,
                                ),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              _bottomItem(
                                Icons
                                    .home_rounded,
                                'Home',
                                0,
                              ),

                              _bottomItem(
                                Icons
                                    .subscriptions_rounded,
                                'Subscriptions',
                                1,
                              ),

                              // SPACE FOR PLUS
                              const Expanded(
                                child:
                                SizedBox(),
                              ),

                              _bottomItem(
                                Icons
                                    .history_rounded,
                                'History',
                                2,
                              ),

                              _bottomItem(
                                Icons
                                    .person_outline_rounded,
                                'Profile',
                                3,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ==========================================
                      // PLUS BUTTON
                      // ==========================================

                      Positioned(
                        right: 28,
                        bottom: 54,
                        child:
                        GestureDetector(
                          onTap: () {
                            Navigator.of(
                              context,
                            ).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                const UploadStatementScreen(),
                              ),
                            );
                          },
                          behavior:
                          HitTestBehavior
                              .opaque,
                          child:
                          Container(
                            width: 56,
                            height: 56,
                            padding:
                            const EdgeInsets
                                .all(3),
                            decoration:
                            const BoxDecoration(
                              color:
                              Colors.white,
                              shape:
                              BoxShape
                                  .circle,
                            ),
                            child:
                            Container(
                              decoration:
                              const BoxDecoration(
                                color:
                                payLensBlue,
                                shape:
                                BoxShape
                                    .circle,
                              ),
                              child:
                              const Center(
                                child:
                                Icon(
                                  Icons.add,
                                  color:
                                  Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ================================================================
  // SUBSCRIPTION SECTION
  // ================================================================

  Widget _subscriptionSection(
      double availableHeight,
      List<BankTransaction>
      subscriptions,
      ) {
    if (subscriptions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              Icons
                  .subscriptions_outlined,
              color:
              Color(0xFF999999),
              size: 42,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'No subscriptions found',
              style:
              TextStyle(
                color:
                Color(0xFF777777),
                fontSize: 14,
                fontWeight:
                FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    const cardHeight = 58.0;
    const gap = 5.0;
    const moreHeight = 24.0;

    int count =
    ((availableHeight -
        moreHeight) /
        (cardHeight + gap))
        .floor();

    if (count < 1) {
      count = 1;
    }

    if (count >
        subscriptions.length) {
      count =
          subscriptions.length;
    }

    final visible =
    subscriptions
        .take(count)
        .toList();

    final remaining =
        subscriptions.length -
            visible.length;

    return Column(
      children: [
        for (final item in visible)
          _subscriptionCard(item),

        const Spacer(),

        if (remaining > 0)
          SizedBox(
            height: moreHeight,
            child:
            GestureDetector(
              onTap:
              openSubscriptions,
              child:
              const Center(
                child: Text(
                  'More subscriptions',
                  style:
                  TextStyle(
                    color:
                    payLensBlue,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ================================================================
  // SUBSCRIPTION CARD
  // ================================================================

  Widget _subscriptionCard(
      BankTransaction item,
      ) {
    final name =
    _cleanSubscriptionName(
      item.description,
    );

    return Container(
      width:
      double.infinity,
      height: 58,
      margin:
      const EdgeInsets.only(
        bottom: 5,
      ),
      padding:
      const EdgeInsets
          .symmetric(
        horizontal: 10,
      ),
      decoration:
      BoxDecoration(
        color:
        Colors.white,
        borderRadius:
        BorderRadius
            .circular(
          12,
        ),
        border:
        Border.all(
          color:
          const Color(
            0xFFE0E2EA,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration:
            const BoxDecoration(
              color:
              Color(0xFFEEEEFF),
              shape:
              BoxShape.circle,
            ),
            child:
            const Icon(
              Icons
                  .subscriptions_rounded,
              color:
              payLensBlue,
              size: 20,
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment
                  .center,
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  name.isEmpty
                      ? 'Subscription'
                      : name,
                  maxLines: 1,
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style:
                  const TextStyle(
                    color:
                    Colors.black,
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  'Detected from ${item.date}',
                  maxLines: 1,
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style:
                  const TextStyle(
                    color:
                    Color(
                      0xFF999999,
                    ),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 6,
          ),

          Text(
            '₹${item.amount.toStringAsFixed(2)}',
            style:
            const TextStyle(
              color:
              Colors.black,
              fontSize: 12,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // BOTTOM NAV
  // ================================================================

  Widget _bottomItem(
      IconData icon,
      String label,
      int index,
      ) {
    final selected =
        selectedBottom == index;

    return Expanded(
      child:
      GestureDetector(
        behavior:
        HitTestBehavior
            .opaque,
        onTap: () {
          if (index == 1) {
            openSubscriptions();
            return;
          }

          if (index == 2) {
            openHistory();
            return;
          }

          if (index == 3) {
            openProfile();
            return;
          }

          setState(() {
            selectedBottom =
            0;
          });
        },
        child:
        SizedBox(
          height: 50,
          child:
          Column(
            mainAxisAlignment:
            MainAxisAlignment
                .center,
            children: [
              Icon(
                icon,
                size: 20,
                color: selected
                    ? payLensBlue
                    : const Color(
                  0xFF999999,
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Text(
                label,
                style:
                TextStyle(
                  fontSize: 9,
                  color: selected
                      ? payLensBlue
                      : const Color(
                    0xFF999999,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}