
#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(Отказ, РежимПроведения)


	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДоговорыКонтрагентов.ВКМ_НачалоДействияДоговора КАК ВКМ_НачалоДействияДоговора,
	|	ДоговорыКонтрагентов.ВКМ_ОкончаниеДействияДоговора КАК ВКМ_ОкончаниеДействияДоговора,
	|	ДоговорыКонтрагентов.ВКМ_СтоимтостьЧаса
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.Ссылка = &Ссылка
	|	И ДоговорыКонтрагентов.ВидДоговора = &ВидДоговора";

	Запрос.УстановитьПараметр("Ссылка", ДоговорКонтрагента);
	Запрос.УстановитьПараметр("ВидДоговора", Перечисления.ВидыДоговоровКонтрагентов.ВКМ_АбонентскоеОбслуживание);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл	
		НачалоДействияДоговора = ВыборкаДетальныеЗаписи.ВКМ_НачалоДействияДоговора;
		ОкончаниеДействияДоговора = ВыборкаДетальныеЗаписи.ВКМ_ОкончаниеДействияДоговора;
		СтоимтостьЧаса = ВыборкаДетальныеЗаписи.ВКМ_СтоимтостьЧаса;
	КонецЦикла;
	

	Если ЗначениеЗаполнено(НачалоДействияДоговора) Тогда
		Если Дата < НачалоДействияДоговора Или Дата
			> ОкончаниеДействияДоговора Тогда
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = "Отказ в проведении так как дата документа Обслуживание клиента выходит за пределы договора";
				Сообщение.Сообщить();
				Отказ = Истина;
				Возврат;
		КонецЕсли;

	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НачалоДействияДоговора) Тогда
		Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = "Отказ в проведении, так как вид договора не Абонентское обслуживание";
				Сообщение.Сообщить();
				Отказ = Истина;
				Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВКМ_УсловияОплатыСотрудниковСрезПоследних.Сотрудник,
		|	ВКМ_УсловияОплатыСотрудниковСрезПоследних.ПроцентОтРабот
		|ИЗ
		|	РегистрСведений.ВКМ_УсловияОплатыСотрудников.СрезПоследних(&ДатаПроведенияРабот, Сотрудник = &Специалист) КАК
		|		ВКМ_УсловияОплатыСотрудниковСрезПоследних";
	
	Запрос.УстановитьПараметр("Специалист", Специалист);
	Запрос.УстановитьПараметр("ДатаПроведенияРабот", ДатаПроведенияРабот);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ПроцентОтРабот = ВыборкаДетальныеЗаписи.ПроцентОтРабот;
	Иначе
		ПроцентОтРабот = 0;
	КонецЕсли;
	
	Движения.ВКМ_ВыполненныеКлиентуРаботы.Записывать = Истина;
	Движения.ВКМ_ВыполненныеСотрудникомРаботы.Записывать = Истина;
	Движения.ВКМ_ДополнительныеНачисления.Записывать = Истина;
	Движения.ВКМ_Удержания.Записывать = Истина;
	
		// регистр ВКМ_ВыполненныеКлиентуРаботы
		Движение = Движения.ВКМ_ВыполненныеКлиентуРаботы.Добавить();
		Движение.Период = Дата;
		Движение.Контрагент = Клиент;
		Движение.ДоговорКонтрагента = ДоговорКонтрагента;
		Движение.КоличествоЧасов = ВыполненныеРаботы.Итог("ЧасыКОплатеКлиенту");
		Движение.СуммаКОплате = ВыполненныеРаботы.Итог("ЧасыКОплатеКлиенту") * СтоимтостьЧаса;
		
		// регистр ВКМ_ВыполненныеСотрудникомРаботы
		Движение = Движения.ВКМ_ВыполненныеСотрудникомРаботы.Добавить();
		Движение.Период = Дата;
		Движение.Сотрудник = Специалист;
		Движение.ЧасовКОплате = ВыполненныеРаботы.Итог("ЧасыКОплатеКлиенту");
		Движение.СуммаКОплате = (ВыполненныеРаботы.Итог("ЧасыКОплатеКлиенту") * СтоимтостьЧаса * ПроцентОтРабот / 100);
	
	// регистр ВКМ_ДополнительныеНачисления	Процент от работы
		Движение = Движения.ВКМ_ДополнительныеНачисления.Добавить();
		Движение.Сторно = Ложь;
		Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_ДополнительныеНачисления.Процент;
		Движение.ПериодРегистрации = Дата;
		Движение.БазовыйПериодНачало = НачалоМесяца(Дата);
		Движение.БазовыйПериодКонец = КонецМесяца(Дата);
		Движение.Сотрудник = Специалист;
		Движение.Результат = (ВыполненныеРаботы.Итог("ЧасыКОплатеКлиенту") * СтоимтостьЧаса * ПроцентОтРабот / 100);
		Движения.ВКМ_ДополнительныеНачисления.Записать();
		
	
	// регистр ВКМ_ВзаиморасчетыССотрудниками
		Движения.ВКМ_ВзаиморасчетыССотрудниками.Записывать = Истина;
		Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.Добавить();
		Движение.Период = Дата;
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Сотрудник = Специалист;
		Движение.Сумма = (ВыполненныеРаботы.Итог("ЧасыКОплатеКлиенту") * СтоимтостьЧаса * ПроцентОтРабот / 100);
	
	Движения.ВКМ_ДополнительныеНачисления.Записать();
	Движения.ВКМ_ВыполненныеСотрудникомРаботы.Записать();
	Движения.ВКМ_ВзаиморасчетыССотрудниками.Записать();
	Движения.ВКМ_ВыполненныеКлиентуРаботы.Записать();
	
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	//Данный фрагмент построен конструктором.
	//При повторном использовании конструктора, внесенные вручную данные будут утеряны!


	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ

КонецПроцедуры

#КонецОбласти


