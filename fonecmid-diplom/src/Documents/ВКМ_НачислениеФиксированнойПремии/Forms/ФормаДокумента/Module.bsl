
#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НДФЛ = Константы.ВКМ_ПроцентНДФЛ.Получить();
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПремии

&НаКлиенте
Процедура ПремииПремияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Премии.ТекущиеДанные;
	ТекущиеДанные.НДФЛ = ТекущиеДанные.Премия * (НДФЛ / 100);
	ТекущиеДанные.Результат = ТекущиеДанные.Премия - ТекущиеДанные.НДФЛ;
	
КонецПроцедуры

#КонецОбласти
