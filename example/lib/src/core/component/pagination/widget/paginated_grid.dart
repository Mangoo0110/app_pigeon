
import 'package:example/src/core/utils/extensions/textstyle_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../constants/app_colors.dart';
import '../pagination.dart';

class PaginatedGridView<T> extends StatefulWidget {
  final PaginationController<T> pagination;

  /// Widget shown as skeleton cell (provided by the caller)
  final Widget skeleton;

  /// How many skeletons to show when loading / refreshing
  final int skeletonCount;

  final String emptyMessage;

  /// Caller decides how each grid item looks
  final Widget Function(int index, T data) itemBuilder;

  /// Caller decides the grid layout
  final SliverGridDelegate gridDelegate;

  /// Optional: control scroll physics
  final ScrollPhysics? physics;

  /// Optional: padding for the grid
  final EdgeInsetsGeometry? padding;

  /// Optional: if you use this inside another scroll view (like your List version),
  /// keep it non-scrollable. Default matches your List behavior.
  final bool shrinkWrap;
  final bool disableScroll;

  const PaginatedGridView({
    super.key,
    required this.pagination,
    required this.skeleton,
    required this.skeletonCount,
    required this.itemBuilder,
    required this.gridDelegate,
    this.emptyMessage = "No data found",
    this.physics,
    this.padding,
    this.shrinkWrap = true,
    this.disableScroll = true,
  });

  @override
  State<PaginatedGridView<T>> createState() => _PaginatedGridViewState<T>();
}

class _PaginatedGridViewState<T> extends State<PaginatedGridView<T>> {

  final ScrollController scrollController =ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        widget.pagination.loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: widget.pagination,
        builder: (context, _) {
          final items = widget.pagination.items.value;
          final state = widget.pagination.state.value;
      
          if (state == PaginationLoadState.nopages) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text(widget.emptyMessage)),
                IconButton(
                  onPressed: widget.pagination.refresh,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ).animate().fadeIn(duration: 300.ms);
          }
      
          
          final itemCount = items.length + 1;
      
          return CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverGrid.builder(
                // padding: widget.padding,
                // shrinkWrap: widget.shrinkWrap,
                // physics: widget.disableScroll
                //     ? const NeverScrollableScrollPhysics()
                //     : (widget.physics ?? const AlwaysScrollableScrollPhysics()),
                gridDelegate: widget.gridDelegate,
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  final isFooter = index == items.length;
              
                  // Footer: Loading/Refreshing => show skeleton tiles
                  // if (isFooter &&
                  //     (state == PaginationLoadState.loading ||
                  //         state == PaginationLoadState.refreshing)) {
                  //   return _SkeletonGrid(
                  //     skeleton: widget.skeleton,
                  //     count: widget.skeletonCount,
                  //   ).animate().fadeIn(duration: 300.ms);
                  // }
              
                  // Footer: All loaded => show "End"
                  
              
                  // Normal grid item
                  if (!isFooter) {
                    final element = items[index];
                    return widget
                        .itemBuilder(index, element)
                        .animate()
                        .slideY(
                          begin: 0.1,
                          end: 0,
                          duration: 300.ms,
                          curve: Curves.easeOutCubic,
                        )
                        .fadeIn(
                          duration: 300.ms,
                          curve: Curves.easeOutCubic,
                        );
                  }
              
                  // Footer: default empty space (when not loading / not allLoaded)
                  return const SizedBox.shrink();
                },
              ),
              SliverToBoxAdapter(
                child: ValueListenableBuilder(
                  valueListenable: widget.pagination.state, 
                  builder: (context, value, child) {
                    debugPrint("load end indication state ${value.name}");
                    if (value == PaginationLoadState.allLoaded) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "End of the page",
                            style: const TextStyle(fontStyle: FontStyle.normal, fontSize: 14, color: Colors.grey).bold,
                          ),
                        ),
                      ).animate().fadeIn(duration: 300.ms);
                    } else if(value == PaginationLoadState.loading || value == PaginationLoadState.refreshing) {
                      return Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.context(context).primaryColor),
                          ),
                        )
                      );
                    }
                    return Container();
                  },),
              )
            ],
          );
        },
      ),
    );
  }
}

/// A helper that renders N skeletons in a grid-friendly way.
/// This is returned as ONE grid tile; it uses a Wrap to visually look like multiple cells.
class _SkeletonGrid extends StatelessWidget {
  final Widget skeleton;
  final int count;

  const _SkeletonGrid({
    required this.skeleton,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    // This tile will occupy exactly one grid cell.
    // Inside it, we show multiple skeletons vertically.
    // If you want them to look like multiple grid cells, see note below.
    return Column(
      children: List.generate(
        count,
        (i) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: skeleton,
        ),
      ),
    );
  }
}
