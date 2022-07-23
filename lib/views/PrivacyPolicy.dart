import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../AllText.dart';
import '../main.dart';

import '../notificationHelper.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Center(
                    child: Text(
                      "Условия за ползване на онлайн платформата за доставки Gery Caffeine",
                      style: TextStyle(
                        fontFamily: 'Bergen',
                        color: BLACK,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    "I. ПРЕДМЕТ",
                    style: TextStyle(
                      fontFamily: 'Bergen',
                      color: BLACK,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Bergen',
                        color: BLACK,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      text: '\nЧл. 1.',
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                ' Настоящите общи условия са предназначени за регулиране на отношенията между',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "“ЕЛИТ СПОРТ СА” ООД"),
                        TextSpan(
                            text:
                                ', ЕИК 201984091, със седалище и адрес на управление: България, гр. София, бул. Генерал Скобелев №69 наричано по-долу за краткост ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "ДОСТАВЧИК"),
                        TextSpan(
                            text: ', и клиентите, наричани по-долу ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "ПОЛЗВАТЕЛ И/ИЛИ ПОТРЕБИТЕЛ"),
                        TextSpan(
                            text:
                                ', на платформата за електронна търговия www.gerycaffeine.com, наричана по-долу ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text: '.',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    "\n\nІІ. ДАННИ ЗА ДОСТАВЧИКА",
                    style: TextStyle(
                      fontFamily: 'Bergen',
                      color: BLACK,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Bergen',
                        color: BLACK,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      text: '\nЧл.2.',
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                ' Информация съгласно Закона за електронната търговия и Закона за защита на потребителите:\n1. Наименование на Доставчика: ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "“ЕЛИТ СПОРТ СА” ООД"),
                        TextSpan(
                            text:
                                '\n2. Седалище и адрес на управление: България, гр. София, бул. Генерал Скобелев №69\n3. Адрес за упражняване на дейността и адрес за отправяне на жалби от потребители: България, гр. София, бул. Генерал Скобелев №69\n4. Данни за кореспонденция: България, гр. София, бул. Генерал Скобелев №69\n5. Вписване в публични регистри: ЕИК 201984091\n6. Надзорни органи:\n(1) Комисия за защита на личните данни\nАдрес: гр. София, ул. „Проф. Цветан Лазаров” № 2, \nтел.: (02) 940 20 46\nфакс: (02) 940 36 40\nEmail: kzld@government.bg, kzld@cpdp.bg\nУеб сайт: www.cpdp.bg\n(2) Комисия за защита на потребителите \nАдрес: 1000 гр. София, пл.”Славейков” №4А, ет.3, 4 и 6, \nтел.: 02 / 980 25 24 \nфакс: 02 / 988 42 18 \nгореща линия: 0700 111 22 \nУеб сайт: www.kzp.bg\n7. Регистрация по Закона за данък върху добавената стойност № BG 206304834',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  ///CHANGE FROM HERE

                  Text(
                    "\n\nIII. ХАРАКТЕРИСТИКИ НА ПЛАТФОРМАТА",
                    style: TextStyle(
                      fontFamily: 'Bergen',
                      color: BLACK,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Bergen',
                        color: BLACK,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      text: '\nЧл. 3. Gery Caffeine',
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                ' e платформа за електронна търговия, достъпна на адрес в Интернет www.gerycaffeine.com, чрез която Ползвателите имат възможност да сключват договори за покупко-продажба и доставка на предлаганите от Доставчика в платформата стоки, включително следното:\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "1."),
                        TextSpan(
                            text:
                                ' Да извършат регистрация и създаване на профил за преглеждане на електронния магазин на Доставчика и използване на допълнителните услуги за предоставяне на информация;\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "2."),
                        TextSpan(
                            text:
                                ' Да преглеждат стоките, техните характеристики, цени и условия за доставка;\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "3."),
                        TextSpan(
                            text:
                                ' Да сключват с Доставчика договори за покупко-продажба и доставка на стоките, предлагани от в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text: ';\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "4."),
                        TextSpan(
                            text:
                                ' Да извършват всякакви плащания във връзка със сключените договори, вкл. чрез електронни средства за разплащане.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "5."),
                        TextSpan(
                            text:
                                ' Да получават информация за нови стоки, предлагани от Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text: ';\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "6."),
                        TextSpan(
                            text:
                                ' Да извършват електронни изявления във връзка със сключването или изпълнението на договори с Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text: ' чрез интерфейса на страницата на ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text: ', достъпна в Интернет;\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "7."),
                        TextSpan(
                            text:
                                ' Да бъдат уведомявани за правата, произтичащи от закона, предимно чрез интерфейса на платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text: ' в Интернет;\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "8."),
                        TextSpan(
                            text:
                                ' Да упражняват правото си на отказ, когато е приложимо, по Закона за защита на потребителите.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 4."),
                        TextSpan(
                            text: ' Доставчикът в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' организира доставянето на стоките и гарантира правата на Ползвателите, предвидени в закона, в рамките на добросъвестността, възприетите в практиката, потребителското или търговското право критерии и условия.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 5. (1)"),
                        TextSpan(
                            text:
                                ' Ползвателите сключват с Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' договор за покупко-продажба на стоките, на адрес www.gerycaffeine.com. Договорът се сключва на български език и се съхранява в базата данни на Доставчика в платформата.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(2)"),
                        TextSpan(
                            text:
                                ' По силата на сключения с Ползвателите договор за покупко-продажба на стоки, Доставчикът в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' се задължава да организира доставката и прехвърлянето на собствеността на Ползвателя на определените от него чрез интерфейса в платформата стоки. Ползвателите имат право да поправят грешки при въвеждането на информация не по-късно от отправяне на изявлението за сключване на договора Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine\n"),
                        TextSpan(text: "(3)"),
                        TextSpan(
                            text:
                                ' Ползвателите заплащат на Доставчика на платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' възнаграждение за доставените стоки съгласно условията, определени в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' и настоящите общи условия. Възнаграждението е в размер на цената, обявена в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                '  В случай на техническа грешка на цената, Доставчикът незабавно уведомява Ползвателя за правилната цена на продукта и има право да откаже направена поръчка, поради грешно изписване на реалната й цена.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 6. (1)"),
                        TextSpan(
                            text: ' Ползвателят и Доставчикът в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' се съгласяват, че всички изявления помежду им във връзка със сключването и изпълнението на договора за покупко-продажба могат да бъдат извършвани по електронен път и чрез електронни изявления по смисъла на Закона за електронния документ и електронния подпис и чл. 11 от Закона за електронната търговия.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(2)"),
                        TextSpan(
                            text:
                                ' Предполага се, че електронните изявления, извършени от Ползвателите на сайта са извършени от лицата, посочени в данните, предоставени от Ползвателя при извършване на регистрация, ако Ползвателят е въвел съответното име и парола за достъп.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    "\nIV. ТЕХНИЧЕСКИ СТЪПКИ ЗА СКЛЮЧВАНЕ НА ДОГОВОР ЗА ПОКУПКО-ПРОДАЖБА",
                    style: TextStyle(
                      fontFamily: 'Bergen',
                      color: BLACK,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Bergen',
                        color: BLACK,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      text: '\nЧл. 8. (1)',
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                ' Ползвателите използват предимно интерфейса на страницата на Доставчика в платформата',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                '  за да сключват договори за покупко-продажба на предлаганите от доставчиците в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text: ' стоки.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(2)"),
                        TextSpan(
                            text:
                                ' В случаите на поръчка на стоки без извършване на регистрация от страна на Ползвателя, последният приема тези общи условия с момента на финализиране на поръчката.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 9."),
                        TextSpan(
                            text:
                                ' Ползвателите сключват договора за покупко-продажба на стоките в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text: ' по следната процедура:\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(1)"),
                        TextSpan(
                            text:
                                ' Влизане в системата за извършване на поръчки в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine\n(2)"),
                        TextSpan(
                            text:
                                ' Избиране на една или повече от предлаганите от Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' стоки и добавянето им към списък със стоки за покупка.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(3)"),
                        TextSpan(
                            text:
                                ' Предоставяне на необходимите данни за индивидуализация на Ползвателя като страна по договора.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(4)"),
                        TextSpan(
                            text:
                                ' Предоставяне на данни за извършване на доставката;\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(5)"),
                        TextSpan(
                            text:
                                ' Избор на способ и момент за плащане на цената.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(6)"),
                        TextSpan(
                            text: ' Потвърждение на поръчката;\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  Text(
                    "\nV. СЪДЪРЖАНИЕ НА ДОГОВОРА",
                    style: TextStyle(
                      fontFamily: 'Bergen',
                      color: BLACK,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Bergen',
                        color: BLACK,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      text: '\nЧл. 10. (1)',
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                ' Доставчикът и Ползвателите сключват отделни договори за покупко-продажба на стоките, заявени от Ползвателите, независимо че са избрани с едно електронно изявление и от един списък със стоки за покупка.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(2)"),
                        TextSpan(
                            text:
                                ' Доставчикът може да организира заедно и едновременно доставката на поръчаните с отделните договори за покупко-продажба стоки.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(3)"),
                        TextSpan(
                            text:
                                ' Πpaвaтa нa Πoлзвaтeлитe във вpъзĸa c дocтaвeнитe cтoĸи ce yпpaжнявaт oтдeлнo зa вceĸи дoгoвop зa пoĸyпĸo-пpoдaжбa. Упpaжнявaнeтo нa пpaвa във вpъзĸa c дocтaвeнa cтoĸa нe зacягa и нямa дeйcтвиe пo oтнoшeниe нa дoгoвopитe зa пoĸyпĸo-пpoдaжбa нa дpyгитe cтoĸи. B cлyчaй чe Πoлзвaтeлят имa ĸaчecтвoтo нa пoтpeбитeл пo cмиcълa нa Зaĸoнa зa зaщитa нa пoтpeбитeлитe, yпpaжнявaнeтo нa пpaвo нa oтĸaз oт дoгoвopa зa пoĸyпĸo-пpoдaжбa нa oпpeдeлeнa cтoĸa нe зacягa дoгoвopитe зa пoĸyпĸo-пpoдaжбa нa дpyгитe cтoĸи, дocтaвeни нa пoтpeбитeля. Потребителите се ползват от законова гаранция за съответствие на стоката с договора за продажба.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(4)"),
                        TextSpan(
                            text:
                                ' В случай на доставка на стоки, които се доставят промоционално заедно с други стоки в комплект, с предимство се прилагат правилата за доставка и връщане на съответния комплект, както са обявени в профила на стоката в електронния магазин.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 11."),
                        TextSpan(
                            text:
                                ' При упражняване на правата по договора за покупко-продажба Ползвателят е задължен да посочва точно и недвусмислено договора и стоката, по отношение, на които упражнява правата.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 12. (1)"),
                        TextSpan(
                            text:
                                ' Ползвателят може да плати цената за отделните договори за покупко-продажба наведнъж при извършване на поръчката на стоките или при тяхната доставка.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(2)"),
                        TextSpan(
                            text:
                                ' По отношение на стоки, които се доставят промоционално заедно с други стоки в комплект цената за комплекта се отнася само в неговата цялост и е неразделна за отделни стоки от комплекта.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(3)"),
                        TextSpan(
                            text:
                                ' В случай че Доставчикът приеме връщане на една стока от комплект по ал. 2, Ползвателят има право да му бъде възстановена сума за върнатата стока от комплекта, която е пропорционална на съотношението между цените на стоките от комплекта в електронния магазин на Доставчика когато не се предлагат в комплект една с друга.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  Text(
                    "\nVI. ОСОБЕНИ КЛАУЗИ, КОИТО СЕ ПРИЛАГАТ СПРЯМО ЛИЦА, КОИТО ИМАТ КАЧЕСТВОТО ПОТРЕБИТЕЛ ПО СМИСЪЛА НА ЗАКОНА ЗА ЗАЩИТА НА ПОТРЕБИТЕЛИТЕ",
                    style: TextStyle(
                      fontFamily: 'Bergen',
                      color: BLACK,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Bergen',
                        color: BLACK,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      text: '\nЧл. 13.',
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                ' Правилата на настоящия раздел VII от тези общи условия се прилагат единствено спрямо Ползватели, за които според данните, посочени за сключване на договора за покупко-продажба или при регистрацията в',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' може да се направи извод, че са потребители по смисъла на Закона за защита на потребителите, Закона за електронната търговия и/или на Директива 2011/83/ЕО на Европейския парламент и на Съвета от 25-ти октомври 2011 г.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 14. (1)"),
                        TextSpan(
                            text:
                                ' Основните характеристики на стоките, предлагани от Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' са определени в профила на всяка стока в платформата',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine.\n(2)"),
                        TextSpan(
                            text:
                                ' Цената на стоките с включени всички данъци и такси се определя от Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text: ' в профила на всяка стока в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine\n(3)"),
                        TextSpan(
                            text:
                                ' Стойността на пощенските или транспортните разходи, невключени в цената на стоките се определя от Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' и се предоставя като информация на Ползвателите при избиране на стоките за сключване на договора за покупко-продажба и преди финализиране на поръчката. \nПри неполучаване от Ползвател на изпратена стока повече от веднъж, Доставчикът си запазва правото да:\n– начислява транспортни разходи за Ползвателя при всяка негова следваща поръчка;\n– да не предоставя правото на отказ от закупена стока за срок повече от 14 дни;\n– да не предоставя подаръци към следващите поръчки на Ползвателя;\n– да отказва “Ценовата защита”, в случай, че Ползвателят се позове на нея.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(4)"),
                        TextSpan(
                            text:
                                ' Начините на плащане, доставка и изпълнение на договора се определят в настоящите общи условия и информацията, предоставена на Ползвателя посредством в механизмите в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine.\n(5)"),
                        TextSpan(
                            text:
                                ' Информацията, предоставяна на Ползвателите по този член е актуална към момента на визуализацията й в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' преди сключването на договора за покупко-продажба.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(6)"),
                        TextSpan(
                            text:
                                ' Ползвателите се съгласяват, че цялата изискуема от Закона за защита на потребителите информация може да бъде предоставяна чрез интерфейса на платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text: ' или електронна поща.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 15. (1)"),
                        TextSpan(
                            text:
                                ' Потребителят се съгласява, че доставчиците в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' имат право да приемат авансово плащане за сключените с потребителя договори за покупко-продажба на стоки и тяхната доставка.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(2)"),
                        TextSpan(
                            text:
                                ' Потребителят избира самостоятелно дали да заплати на Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' цената за доставка на стоките преди или в момента на доставката им.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(3)"),
                        TextSpan(
                            text:
                                ' В случай, че стойността на поръчката на Потребителя е равностойна или надвишава 10 000 лв., плащането се извършва само чрез превод или внасяне по платежна сметка на Доставчика.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 16. (1)"),
                        TextSpan(
                            text:
                                ' Потребителят има право, без да дължи обезщетение или неустойка и без да посочва причина, да се откаже от сключения договор в срок 30 дни, считано от датата на приемане на стоката от Доставчика.',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(2)"),
                        TextSpan(
                            text:
                                ' Правото на отказ по ал. 1 не се прилага в следните случаи:\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "1."),
                        TextSpan(
                            text:
                                ' за предоставяне на услуги, при които услугата е предоставена напълно и изпълнението й е започнало с изричното предварително съгласие на потребителя и потвърждение от негова страна, че знае, че ще загуби правото си на отказ, след като договорът бъде изпълнен изцяло от търговеца; \n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "2."),
                        TextSpan(
                            text:
                                ' за доставка на стоки или услуги, чиято цена зависи от колебанията на финансовия пазар, които не могат да бъдат контролирани от търговеца и които могат да настъпят по време на срока за упражняване правото на отказ;\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "3."),
                        TextSpan(
                            text:
                                ' за доставка на стоки, изработени по поръчка на потребителя или съобразно неговите индивидуални изисквания;\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "4."),
                        TextSpan(
                            text:
                                ' за доставка на стоки, които поради своето естество могат да влошат качеството си или имат кратък срок на годност;\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(3)"),
                        TextSpan(
                            text: ' Когато доставчикът в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' не e изпълнил задълженията си за предоставяне на информация, определени в Закона за защита на потребителите, Потребителят има право да се откаже от сключения договор в срок до една година и 14 дни, считано от датата на получаване на стоката. Когато информацията е предоставена на потребителя в рамките на срока за отказ, същият започва да тече от датата на предоставянето й.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(4)"),
                        TextSpan(
                            text:
                                ' Когато Потребителят е упражнил правото си на отказ от договора от разстояние или от договора извън търговския обект, Доставчикът възстановява всички суми, получени от потребителя, без неоправдано забавяне и не по-късно от 14 дни, считано от датата, на която е бил уведомен за решението на потребителя да се откаже от договора и в случай, че вече е получил обратно стоката, предмет на договора. Доставчикът възстановява получените суми по банков път, освен ако потребителят не е изразил изричното си желание за използване на друго платежно средство, като настоящото изречение се прилага, в случай, че правото на отказ е упражнено в 14-дневен срок от получаване на стоката и стоката е изпратена обратно към Доставчика в рамките на този 14-дневен срок. В случай, че правото на отказ е упражнено след 14-тия ден от получаване на стоката и/или стоката е изпратена обратно към Доставчика след 14-тия ден от получаването й от Потребителя, до 30-тия ден от получаването й, заплатените за стоката суми се възстановяват само под формата на кредит в личния профил на Потребителят в сайта на Доставчика или чрез издаване на ваучер на името на Потребителя. В случай, че потребителят желае сумите по отказ от Договора, упражнен в рамките на 14 дни от получаване на стоката, да му бъдат възстановени чрез пощенски запис/паричен превод, то таксата за услугата, която съответният куриер/пощенски оператор начислява е за сметка на потребителя и се определя от куриера/пощенския оператор. Доставчикът не може да въздейства върху тази такса, не я определя и не се облагодетелства от нея по никакъв начин.\nВ случай, че стоката, за която потребителят е направил отказ от сключения договор в рамките на 14 дни от получаване на стоката, е заплатена с карта, възстановяването на заплатената сума се извършва единствено по същата карта, с която е платено.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(5)"),
                        TextSpan(
                            text:
                                ' При упражняване на правото на отказ, разходите за връщане на доставените стоки са за сметка на потребителят на основание чл. 55, ал. 2 от ЗЗП. Доставчикът няма задължение да възстанови и допълнителните разходи за първоначалната доставка на стоките, когато потребителят изрично е избрал начин на доставяне на стоките, различен от безплатната стандартна доставка, предлагана от Доставчика.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(6)"),
                        TextSpan(
                            text:
                                ' В случай доставка на стоки, които се доставят промоционално заедно с други стоки в комплект (т.нар. bundle стоки), при упражняването на правото на отказ на Потребителя по този член и изискванията на Закона за защита на потребителя, на Потребителя се възстановява съответния намален размер на индивидуална цена на стоката като се вземе предвид съотношението на цените на стоките в електронния магазин когато не се купуват заедно (т.е. съотношението между ненамалените цени на стоките).\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(7)"),
                        TextSpan(
                            text:
                                ' Независимо от горните хипотези, Потребителят се задължава да върне стоката в търговски вид. Търговски вид означава вид, който да позволява последващата продажба на стоката като нова. Разопаковането на стоката следва да не е довело до очевидно нарушаване на търговския вид на стоката. В случай на нарушен търговски вид на стоката, Доставчикът има право по своя преценка да откаже да приеме отказ от договора или да начисли на Потребителя разходи за възстановяване на стоката в търговски вид. Съгласно чл. 55, ал. 4 от ЗЗП, Потребителят носи отговорност за намалената стойност на стоките, причинена от изпробването им, различно от необходимото, за да установи естеството, характеристиките и доброто им функциониране.',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(8)"),
                        TextSpan(
                            text:
                                ' При връщане на стоката, Потребителят се задължава да я върне заедно с пълния получен комплект, както и всички съпътстващи документи – касов бон, фактура, приемо-предавателен протокол, гаранционна карта (ако са издаден такива).',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  Text(
                    "\nVIII. ИЗПЪЛНЕНИЕ НА ДОГОВОРА",
                    style: TextStyle(
                      fontFamily: 'Bergen',
                      color: BLACK,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Bergen',
                        color: BLACK,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      text: '\nЧл. 17. (1)',
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                ' Срокът на доставка на стоката е определен за всяка стока поотделно при сключване на договора с потребителя чрез сайта на Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                '  За всяка конкретна стока Потребителят бива уведомен непосредствено преди финализирането на поръчката в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' приблизително колко дни ще отнеме доставката й. Посочените в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' дни необходими за доставка са ориентировъчни и Доставчикът не гарантира за тях, но гарантира, че ще направи всичко възможно, за да достави стоката в посочените дни.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(2)"),
                        TextSpan(
                            text:
                                ' В случай че Потребителят и Доставчикът в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' не са определили срок за доставка, срокът на доставка на стоките е 30 календарни дни, считано от датата, следваща изпращането на поръчката на потребителя до Доставчика чрез сайта на Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine\n(3)"),
                        TextSpan(
                            text: ' Ако Доставчикът в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' не може да изпълни договора поради това, че не разполага с поръчаните стоки, той е длъжен да уведоми за това потребителя и да възстанови платените от него суми. В тези случаи Доставчикът не би могъл да бъде държан отговорен доколкото е уведомил Потребителя за изчерпаните количества.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(4)"),
                        TextSpan(
                            text:
                                ' Доставчикът може да откаже обработка на поръчката, когато съществуват основателни съмнения, че поръчката е неавтентична, в това число, че не изхожда от Потребителя, описан в същата или когато заявения с поръчката продукт временно не е наличен поради изчерпване на количествата или други технически причини, като в такъв случай Доставчикът уведомява Потребителя по имейл или телефон и възстановява заплатените от него суми. Доставчикът може да откаже обработка на поръчка и когато броят или обемът на поръчаните артикули надхвърля обичайното им потребление от клиент-потребител по смисъла на ЗЗП и има основание да се смята, че поръчката се прави с цел препродажба и не попада в обхвата на потребителска покупко-продажба.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(5)"),
                        TextSpan(
                            text:
                                ' При неточни данни, предоставени от Потребителя, за адрес на доставка и телефон или отсъствие на Потребителя на адреса, както и при невъзможност за доставяне на стоката поради причини, независещи от Доставчика, стоката се връща и остава в складовете на Доставчика. В този случай стоката не се пази за Потребителя, освен ако не е заплатена предварително. При предварително заплатена стока, същата се пази в срок от 15 дни от връщането й, а след изтичането на този срок и ако Потребителят не я потърси от Доставчика, то Доставчика ще върне полученото плащане, с изключение на сумата, изразходвана за доставка и съхранение. При неточни или сгрешени данни, предоставени от Потребителя за адрес на доставката,  при което стоката бъде изпратена на грешния адрес, разходите за куриерска услуга за пренасочване на пратката, са за сметка на Потребителя.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(6)"),
                        TextSpan(
                            text:
                                ' В случай, че стоката не бъде доставена на Потребителя в рамките на посочения срок на доставка, то на Потребителя не се дължи обезщетение. Причини, които биха забавили доставката извън рамките на посочените в платформата на ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' дни, са: натоварване и брой поръчки за периода над средното и над обичайното за Доставчика; вина в куриерската фирма като например ненавременна организация на куриера, прекомерна натовареност на куриера, непредвидими технически и информационни проблеми при куриера или метеорологични условия възпрепятстващи куриера; непредвидими технически проблеми в системите на Доставчика; вина в доставчиците на Доставчика, от които последният се снабдява с продукта; лоши метеорологични условия и др. форсмажорни обстоятелства, които биха попречили на нормалната организационна дейсност на Доставчика.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(7)"),
                        TextSpan(
                            text:
                                ' Във всички случаи, Доставчикът гарантира и се ангажира, че ще достави стоката на Потребителя с не повече от 15 работни дни закъснение над ориентировъчно посочените дни за доставка в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine\nЧл. 19."),
                        TextSpan(
                            text:
                                ' Доставчикът информира Ползвателя за транспортните и куриерските разходи непосредствено преди завършване на поръчката, като цената на доставката може да варира според продукта, метода и адреса на доставка, избрани от Ползвателя. При допълнително пренасочване на вече заявена поръчка от страна на Ползвателя или при необходимост от повторно посещение на заявения адрес, Ползвателят заплаща цената на доставката в размери определени съгласно тарифата на съответния куриер. Условията за безплатна доставка, когато има такива, не се прилагат и в случай, че Ползвателят заяви посещение на адрес в определен от него час или диапазон на деня.',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(2)"),
                        TextSpan(
                            text:
                                ' Ако Ползвателят не откаже стоката от куриера и не уведоми Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' съгласно ал. 1, стоката се смята за одобрена като съответстваща на изискванията, освен за скрити недостатъци.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(3)"),
                        TextSpan(
                            text:
                                ' В случай, че при доставяне на стоката Ползвателят желае да я откаже и да не я приеме, разходите за транспорт в двете посоки са за негова сметка.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 21."),
                        TextSpan(
                            text:
                                ' Доставчикът осигурява необходимия сервиз за стоката съгласно разпоредбите на раздел XIII. РЕКЛАМАЦИИ.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 22."),
                        TextSpan(
                            text:
                                ' За неуредените в този раздел случаи се прилагат правилата търговската продажба, определени в Търговския закон и Закона защита на потребителите.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  Text(
                    "\nIX. ЗАЩИТА НА ЛИЧНИТЕ ДАННИ",
                    style: TextStyle(
                      fontFamily: 'Bergen',
                      color: BLACK,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Bergen',
                        color: BLACK,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      text: '\nЧл. 23. (1)',
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Доставчикът в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' предприема мерки за защита на личните данни на Ползвателя съгласно Закона за защита на личните данни.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(2)"),
                        TextSpan(
                            text:
                                ' От съображения за сигурност на личните данни на Ползвателите, Доставчикът в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' ще изпрати данните само на e-mail адрес, който е бил посочен от Ползвателите в момента на регистрацията.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(3)"),
                        TextSpan(
                            text: ' Доставчикът в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' има право да съхранява данни в крайното съобщително устройство на Ползвателя, освен ако последният изрично изрази несъгласието си за това.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(4)"),
                        TextSpan(
                            text:
                                ' Ползвателят или Потребителят се съгласява, че Доставчикът на платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' има право да изпраща по всяко време електронни съобщения към Ползвателя или Потребителя, включително и бюлетин или предложения за покупка на стоки, докато е налице регистрация на Ползвателя или Потребителя в електронния магазин на Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine.\n(5)"),
                        TextSpan(
                            text:
                                ' Ползвателят или Потребителят се съгласява, че Доставчикът на платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' има право да събира, съхранява и обработва данни да поведението на Ползвателя или Потребителя при използването на електронния магазин на Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine.\nЧл. 24. (1)"),
                        TextSpan(
                            text:
                                ' Във всеки момент, Доставчикът в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' има право да изисква от Ползвателя да се легитимира и да удостовери достоверността на всяко едно от обявените по време на регистрацията обстоятелства и лични данни.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(2)"),
                        TextSpan(
                            text:
                                ' В случай на непълноти относно защитата и обработката на личните данни на Ползвателя, подробно описание е налично в Политиката за поверителност на уеб сайта ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ', находяща се на\nадрес https://gerycaffeine.com/privacy-policy',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Bergen',
                        color: BLACK,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      text: '\nЧл. 23. (1)',
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Доставчикът в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' предприема мерки за защита на личните данни на Ползвателя съгласно Закона за защита на личните данни.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(2)"),
                        TextSpan(
                            text:
                                ' От съображения за сигурност на личните данни на Ползвателите, Доставчикът в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' ще изпрати данните само на e-mail адрес, който е бил посочен от Ползвателите в момента на регистрацията.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(3)"),
                        TextSpan(
                            text: ' Доставчикът в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' има право да съхранява данни в крайното съобщително устройство на Ползвателя, освен ако последният изрично изрази несъгласието си за това.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(4)"),
                        TextSpan(
                            text:
                                ' Ползвателят или Потребителят се съгласява, че Доставчикът на платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' има право да изпраща по всяко време електронни съобщения към Ползвателя или Потребителя, включително и бюлетин или предложения за покупка на стоки, докато е налице регистрация на Ползвателя или Потребителя в електронния магазин на Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine.\n(5)"),
                        TextSpan(
                            text:
                                ' Ползвателят или Потребителят се съгласява, че Доставчикът на платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' има право да събира, съхранява и обработва данни да поведението на Ползвателя или Потребителя при използването на електронния магазин на Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine.\nЧл. 24. (1)"),
                        TextSpan(
                            text:
                                ' Във всеки момент, Доставчикът в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' има право да изисква от Ползвателя да се легитимира и да удостовери достоверността на всяко едно от обявените по време на регистрацията обстоятелства и лични данни.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(2)"),
                        TextSpan(
                            text:
                                ' В случай на непълноти относно защитата и обработката на личните данни на Ползвателя, подробно описание е налично в Политиката за поверителност на уеб сайта ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ', находяща се на\nадрес https://gerycaffeine.com/privacy-policy\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  Text(
                    "\nX. ИЗМЕНЕНИЕ И ДОСТЪП ДО ОБЩИТЕ УСЛОВИЯ",
                    style: TextStyle(
                      fontFamily: 'Bergen',
                      color: BLACK,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Bergen',
                        color: BLACK,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      text: '\nЧл. 25. (1)',
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                ' Настоящите общи условия могат да бъдат изменяни от Доставчика на платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                '  за което последният ще уведоми по подходящ начин всички регистрирани Ползватели.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(2)"),
                        TextSpan(
                            text: ' Доставчикът в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' и Ползвателят се съгласяват, че всяко допълване и изменение на тези общи условия ще има действие спрямо Ползвателя в един от следните случаи:\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "A)"),
                        TextSpan(
                            text:
                                'след изричното му уведомяване от Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' и ако Ползвателят не заяви в предоставения му 14-дневен срок, че ги отхвърля; или\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Б)"),
                        TextSpan(
                            text:
                                ' след публикуването им на сайта на Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' и ако Ползвателят не заяви в 14-дневен срок от публикуването им, че ги отхвърля;\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "В)"),
                        TextSpan(
                            text:
                                ' с изричното му приемане от Ползвателя чрез профила му в сайта на Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine.\n(3)"),
                        TextSpan(
                            text:
                                ' Ползвателят се съгласява, че всички изявления на Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                '  във връзка с изменението на тези общи условия ще бъдат изпращани на адреса на електронната поща, посочена от Ползвателя, при регистрацията. Ползвателят се съгласява, че електронните писма, изпратени по реда на този член не е необходимо да бъдат подписани с електронен подпис, за да имат действие спрямо него.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 26."),
                        TextSpan(
                            text:
                                ' Доставчикът публикува тези общи условия на адрес https://gerycaffeine.com/terms  заедно с всички допълнения и изменения в тях.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  Text(
                    "\nXI. ПРЕКРАТЯВАНЕ",
                    style: TextStyle(
                      fontFamily: 'Bergen',
                      color: BLACK,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Bergen',
                        color: BLACK,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      text: '\nЧл. 27.',
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                ' Настоящите общи условия и договора на Ползвателя с Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' се прекратяват в следните случаи:\n• при прекратяване и обявяване в ликвидация или обявяване в несъстоятелност на една от страните по договора;\n• по взаимно съгласие на страните в писмен вид;\n• при обективна невъзможност на някоя от страните по договора да изпълнява задълженията си;\n• при изземване или запечатване на оборудването от държавни органи;\n• в случай на заличаване на регистрацията на Ползвателя в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                '. В този случай сключените, но неизпълнени договори за покупко-продажба остават в сила и подлежат на изпълнение;\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 28."),
                        TextSpan(
                            text:
                                ' Доставчикът има право по свое усмотрение, без да отправя предизвестие и без да дължи обезщетение да прекрати едностранно договора, в случай че установи, че Ползвателят използва платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' в нарушение на настоящите общи условия, законодателството в Република България, общоприетите нравствени норми или общоприетите правила и практика в електронната търговия.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  Text(
                    "\nXII. ОТГОВОРНОСТ",
                    style: TextStyle(
                      fontFamily: 'Bergen',
                      color: BLACK,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Bergen',
                        color: BLACK,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      text: '\nЧл. 29.',
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                ' Ползвателят се задължава да обезщети и да освободи от отговорност доставчиците в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' и Доставчика при съдебни искове и други претенции на трети лица (независимо дали са основателни или не), за всички щети и разходи (в това число адвокатски хонорари и съдебни разноски), произтичащи от или във връзка с (1) неизпълнение на някое от задълженията по този договор, (2) нарушение на авторски, продуцентски, права на излъчване или други права върху интелектуалната или индустриална собственост, (3) неправомерно прехвърляне на други лица на правата, предоставени на Ползвателя, за срока и при условията на договора и (4) невярно деклариране наличието или отсъствието на качеството потребител по смисъла на Закона за защита на потребителите.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 30."),
                        TextSpan(
                            text:
                                ' Доставчикът не носи отговорност в случай на непреодолима сила, случайни събития, проблеми в Интернет, технически или други обективни причини, включително и разпореждания на компетентните държавни органи.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 31. (1)"),
                        TextSpan(
                            text:
                                ' Доставчикът не носи отговорност за вреди, причинени от Ползвателя на трети лица.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(2)"),
                        TextSpan(
                            text:
                                ' Доставчикът не носи отговорност за имуществени или неимуществени вреди, изразяващи се в пропуснати ползи или претърпени вреди, причинени на Ползвателят в процеса на използване или неизползване на ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' и сключване на договори за покупко-продажба с Доставчика.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(3)"),
                        TextSpan(
                            text:
                                ' Доставчикът не носи отговорност за времето, през което платформата не е била достъпна поради непреодолима сила.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(4)"),
                        TextSpan(
                            text:
                                ' Доставчикът не носи отговорност за вреди от коментари, мнения и публикации под продуктите, новините и статиите в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine.\nЧл. 32. (1)"),
                        TextSpan(
                            text:
                                ' Доставчикът не носи отговорност в случай на преодоляване на мерките за сигурност на техническото оборудване и от това последва загуба на информация, разпространение на информация, достъп до информация, ограничаване на достъп до информация и други сходни последствия.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(2)"),
                        TextSpan(
                            text:
                                ' Доставчикът не носи отговорност в случай на сключване на договор за покупко-продажба, предоставяне на достъп до информация, загуба или промяна на данни настъпили вследствие на фалшива легитимация на трето лице, което се представя за Ползвателя, ако от обстоятелствата може да се съди, че това лице е Ползвателя.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  Text(
                    "\nXIII. ДРУГИ УСЛОВИЯ",
                    style: TextStyle(
                      fontFamily: 'Bergen',
                      color: BLACK,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Bergen',
                        color: BLACK,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      text: '\nЧл. 34. (1)',
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Ползвателят и Доставчикът в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' се задължават да защитават взаимно своите права и законни интереси, както и да пазят търговските си тайни, станали тяхно достояние в процеса на изпълнение договора и тези общи условия.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "(2)"),
                        TextSpan(
                            text:
                                ' Ползвателят и Доставчикът се задължават по време и след изтичане на периода на договора да не правят публично достояние писмена или устна кореспонденция проведена между тях. За публично достояние може да се смята публикуването на кореспонденция в печатни и електронни медии, интернет форуми, лични или публични уеб сайтове и др.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 35."),
                        TextSpan(
                            text:
                                ' В случай на противоречие между тези общи условия и уговорки в специален договор между Доставчика в платформата ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Gery Caffeine"),
                        TextSpan(
                            text:
                                ' и Ползвателя, с предимство се прилагат клаузите на специалния договор.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 36."),
                        TextSpan(
                            text:
                                ' Евентуалната недействителност на някоя от разпоредбите на тези общи условия няма да води до недействителност на целия договор.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 37."),
                        TextSpan(
                            text:
                                ' За неуредените в този договор въпроси, свързани с изпълнението и тълкуването на този договор, се прилагат законите на Република България.\n',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: "Чл. 38."),
                        TextSpan(
                            text:
                                ' Настоящите общи условия влизат в сила за всички Ползватели на 10.05.2021 г.',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: WHITE,
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 17,
                    color: BLACK,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Text(
                    PRIVACY_POLICY,
                    style: TextStyle(
                        fontFamily: 'Bergen',
                        color: BLACK,
                        fontWeight: FontWeight.bold,
                        fontSize: 23),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
