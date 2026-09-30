import 'package:example/src/core/utils/extensions/textstyle_ext.dart';
import 'package:flutter/material.dart';

class SnackbarNotifier {
  BuildContext context;
  SnackbarNotifier({required this.context});

  EdgeInsets _snackBarMargin(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontal = screenWidth > 700 ? (screenWidth - 700) / 2 : 16.0;
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: 12);
  }

  notifySuccess({String? message}) {
    if (context.mounted && context.owner != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message ?? "Success",
            maxLines: 3,
            style: TextStyle(color: Colors.white).bold.regular,
          ),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
          margin: _snackBarMargin(context),
        ),
      );
    }
  }

  notify({String? message, double fontSize = 16}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message ?? "",
          maxLines: 3,
          style: TextStyle(color: Colors.white, fontSize: fontSize).bold,
        ),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        margin: _snackBarMargin(context),
      ),
    );
  }

  notifyError({String? message}) {
    if (context.mounted && context.owner != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message ?? "Error",
            maxLines: 3,
            style: TextStyle(color: Colors.white).bold.regular,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          showCloseIcon: true,
          margin: _snackBarMargin(context),
        ),
      );
    }
  }
}

// class _AnimatedSnackbar extends StatefulWidget {
//   final NotificationType type;
//   final String message;
//   final Color backgroundColor;

//   const _AnimatedSnackbar({
//     super.key,
//     required this.message,
//     required this.backgroundColor, required this.type,
//   });

//   @override
//   State<_AnimatedSnackbar> createState() => _AnimatedSnackbarState();
// }

// class _AnimatedSnackbarState extends State<_AnimatedSnackbar> with SingleTickerProviderStateMixin {
//   Offset offset = const Offset(0, -2);

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       setState(() => offset = Offset.zero);
//     });
//   }

//   Future<void> hide() async {
//     setState(() => offset = const Offset(0, -2));
//     await Future.delayed(const Duration(milliseconds: 300));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: MediaQuery.of(context).padding.top + 10,
//       left: 16,
//       right: 16,
//       child:AnimatedSlide(
//         offset: offset,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(16),
//           child: Material(
//             color: Colors.transparent,
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
//               child: Container(
//                 constraints: BoxConstraints(minHeight: 70, maxWidth: MediaQuery.of(context).size.width),
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withAlpha(50), // Blackish glass effect
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(
//                     color: Colors.white.withAlpha(20), // subtle border for shine
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   spacing: 8,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: AppSizes.smallBorderRadius
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(2.0),
//                           child: Icon(widget.type.icon, color: AppColors.context(context).primaryColor, size: AppSizes.largeIconSize,),
//                         )),
//                     ),
//                     Flexible(
//                       child: Column(
//                         spacing: 4,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(widget.type.label, style: TextStyle(color: Colors.white).bold.h5,),
//                           Text(
//                             widget.message,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               shadows: [
//                                 Shadow(
//                                   blurRadius: 4,
//                                   color: Colors.black26,
//                                   offset: Offset(0, 1),
//                                 )
//                               ],
//                             ).h6.w600,
//                           ),

//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
