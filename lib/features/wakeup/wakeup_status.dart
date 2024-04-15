import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/common/dart/extension/context_extension.dart';

class WakeUpStatus extends StatelessWidget {
  final String wakeUpStatusMessage;
  const WakeUpStatus(this.wakeUpStatusMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5, offset: const Offset(4, 4))]),
      child: Column(
        children: [
          SizedBox(
            width: context.deviceWidth * 0.7,
            child: Text(
              wakeUpStatusMessage,
              style: const TextStyle(
                fontSize: 16,
                // fontFamily: GoogleFonts.anticSlab().fontFamily,
              ),
            ).p(10),
          ),
          // Row(
          //   children: [
          //     Text(
          //       "와우",
          //       style: TextStyle(
          //         fontSize: 40,
          //         fontFamily: GoogleFonts.nanumBrushScript().fontFamily,
          //       ),
          //     ).p(10),
          //     Text(
          //       "와우",
          //       style: TextStyle(
          //         fontSize: 40,
          //         fontFamily: GoogleFonts.nanumGothic().fontFamily,
          //       ),
          //     ).p(10),
          //     Text(
          //       "와우",
          //       style: TextStyle(
          //         fontSize: 40,
          //         fontFamily: GoogleFonts.gothicA1().fontFamily,
          //       ),
          //     ).p(10),
          //     const Text(
          //       "와우",
          //       style: TextStyle(
          //         fontSize: 40,
          //         // fontFamily: GoogleFonts.nanumGothic().fontFamily,
          //       ),
          //     ).p(10),
          //   ],
          // ),
          // Text(
          //   "Wake !@#와우Español你好 \nよく眠れた？",
          //   style: TextStyle(
          //     fontSize: 40,
          //     fontFamily: GoogleFonts.gothicA1().fontFamily,
          //   ),
          // ).p(10),
          // const Text(
          //   "Wake !@#와우Español你好 \nよく眠れた？",
          //   style: TextStyle(
          //     fontSize: 40,
          //     // fontFamily: GoogleFonts.notoMusic().fontFamily,
          //   ),
          // ).p(10),
        ],
      ),
    ).pSymmetric(h: 10, v: 10);
  }
}
