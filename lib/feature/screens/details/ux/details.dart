import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:little_light_v01/core/constants/image_constants.dart';
import 'package:little_light_v01/core/widgets/custom_progress_bar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../../core/widgets/category_item.dart';
import '../../../../core/widgets/llc_app_bar.dart';
import '../../../../core/widgets/mobx/progress_store.dart';
import '../../home/ux/home.dart';
import '../mobx/campaign_store.dart';

class CampaignDetailsScreen extends StatefulWidget {
  final String campaignTitle;
  final String organization;
  final String target;
  final String imagePath;
  final double raisedSoFar;

  const CampaignDetailsScreen({
    super.key,
    required this.campaignTitle,
    required this.organization,
    required this.target,
    required this.imagePath,
    required this.raisedSoFar,
  });
  @override
  State<CampaignDetailsScreen> createState() => _CampaignDetailsScreenState();
}

class _CampaignDetailsScreenState extends State<CampaignDetailsScreen> {
  final CampaignStore _campaignStore = CampaignStore();

  final ProgressStore _store = ProgressStore();

  final String _campaign =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum. "
      "Praesent facilisis diam sit amet massa convallis, a condimentum nunc vehicula. "
      "Curabitur vehicula dui et neque volutpat, sit amet aliquam augue vestibulum. "
      "Sed ac consectetur ante. Morbi at odio at nisi dictum faucibus. Integer ac ipsum nec odio "
      "imperdiet fermentum et ac nunc. Sed nec tempor risus. Nam id mauris non sapien scelerisque "
      "mollis. Vivamus id sem id metus volutpat efficitur.";

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    final double targetValue =
    double.parse(widget.target.replaceAll('\$', '').replaceAll(',', ''));
    double progress = widget.raisedSoFar / targetValue;
    _store.updateProgress(progress);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: const LLCCustomAppBar(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Observer(
              builder: (_) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            blurRadius: 5,
                            offset: const Offset(-1, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          widget.imagePath,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.campaignTitle,
                      style: GoogleFonts.girassol(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              LLCImageConstant.check,
                              height: 20,
                              width: 20,
                              color: const Color(0xFFB2D659),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.organization,
                              style: GoogleFonts.girassol(
                                fontSize: 14,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${_campaignStore.daysLeft} days left',
                          style: GoogleFonts.girassol(
                            fontSize: 14,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomProgressBar(store: _store),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Raised so far',
                          style: GoogleFonts.girassol(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Target ${widget.target}',
                          style: GoogleFonts.girassol(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '\$${widget.raisedSoFar.toStringAsFixed(2)} ',
                                style: GoogleFonts.girassol(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors
                                      .black, // Color for raisedSoFar text
                                ),
                              ),
                              TextSpan(
                                text:
                                ' (${(_store.progressValue * 100).toStringAsFixed(0)}%)',
                                style: GoogleFonts.girassol(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0XFF8dacae),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          widget.target,
                          style: GoogleFonts.girassol(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(color: Colors.black),
                    const SizedBox(height: 14),
                    Text(
                      'About Campaign',
                      style: GoogleFonts.girassol(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildCampaignReadMore(desc: _campaign),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Observer(
                            builder: (_) => CampaignDetailsCategoryItem(
                              title: 'Gaza',
                              icon: Icons.location_on_rounded,
                              isSelected: _campaignStore.selectedIndex == 0,
                              onTap: () => _campaignStore.selectCategory(0),
                            ),
                          ),
                          Observer(
                            builder: (_) => CampaignDetailsCategoryItem(
                              title: 'Kids',
                              icon: Icons.people_alt_rounded,
                              isSelected: _campaignStore.selectedIndex == 1,
                              onTap: () => _campaignStore.selectCategory(1),
                            ),
                          ),
                          Observer(
                            builder: (_) => CampaignDetailsCategoryItem(
                              title: 'Education',
                              icon: Icons.school,
                              isSelected: _campaignStore.selectedIndex == 2,
                              onTap: () => _campaignStore.selectCategory(2),
                            ),
                          ),
                          Observer(
                            builder: (_) => CampaignDetailsCategoryItem(
                              title: 'Donation',
                              icon: Icons.volunteer_activism,
                              isSelected: _campaignStore.selectedIndex == 3,
                              onTap: () => _campaignStore.selectCategory(3),
                            ),
                          ),
                          Observer(
                            builder: (_) => CampaignDetailsCategoryItem(
                              title: 'Medical',
                              icon: Icons.local_hospital,
                              isSelected: _campaignStore.selectedIndex == 3,
                              onTap: () => _campaignStore.selectCategory(3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: _donateCampaign(context)),
    );
  }

  Widget _donateCampaign(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFF9bab7c),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFb3d77d),
          padding: const EdgeInsets.all(16),
          side: const BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Donate To Campaign',
          style: GoogleFonts.girassol(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    ),
  );

  Widget _buildCampaignReadMore({required String desc}) {
    const int textLimit = 110;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _campaignStore.isExpanded
              ? desc
              : '${desc.substring(0, textLimit)}...',
          style: GoogleFonts.girassol(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: () => _campaignStore.toggleReadMore(),
          child: Text(
            _campaignStore.isExpanded ? 'Read Less' : 'Read More',
            style: GoogleFonts.girassol(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0XFFb3d5d6),
            ),
          ),
        ),
      ],
    );
  }

  void _openCheckout() {
    var options = {
      'key': 'your_key_id',
      'amount': 5000,
      'name': widget.campaignTitle,
      'description': 'Donation for ${widget.campaignTitle}',
      'prefill': {
        'contact': '07549452267',
        'email': 'soumya01@email.com'
      },
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _showDialog(
        context, 'Payment Successful', 'Thank you for your donation!');
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _showDialog(context, 'Payment Failed',
        'Your payment was unsuccessful. Please try again.');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet if needed
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title,
            style: GoogleFonts.girassol(
                fontSize: 14, fontWeight: FontWeight.w600)),
        content: Text(content,
            style: GoogleFonts.girassol(
                fontSize: 12, fontWeight: FontWeight.w400)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK',
                style: GoogleFonts.girassol(
                    fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

