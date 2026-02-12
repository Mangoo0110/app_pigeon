import 'dart:collection';

import 'package:example/src/core/utils/extensions/textstyle_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../pagination.dart';

class PaginatedListWidget<T> extends StatefulWidget {
  final PaginationController<T> pagination;
  final Widget skeleton;
  /// How many skeletons to show, when there is no data
  final int skeletonCount;
  final String emptyMessage;
  final Widget Function(int index, T data) builder;
  const PaginatedListWidget({
    super.key,
    required this.pagination,
    required this.skeleton,
    required this.skeletonCount,
    required this.builder,
    this.emptyMessage = "No data found"
  });

  @override
  State<PaginatedListWidget<T>> createState() => _PaginatedListWidgetState<T>();
}

class _PaginatedListWidgetState<T> extends State<PaginatedListWidget<T>> {
    final ScrollController scrollController = ScrollController();

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
      body: RefreshIndicator(
        onRefresh: () async {
          widget.pagination.refresh();
        },
        child: ListenableBuilder(
          listenable: widget.pagination,
          builder: (context, _) {
            final items = widget.pagination.items.value;
            debugPrint("${widget.pagination.state.value}");
            if(widget.pagination.state.value == PaginationLoadState.nopages) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text(widget.emptyMessage)),
                  IconButton(onPressed: widget.pagination.refresh, icon: const Icon(Icons.refresh))
                ],
              ).animate().fadeIn(duration: 300.ms);
            
            }

            if(widget.pagination.state.value == PaginationLoadState.idle) {
              return Center(child: Text("Pull to refresh!")).animate().fadeIn(duration: 300.ms);
            }
            
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                // return Container(
                //   height: 20,
                //   color: Colors.amber,
                // );
                debugPrint(
                  "Index: $index, length: ${items.length}, state: ${widget.pagination.state.value}",
                );
                if ((index == items.length) && (widget.pagination.state.value == PaginationLoadState.loading ||
                      widget.pagination.state.value == PaginationLoadState.refreshing)) {
                        //return Container();
                    // Skeleton
                    return Column(
                      children: [
                        ...List.generate(
                          widget.skeletonCount,
                          (_) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: widget.skeleton,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 300.ms);
                  }
                if((widget.pagination.state.value == PaginationLoadState.allLoaded && index == items.length)) {
                  return Center(child: Text("End", style: TextStyle(fontStyle: FontStyle.italic).w500,)).animate().fadeIn(duration: 300.ms);
                }
                final element = items[index];
                return widget.builder(index, element)
                // .animate().slideY(
                //   begin: 0.1,
                //   end: 0,
                //   duration: 300.ms,
                //   curve: Curves.easeOutCubic,
                // ).fadeIn(
                //   duration: 300.ms,
                //   curve: Curves.easeOutCubic,
                // )
                ;
              },
            );
          }, 
        ),
      ),
    );
  }
}
