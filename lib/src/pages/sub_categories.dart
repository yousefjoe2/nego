import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/category_bloc.dart';
import '../models/category_args.dart';
import '../models/sub_category.dart';
import '../routes.dart';
import '../widgets/appbar.dart';
import '../widgets/drawer.dart';

class SubCategoryPage extends StatefulWidget {
  final String categoryId;

  const SubCategoryPage({Key key, this.categoryId}) : super(key: key);
  @override
  _ProductSubCategoryPage createState() => _ProductSubCategoryPage(categoryId);
}

class _ProductSubCategoryPage extends State<SubCategoryPage> {
  final String categoryId;

  _ProductSubCategoryPage(this.categoryId);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var categoriesBloc = Provider.of<CategoriesBloc>(context);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF3B3B3B),
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: Container(
        child: StreamBuilder<List<SubCategory>>(
          stream: categoriesBloc.getSubCategories(categoryId: this.categoryId),
          builder: (context, snapshot) {
            if (snapshot.data == null) return Container();
            if (snapshot.data.length == 0)
              return Center(
                child: Text(
                  'لا توجد منتجات تتوافق مع اختيارك.',
                  style: TextStyle(color: Colors.yellow),
                ),
              );
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: snapshot?.data?.length,
                itemBuilder: (dynamic, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                        height: width,
                        width: width / .5,
                        child: _buildSubCategory(
                            snapshot?.data[index], categoryId)),
                  );
                });
          },
        ),
      ),
    );
  }

  _buildSubCategory(SubCategory category, String categoryId) {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(Routes.PRODUCTS,
            arguments: CategoryArguments(categoryId, category.id));
        print('test');
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        height: height / 2.5,
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: Color(0xFFE09900),
            width: 3,
          ),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.black26],
          ),
          image: DecorationImage(
            image: NetworkImage(category.image.isEmpty
                ? 'http://kwu.hashtaj.com/wp-content/uploads/2020/08/t4.png'
                : category.image),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    gradient: LinearGradient(colors: [
                      Colors.blueGrey[900],
                      Colors.grey[900],
                    ]),
                  ),
                  child: Text(
                    category?.name ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
