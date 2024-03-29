import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:headr/controllers/feed_controller.dart';
import 'package:headr/models/bookmark.dart';
import 'package:headr/widgets/bookmark_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BookmarksScreen extends StatefulWidget {

  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {

  final FeedController fc = Get.find();

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // SizedBox(height: 3.h,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child: Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent
                          ),
                          child: const Center(child: Icon(Icons.chevron_left_rounded),),
                        ),
                      ),
                      Text("Bookmarks",style: Get.textTheme.titleLarge,),
                      SizedBox(width: 10.w,)
                    ],
                  ),
                ),

                SizedBox(height: 3.h,),
                TextFormField(
                  focusNode: searchFocus,
                  controller: searchController,
                  style: Get.textTheme.titleMedium,
                  keyboardType: TextInputType.name,
                  onChanged: (v) async {

                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    fillColor: Colors.white10,
                    filled: true,
                    prefixIcon: const IntrinsicHeight(
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            VerticalDivider(color: Colors.white38)
                          ],
                        ),
                      ),
                    ),
                    // suffixIcon: Obx(() {
                    //   if (searchController.text == '') {
                    //     return const SizedBox();
                    //   } else {
                    //     return GestureDetector(
                    //         onTap: () {
                    //
                    //         },
                    //         child: SizedBox(
                    //             width: 15.w,
                    //             height: 8.h,
                    //             child: Center(
                    //                 child: Text(
                    //                   'clear',
                    //                   style: Get.textTheme.titleSmall!
                    //                       .copyWith(color: Colors.white70),
                    //                 ))));
                    //   }
                    // }),
                    hintText: "Search your bookmarks",
                    hintStyle:
                    Get.textTheme.titleMedium!.copyWith(color: Colors.white38),
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 4.h,),

                Obx(() {
                  if(fc.bookmarks.isNotEmpty){
                    return ListView.builder(
                      itemCount: fc.bookmarks.length,
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context,index){
                        Bookmark b = fc.bookmarks[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            width: 100.w,
                            height: 15.h,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(46, 46, 48, 1),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.s,
                                children: [
                                  Container(
                                    width: 25.w,
                                    height: 10.h,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                              b.articleImage.toString(),
                                            ),
                                            fit: BoxFit.cover
                                        )
                                    ),
                                  ),
                                  SizedBox(width: 4.w,),
                                  SizedBox(
                                    width: 40.w,
                                    child: Text(b.articleTitle.toString(),style: Get.textTheme.titleSmall!.copyWith(
                                        fontWeight: FontWeight.bold
                                    ),maxLines: 4,overflow: TextOverflow.ellipsis,),
                                  ),
                                  const Spacer(),
                                  BookmarkWidget(articleDocId: b.articleDocId.toString()),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }else{
                    return SizedBox(
                      height: 60.h,
                      width: 100.w,
                      child: Center(
                        child: Text('No bookmarks saved yet'),
                      ),
                    );
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
