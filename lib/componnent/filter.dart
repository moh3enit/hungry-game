import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_challenge_app/constants.dart';
import 'package:restaurant_challenge_app/model/categories.dart';
import 'package:restaurant_challenge_app/model/field_notifier.dart';
import 'package:restaurant_challenge_app/screens/game/list_restaurant_screen.dart';

class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  List<Categories> cuisineList=[
    Categories('acaibowls','Acai Bowls'),
    Categories('bagels','Bagels'),
    Categories('pizza','Pizza'),
    Categories('bakeries','Bakeries'),
    Categories('beer_and_wine','Beer, Wine & Spirits'),
    Categories('beverage_stores','Beverage Store'),
    Categories('brewpubs','Brewpubs'),
    Categories('bubbletea','Bubble Tea'),
    Categories('butcher','Butcher'),
    Categories('csa','CSA'),
    Categories('chimneycakes','Chimney Cakes'),
    Categories('cideries','Cideries'),
    Categories('coffee','Coffee & Tea'),
    Categories('coffeeroasteries','Coffee Roasteries'),
    Categories('convenience','Convenience Stores'),
    Categories('cupcakes','Cupcakes'),
    Categories('customcakes','Custom Cakes'),
    Categories('desserts','Desserts'),
    Categories('distilleries','Distilleries'),
    Categories('diyfood','Do-It-Yourself Food'),
    Categories('donuts','Donuts'),
    Categories('empanadas','Empanadas'),
    Categories('farmersmarket','Farmers Market'),
    Categories('fooddeliveryservices','Food Delivery Services'),
    Categories('foodtrucks','Food Trucks'),
    Categories('gelato','Gelato'),
    Categories('grocery','Grocery'),
    Categories('honey','Honey'),
    Categories('icecream','Ice Cream & Frozen Yogurt'),
    Categories('importedfood','Imported Food'),
    Categories('intlgrocery','International Grocery'),
    Categories('internetcafe','Internet Cafes'),
    Categories('juicebars','Juice Bars & Smoothies'),
    Categories('kombucha','Kombucha'),
    Categories('meaderies','Meaderies'),
    Categories('organic_stores','Organic Stores'),
    Categories('cakeshop','Patisserie/Cake Shop'),
    Categories('piadina','Piadina'),
    Categories('poke','Poke'),
    Categories('pretzels','Pretzels'),
    Categories('shavedice','Shaved Ice'),
    Categories('cheese','Cheese Shops'),
    Categories('macarons','Macarons'),
    Categories('pastashops','Pasta Shops'),
    Categories('streetvendors','Street Vendors'),
    Categories('tea','Tea Rooms'),
    Categories('winetastingroom','Wine Tasting Room'),
    Categories('afghani','Afghan'),
    Categories('senegalese','Senegalese'),
    Categories('southafrican','South African'),
    Categories('newamerican','American (New)'),
    Categories('arabian','Arabian'),
    Categories('argentine','Argentine'),
    Categories('armenian','Armenian'),
    Categories('asianfusion','Asian Fusion'),
    Categories('australian','Australian'),
    Categories('austrian','Austrian'),
    Categories('bangladeshi','Bangladeshi'),
    Categories('australian','Australian'),
    Categories('austrian','Austrian'),
    Categories('bangladeshi','Bangladeshi'),
    Categories('bbq','Barbeque'),
    Categories('basque','Basque'),
    Categories('belgian','Belgian'),
    Categories('brasseries','Brasseries'),
    Categories('brazilian','Brazilian'),
    Categories('breakfast_brunch','Breakfast & Brunch'),
    Categories('pancakes','Pancakes'),
    Categories('british','British'),
    Categories('buffets','Buffets'),
    Categories('bulgarian','Bulgarian'),
    Categories('burgers','Burgers'),
    Categories('burmese','Burmese'),
    Categories('cafes','Cafes'),
    Categories('themedcafes','Themed Cafes'),
    Categories('cafeteria','Cafeteria'),
    Categories('cajun','Cajun/Creole'),
    Categories('cambodian','Cambodian'),
    Categories('caribbean','Caribbean'),
    Categories('dominican','Dominican'),
    Categories('haitian','Haitian'),
    Categories('puertorican','Puerto Rican'),
    Categories('trinidadian','Trinidadian'),
    Categories('catalan','Catalan'),
    Categories('cheesesteaks','Cheesesteaks'),
    Categories('chinese','Chinese'),
    Categories('cantonese','Cantonese'),
    Categories('dimsum','Dim Sum'),
    Categories('hainan','Hainan'),
    Categories('shanghainese','Shanghainese'),
    Categories('szechuan','Szechuan'),
    Categories('comfortfood','Comfort Food'),
    Categories('creperies','Creperies'),
    Categories('cuban','Cuban'),
    Categories('czech','Czech'),
    Categories('delis','Delis'),
    Categories('diners','Diners'),
    Categories('dinnertheater','Dinner Theater'),
    Categories('eritrean','Eritrean'),
    Categories('ethiopian','Ethiopian'),
    Categories('hotdogs','Fast Food'),
    Categories('filipino','Filipino'),
    Categories('fishnchips','Fish & Chips'),
    Categories('fondue','Fondue'),
    Categories('food_court','Food Court'),
    Categories('foodstands','Food Stands'),
    Categories('french','French'),
    Categories('mauritius','Mauritius'),
    Categories('reunion','Reunion'),
    Categories('gamemeat','Game Meat'),
    Categories('gastropubs','Gastropubs'),
    Categories('georgian','Georgian'),
    Categories('german','German'),
    Categories('gluten_free','Gluten-Free'),
    Categories('greek','Greek'),
    Categories('guamanian','Guamanian'),
    Categories('halal','Halal'),
    Categories('hawaiian','Hawaiian'),
    Categories('himalayan','Himalayan/Nepalese'),
    Categories('honduran','Honduran'),
    Categories('hkcafe','Hong Kong Style Cafe'),
    Categories('hotdog','Hot Dogs'),
    Categories('hotpot','Hot Pot'),
    Categories('indpak','Indian'),
    Categories('indonesian','Indonesian'),
    Categories('irish','Irish'),
    Categories('italian','Italian'),
    Categories('calabrian','Calabrian'),
    Categories('sardinian','Sardinian'),
    Categories('sicilian','Sicilian'),
    Categories('tuscan','Tuscan'),
    Categories('japanese','Japanese'),
    Categories('conveyorsushi','Conveyor Belt Sushi'),
    Categories('ramen','Ramen'),
    Categories('teppanyaki','Teppanyaki'),
    Categories('kebab','Kebab'),
    Categories('korean','Korean'),
    Categories('kosher','Kosher'),
    Categories('laotian','Laotian'),
    Categories('latin','Latin American'),
    Categories('colombian','Colombian'),
    Categories('salvadoran','Salvadoran'),
    Categories('venezuelan','Venezuelan'),
    Categories('raw_food','Live/Raw Food'),
    Categories('malaysian','Malaysian'),
    Categories('mediterranean','Mediterranean'),
    Categories('falafel','Falafel'),
    Categories('mexican','Mexican'),
    Categories('modern_european','Modern European'),
    Categories('mongolian','Mongolian'),
    Categories('newmexican','New Mexican Cuisine'),
    Categories('nicaraguan','Nicaraguan'),
    Categories('noodles','Noodles'),
    Categories('pakistani','Pakistani'),
    Categories('panasian','Pan Asian'),
    Categories('persian','Persian/Iranian'),
    Categories('peruvian','Peruvian'),
    Categories('polish','Polish'),
    Categories('polynesian','Polynesian'),
    Categories('portuguese','Portuguese'),
    Categories('poutineries','Poutineries'),
    Categories('russian','Russian'),
    Categories('salad','Salad'),
    Categories('sandwiches','Sandwiches'),
    Categories('scandinavian','Scandinavian'),
    Categories('scottish','Scottish'),
    Categories('seafood','Seafood'),
    Categories('singaporean','Singaporean'),
    Categories('slovakian','Slovakian'),
    Categories('somali','Somali'),
    Categories('soulfood','Soul Food'),
    Categories('soup','Soup'),
    Categories('southern','Southern'),
    Categories('spanish','Spanish'),
    Categories('srilankan','Sri Lankan'),
    Categories('steak','Steakhouses'),
    Categories('supperclubs','Supper Clubs'),
    Categories('sushi','Sushi Bars'),
    Categories('syrian','Syrian'),
    Categories('taiwanese','Taiwanese'),
    Categories('tapas','Tapas Bars'),
    Categories('tapasmallplates','Tapas/Small Plates'),
    Categories('tex-mex','Tex-Mex'),
    Categories('thai','Thai'),
    Categories('turkish','Turkish'),
    Categories('vegan','Vegan'),
    Categories('vegetarian','Vegetarian'),
    Categories('vietnamese','Vietnamese'),
    Categories('waffles','Waffles'),
    Categories('wraps','Wraps'),
  ];

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: kPrimaryColor,
          brightness: Brightness.light,
          elevation: 0,
          title: Text('Filter', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: kColorWhite)),
          leading: IconButton(
            iconSize: 20.0,
            icon: Icon(Icons.arrow_back_ios),
            color: kColorWhite,
            onPressed: () {
              Provider.of<FieldNotifier>(context, listen: false).changeCategoriesRestaurantSearch(null);
              Provider.of<FieldNotifier>(context, listen: false).changeNameRestaurantSearch(null);
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Search Name Restaurant',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87)),
                      SizedBox(height: 10),
                      NameRestaurantFilter(),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Categories',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: CategoriesFilter(cuisineList),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 24)],
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15)),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                side: BorderSide(color: kPrimaryColor, width: 1.5, style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(15),
                              )),
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                              textStyle: MaterialStateProperty.all(TextStyle(color: kPrimaryColor))
                          ),
                          child: Text('Clear', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 1,color: kPrimaryColor)),
                          onPressed: () {
                            Provider.of<FieldNotifier>(context, listen: false).changeCategoriesRestaurantSearch(null);
                            Provider.of<FieldNotifier>(context, listen: false).changeNameRestaurantSearch(null);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15)),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              )),
                              elevation: MaterialStateProperty.all(12),
                              backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                              textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white))
                          ),
                          child: Text('Apply', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 1)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  )
              )
            ],
          ),
        )
    );
  }
}

