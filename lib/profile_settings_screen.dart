import 'package:flutter/material.dart';
import 'package:project/analyzing_payments_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'audit_preferences_screen.dart';
import 'notifications_screen.dart';
import 'payment_methods_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const ProfileSettingsScreen({
    super.key,
    this.userName = '',
    this.userEmail = '', required List<BankTransaction> payments,
  });

  @override
  State<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState
    extends State<ProfileSettingsScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryBlue =
  Color(0xFF2222C8);

  static const Color pageBackground =
  Color(0xFFF7F7FB);

  static const Color borderGrey =
  Color(0xFFD0D0D0);

  // ============================================================
  // CURRENT USER DATA
  // ============================================================

  String currentUserName = '';
  String currentUserEmail = '';

  bool isLoading = true;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadCurrentUser();
  }

  // ============================================================
  // LOAD CURRENT USER
  // ============================================================

  Future<void> _loadCurrentUser() async {
    final prefs =
    await SharedPreferences.getInstance();

    final savedName =
    prefs.getString('paylens_user_name');

    final savedEmail =
    prefs.getString('paylens_user_email');

    if (!mounted) return;

    setState(() {
      currentUserName =
      (savedName != null &&
          savedName.trim().isNotEmpty)
          ? savedName.trim()
          : widget.userName.trim();

      currentUserEmail =
      (savedEmail != null &&
          savedEmail.trim().isNotEmpty)
          ? savedEmail.trim()
          : widget.userEmail.trim();

      isLoading = false;
    });
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 2,
        bottom: 6,
      ),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF777777),
        ),
      ),
    );
  }

  // ============================================================
  // SETTINGS ROW
  // ============================================================

  Widget settingsRow({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool showArrow = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 48,
          child: Row(
            children: [
              const SizedBox(width: 12),

              Icon(
                icon,
                size: 19,
                color: Colors.black87,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),

              if (showArrow)
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: Color(0xFF777777),
                ),

              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SETTINGS CARD
  // ============================================================

  Widget settingsCard({
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGrey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // ============================================================
  // PROFILE CARD
  // ============================================================

  Widget profileCard() {
    final String displayName =
    currentUserName.trim().isNotEmpty
        ? currentUserName.trim()
        : 'User';

    final String displayEmail =
    currentUserEmail.trim().isNotEmpty
        ? currentUserEmail.trim()
        : 'No email available';

    final String profileLetter =
    displayName != 'User'
        ? displayName
        .substring(0, 1)
        .toUpperCase()
        : '?';

    return Container(
      width: double.infinity,
      height: 76,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: primaryBlue,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          // ======================================================
          // PROFILE LETTER
          // ======================================================

          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFD8D3FF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                profileLetter,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                  color: primaryBlue,
                ),
              ),
            ),
          ),

          const SizedBox(width: 11),

          // ======================================================
          // USER DETAILS
          // ======================================================

          Expanded(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  displayEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 10,
                    color: Color(0xFF888888),
                  ),
                ),

                const SizedBox(height: 3),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF39A845),
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 4),

                    const Text(
                      'Account active',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 8,
                        color: Color(0xFF39A845),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NOTIFICATIONS
  // ============================================================

  void openNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const NotificationsScreen(),
      ),
    );
  }

  // ============================================================
  // PAYMENT METHODS
  // ============================================================

  void openPaymentMethods(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const PaymentMethodsScreen(),
      ),
    );
  }

  // ============================================================
  // AUDIT PREFERENCES
  // ============================================================

  void openAuditPreferences(
      BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const AuditPreferencesScreen(),
      ),
    );
  }

  // ============================================================
  // ISSUES
  // ============================================================

  void openIssues(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
              ),
              SizedBox(width: 8),
              Text('Issues'),
            ],
          ),
          content: const Text(
            'PayLens will show unusual or potentially '
                'problematic subscription activity here.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // REVIEW
  // ============================================================

  void openReview(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.star_border_rounded,
                color: Colors.amber,
              ),
              SizedBox(width: 8),
              Text('Review'),
            ],
          ),
          content: const Text(
            'Review your detected subscriptions '
                'and recurring payments here.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // UPCOMING
  // ============================================================

  void openUpcoming(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: primaryBlue,
              ),
              SizedBox(width: 8),
              Text('Upcoming'),
            ],
          ),
          content: const Text(
            'Upcoming subscription renewals and '
                'payments detected from your statements '
                'will appear here.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // SIGN OUT
  // ============================================================

  Future<void> signOut(BuildContext context) async {
    final prefs =
    await SharedPreferences.getInstance();

    // ----------------------------------------------------------
    // IMPORTANT
    // ----------------------------------------------------------

    await prefs.setBool(
      'paylens_logged_in',
      false,
    );

    // Do NOT delete user name/email here.
    //
    // Reason:
    // Login screen will overwrite these values
    // when another user logs in.
    //
    // This prevents Profile from becoming permanently
    // blank before the next login.

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (route) => false,
    );
  }

  // ============================================================
  // SIGN OUT BUTTON
  // ============================================================

  Widget signOutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: ElevatedButton(
        onPressed: () {
          signOut(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
          const Color(0xFFF4DCDC),
          foregroundColor:
          const Color(0xFFD13F3F),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(6),
          ),
        ),
        child: const Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              size: 18,
              color: Color(0xFFD13F3F),
            ),

            SizedBox(width: 7),

            Text(
              'Sign Out',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFFD13F3F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget bottomNavigation(
      BuildContext context) {
    return Container(
      height: 58,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceAround,
        children: [
          // HOME
          IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/dashboard',
                    (route) => false,
              );
            },
            icon: const Icon(
              Icons.home_outlined,
              size: 24,
              color: Color(0xFF777777),
            ),
          ),

          // UPLOAD / STATEMENT
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/upload-statement',
              );
            },
            icon: const Icon(
              Icons.receipt_long_outlined,
              size: 24,
              color: Color(0xFF777777),
            ),
          ),

          // HISTORY
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/history',
              );
            },
            icon: const Icon(
              Icons.history_rounded,
              size: 24,
              color: Color(0xFF777777),
            ),
          ),

          // PROFILE
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.person_outline_rounded,
              size: 24,
              color: primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool compact =
                constraints.maxHeight < 650;

            return Column(
              children: [
                // ==================================================
                // MAIN CONTENT
                // ==================================================

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                      compact ? 12 : 16,
                      vertical:
                      compact ? 8 : 10,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        // ==========================================
                        // TITLE
                        // ==========================================

                        Text(
                          'Profile & Settings',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize:
                            compact ? 17 : 18,
                            fontWeight:
                            FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),

                        SizedBox(
                          height:
                          compact ? 6 : 8,
                        ),

                        // ==========================================
                        // PROFILE
                        // ==========================================

                        profileCard(),

                        SizedBox(
                          height:
                          compact ? 7 : 10,
                        ),

                        // ==========================================
                        // ACCOUNT
                        // ==========================================

                        sectionTitle(
                          'Account',
                        ),

                        settingsCard(
                          children: [
                            settingsRow(
                              icon: Icons
                                  .notifications_none_rounded,
                              title:
                              'Notifications',
                              onTap: () {
                                openNotifications(
                                  context,
                                );
                              },
                            ),

                            settingsRow(
                              icon: Icons
                                  .credit_card_outlined,
                              title:
                              'Payment Methods',
                              onTap: () {
                                openPaymentMethods(
                                  context,
                                );
                              },
                            ),

                            settingsRow(
                              icon: Icons
                                  .settings_outlined,
                              title:
                              'Audit Preferences',
                              onTap: () {
                                openAuditPreferences(
                                  context,
                                );
                              },
                            ),
                          ],
                        ),

                        SizedBox(
                          height:
                          compact ? 7 : 10,
                        ),

                        // ==========================================
                        // INSIGHTS
                        // ==========================================

                        sectionTitle(
                          'Insights',
                        ),

                        settingsCard(
                          children: [
                            settingsRow(
                              icon: Icons
                                  .warning_amber_outlined,
                              title: 'Issues',
                              onTap: () {
                                openIssues(
                                  context,
                                );
                              },
                            ),

                            settingsRow(
                              icon: Icons
                                  .star_border_rounded,
                              title: 'Review',
                              onTap: () {
                                openReview(
                                  context,
                                );
                              },
                            ),

                            settingsRow(
                              icon: Icons
                                  .calendar_month_outlined,
                              title: 'Upcoming',
                              onTap: () {
                                openUpcoming(
                                  context,
                                );
                              },
                            ),
                          ],
                        ),

                        SizedBox(
                          height:
                          compact ? 14 : 20,
                        ),

                        // ==========================================
                        // SIGN OUT
                        // ==========================================

                        signOutButton(
                          context,
                        ),
                      ],
                    ),
                  ),
                ),

                // ==================================================
                // BOTTOM NAVIGATION
                // ==================================================

                bottomNavigation(
                  context,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}