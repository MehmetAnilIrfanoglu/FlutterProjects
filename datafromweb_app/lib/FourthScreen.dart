import 'package:flutter/material.dart';
import 'ArticleInfo.dart';

class FourthScreen extends StatefulWidget {
  @override
  _FourthScreenState createState() => _FourthScreenState();
}

class _FourthScreenState extends State<FourthScreen> {
  var topics = ['The Paleo Diet','The Blood Type Diet','The Vegan Diet','The South Beach Diet','The Mediterranean Diet','Raw Food Diet'];
  var preReading = ['natural way of eating','for particular blood types','form of a vegetarian diet ','carbohydrates are completely avoided','kind of vegetable-heavy diet','eating uncooked foods'];
  var links = ['https://www.google.com.tr/webhp?ei=OP49Vpy_JcSVPteCkqgO&ved=0CAUQqS4oAw','https://www.google.com.tr/webhp?ei=OP49Vpy_JcSVPteCkqgO&ved=0CAUQqS4oAw','https://www.google.com.tr/webhp?ei=OP49Vpy_JcSVPteCkqgO&ved=0CAUQqS4oAw','https://www.google.com.tr/webhp?ei=OP49Vpy_JcSVPteCkqgO&ved=0CAUQqS4oAw','https://www.google.com.tr/webhp?ei=OP49Vpy_JcSVPteCkqgO&ved=0CAUQqS4oAw','https://www.google.com.tr/webhp?ei=OP49Vpy_JcSVPteCkqgO&ved=0CAUQqS4oAw'];
  var articleText = ['This is a natural way of eating, one that almost abandons all intake of sugar. The only sugar in a Paleo diet comes from fruit. However, abandoning sugar is not the only stipulation. Processed foods and grains are also eliminated from the Paleo diet. The fewer number of carbohydrates in your system leads to a decreased amount of glucose. So your system will then begin to use fat as its fuel source. In a Paleo diet, dairy is also eliminated. So what can be eaten? A Paleo diet consists of fish, fowl, vegetables, fruits, nuts, oils, sweet potatoes, eggs and meat, so long as that meat is grass-fed and not grain-fed.','Some doctors have started to research diets that coincide with particular blood types. The premise of these diets attempts to match people with their common dietary needs based on their blood type. For example, individuals with type O blood are recommended to eat lots of food that are high in protein. In order to lose weight, spinach, red meat, seafood and broccoli are suggested while dairy should be avoided. Those with type A blood are recommended to avoid meat and place an emphasis on turkey, tofu, and fruit while weight loss is contingent on eating a diet that consists primarily of soy, seafood and vegetables. Individuals with type B and AB blood also have their own dietary restrictions and recommendations.','This diet is a form of a vegetarian diet as it eliminates meat and animal products. One of the primary effects of this diet is that it reduces the intake of cholesterol and saturated fat. It takes some planning, but if a vegan diet is rationed out properly, it can have many positive effects. Studies have proven that those who practice a vegan diet minimize their overall risk of coronary heart disease, obesity and high blood pressure. To compensate for a lack of meat, vegans must find a way to incorporate more sources of protein and vitamin B-12 into their diets.','This diet was first introduced in 2003 and is based on the premise of changing one’s overall eating habits by balancing out one’s everyday diet. Certain carbohydrates are completely avoided. It does not eliminate carbohydrates altogether, but aims to educate dieters on which carbs to always avoid. This often leads to developing a healthy way of eating so that it will be sustainable for the rest of people’s lives. The diet includes a selection of healthy fats, lean protein, as well as good carbs.','This is another kind of vegetable-heavy diet that avoids a lot of meat, but does not eliminate it altogether. This diet has been proven to help with depression, in addition to controlling blood sugar levels and helping with weight loss. The Mediterranean diet recommends the use of oil as much as possible and that means as an alternative to butter, salad dressings or marinades. It also emphasizes adding vegetables to each meal and favors fish over chicken. Whole grains, nuts and herbs are also used in larger amounts.','This is a diet that places a premium on eating uncooked and unprocessed foods. The diet eliminates the intake of any foods that have been pasteurized or produced with any kind of synthetics or additives. The diet is intended to create a surge in energy, a decrease in inflammation, while also lowering the number of carcinogens in one’s diet.'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article'),

      ),
      body: ListView.builder(
        itemBuilder: (context, position) {
          return GestureDetector(
            onTap: (){
              print(links[position]);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleInfo(topics[position],articleText[position],links[position])));

            },
            child: Container(
              height: 100,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                            child: Text(
                              topics[position],
                              style: TextStyle(
                                  fontSize: 22.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                            child: Text(
                              preReading[position],
                              style: TextStyle(fontSize: 18.0),softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.more,
                          color: Colors.pink,
                          size: 24.0,
                          semanticLabel: 'Text to announce in accessibility modes',
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 2.0,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          );
        },
        itemCount: topics.length,
      ),

    );
  }
}