class NameRestaurantFilter extends StatefulWidget {
  @override
  _NameRestaurantFilterState createState() => _NameRestaurantFilterState();
}

class _NameRestaurantFilterState extends State<NameRestaurantFilter> {
  TextEditingController nameController;

  @override
  void initState() {
    nameController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String name=Provider.of<FieldNotifier>(context, listen: false).nameRestaurantSearch==null ? '' : Provider.of<FieldNotifier>(context, listen: false).nameRestaurantSearch;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        TextFormField(
          onChanged: (text){
            if(text.length > 2){
              Provider.of<FieldNotifier>(context, listen: false).changeNameRestaurantSearch(text);
            }else{
              Provider.of<FieldNotifier>(context, listen: false).changeNameRestaurantSearch(null);
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Name Restaurant',
            labelStyle: TextStyle(fontSize: 15.0),
            suffixIcon: Icon(
              Icons.search_rounded,
              size: 25.0,
            ),
          ),
          initialValue: name,
        ),
      ],
    );
  }
}

class CategoriesFilter extends StatefulWidget {
  final List<Categories> cuisinesList;
  CategoriesFilter(this.cuisinesList);
  @override
  _CategoriesFilterState createState() => _CategoriesFilterState();
}

class _CategoriesFilterState extends State<CategoriesFilter> {
  String selectedBrand ;
  @override
  Widget build(BuildContext context) {
    selectedBrand=Provider.of<FieldNotifier>(context, listen: false).categoriesRestaurantSearch;
    return Scrollbar(
      isAlwaysShown: true,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: widget.cuisinesList.length,
        itemBuilder: (context, index) {
          return listItem(widget.cuisinesList[index]);
        },
        separatorBuilder: (context, index) {
          return separator();
        },
      ),
    );
  }

  Widget listItem(Categories categories) {
    return InkWell(
      onTap: () {
        setState(() => selectedBrand = categories.alias);
        Provider.of<FieldNotifier>(context, listen: false).changeCategoriesRestaurantSearch(selectedBrand);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(categories.title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                    color: (selectedBrand == categories.alias) ? Colors.black87 : Colors.black87)),
            if (selectedBrand == categories.alias) ... [
              Icon(Icons.check_circle, color: kPrimaryColor, size: 20)
            ]
          ],
        ),
      ),
    );
  }

  Widget separator() {
    return Divider(height: 1, thickness: 1, color: Colors.grey);
  }
}
