#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(Отказ,Режим)
	
	НДФЛ = Константы.ВКМ_ПроцентНДФЛ.Получить();
	// регистр ВКМ_ОсновныеНачисления
	Движения.ВКМ_ОсновныеНачисления.Записывать = Истина;
	Для Каждого ТекСтрокаОсновныеНачисления из ОсновныеНачисления Цикл
		
		Если Не ЗначениеЗаполнено(ТекСтрокаОсновныеНачисления.ПроцентОтРабот) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Просьба заполнить поле ""Процент от работ""";
			ПолеСтроки = СтрШаблон("ОсновныеНачисления[%1].ПроцентОтРабот",ТекСтрокаОсновныеНачисления.НомерСтроки - 1);
			Сообщение.Поле = ПолеСтроки;
			Сообщение.КлючДанных = Ссылка;
			Сообщение.ПутьКДанным =  "Объект";
			Сообщение.Сообщить();
			Отказ = Истина;
	
		КонецЕсли;
		
		Движение = Движения.ВКМ_ОсновныеНачисления.Добавить();
		Движение.Сторно = Ложь;
		Движение.ГрафикРаботы = ТекСтрокаОсновныеНачисления.ГрафикРаботы;
		Движение.ВидРасчета = ТекСтрокаОсновныеНачисления.ВидРасчета;
		Движение.ПериодРегистрации = ТекСтрокаОсновныеНачисления.ДатаОкончания;
		Движение.ПериодДействияНачало = ТекСтрокаОсновныеНачисления.ДатаНачала;
		Движение.ПериодДействияКонец = ТекСтрокаОсновныеНачисления.ДатаОкончания;
		//Движение.БазовыйПериодНачало = ТекСтрокаОсновныеНачисления.ДатаНачала;
		//Движение.БазовыйПериодКонец = ТекСтрокаОсновныеНачисления.ДатаОкончания;
		Движение.Сотрудник = ТекСтрокаОсновныеНачисления.Сотрудник;
		Движение.Показатель = ТекСтрокаОсновныеНачисления.Оклад;
		//Движение.Результат = РассчитатьОтпускные(ТекСтрокаОсновныеНачисления.ДатаНачала, ТекСтрокаОсновныеНачисления.ДатаОкончания, ТекСтрокаОсновныеНачисления.Сотрудник);
		
		
	

	Если ТекСтрокаОсновныеНачисления.ВидРасчета = ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Отпуск Тогда
			Движение.БазовыйПериодНачало = НачалоМесяца(ДобавитьМесяц(ТекСтрокаОсновныеНачисления.ДатаНачала, -12));
			Движение.БазовыйПериодКонец = КонецМесяца(ТекСтрокаОсновныеНачисления.ДатаОкончания);
			//Движение.ОтработаноДней = День(ТекСтрокаОсновныеНачисления.ДатаОкончания) - День(ТекСтрокаОсновныеНачисления.ДатаНачала) + 1; 
		Движение.ОтработаноДней = ((ТекСтрокаОсновныеНачисления.ДатаОкончания - 
				ТекСтрокаОсновныеНачисления.ДатаНачала) / 86400) + 1;
//				Отпускные = РассчитатьОтпускные(ТекСтрокаОсновныеНачисления.ДатаНачала,
//				ТекСтрокаОсновныеНачисления.ДатаОкончания, ТекСтрокаОсновныеНачисления.Сотрудник);
//			Движение.Результат = Отпускные;	 
//			//сколько фактически дней чел был в отпуске  
//			// регистр ВКМ_Удержания
//			Движения.ВКМ_Удержания.Записывать = Истина;
//			Движение = Движения.ВКМ_Удержания.Добавить();
//			Движение.Сторно = Ложь;
//			Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_Удержания.НДФЛ;
//			Движение.ПериодРегистрации = ТекСтрокаОсновныеНачисления.ДатаОкончания;
//			Движение.Сотрудник = ТекСтрокаОсновныеНачисления.Сотрудник;
//			Движение.Результат = Отпускные * (НДФЛ / 100);
//			
//			// регистр ВКМ_ВзаиморасчетыССотрудниками
//			Движения.ВКМ_ВзаиморасчетыССотрудниками.Записывать = Истина;
//			Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.Добавить();
//			Движение.Период = Дата;
//			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
//			Движение.Сотрудник = ТекСтрокаОсновныеНачисления.Сотрудник;
//			Движение.Сумма = Отпускные;
		КонецЕсли;
		
	
	
		
		УсловияОплаты = РегистрыСведений.ВКМ_УсловияОплатыСотрудников.СоздатьМенеджерЗаписи();
		УсловияОплаты.Период = ТекСтрокаОсновныеНачисления.ДатаОкончания;
		УсловияОплаты.Сотрудник = ТекСтрокаОсновныеНачисления.Сотрудник;	
		УсловияОплаты.Оклад = ТекСтрокаОсновныеНачисления.Оклад;
		УсловияОплаты.ПроцентОтРабот = ТекСтрокаОсновныеНачисления.ПроцентОтРабот;
		УсловияОплаты.Записать();
		
	КонецЦикла;
	
	Движения.ВКМ_ОсновныеНачисления.Записать();
	
	РассчитатьОклад(); 
	РассчитатьОтпускные();
	
//	// регистр ВКМ_Удержания
//	Движения.ВКМ_Удержания.Записывать = Истина;
//	Для Каждого ТекСтрокаОсновныеНачисления из ОсновныеНачисления Цикл
//		Движение = Движения.ВКМ_Удержания.Добавить();
//		Движение.Сторно = Ложь;
//		Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_Удержания.НДФЛ;
//		Движение.ПериодРегистрации = ТекСтрокаОсновныеНачисления.ДатаОкончания;
//		Движение.Сотрудник = ТекСтрокаОсновныеНачисления.Сотрудник;
//		Движение.Результат = ТекСтрокаОсновныеНачисления.Результат * (НДФЛ / 100);
//	КонецЦикла;


	// регистр ВКМ_ВзаиморасчетыССотрудниками
//	Движения.ВКМ_ВзаиморасчетыССотрудниками.Записывать = Истина;
//	Для Каждого ТекСтрокаОсновныеНачисления из ОсновныеНачисления Цикл
//		Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.Добавить();
//		Движение.Период = Дата;
//		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
//		Движение.Сотрудник = ТекСтрокаОсновныеНачисления.Сотрудник;
//		Движение.Сумма = ТекСтрокаОсновныеНачисления.Результат * (НДФЛ / 100);
//	КонецЦикла;
	
	//РассчитатьОтпускные(ДатаНачала, ДатаОкончания, Сотрудник);
	
	
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	//Данный фрагмент построен конструктором.
	//При повторном использовании конструктора, внесенные вручную данные будут утеряны!



	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры

//Процедура КоличествоРабочихДнейВПериоде(ТекСтрокаОсновныеНачисления, Движение)
//	Перем РезультатЗапроса;
//	Перем Запрос;
//	Перем ВыборкаДетальныеЗаписи;
//	Запрос = Новый Запрос;
//	Запрос.Текст =
//		"ВЫБРАТЬ
//		|	СУММА(ГрафикиРаботы.Значение) КАК Значение
//		|ИЗ
//		|	РегистрСведений.ГрафикиРаботы КАК ГрафикиРаботы
//		|ГДЕ
//		|	ГрафикиРаботы.Дата >= &ДатаНачала
//		|	И ГрафикиРаботы.Дата <= &ДатаОкончания";
//	
//	Запрос.УстановитьПараметр("ДатаОкончания", ТекСтрокаОсновныеНачисления.ДатаОкончания);
//	Запрос.УстановитьПараметр("ДатаНачала", ТекСтрокаОсновныеНачисления.ДатаНачала);
//	
//	РезультатЗапроса = Запрос.Выполнить();
//	
//	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
//	
//	ВыборкаДетальныеЗаписи.Следующий();
//		Движение.ДнейОтпуска = ВыборкаДетальныеЗаписи.Значение;
//КонецПроцедуры
#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура РассчитатьОклад()
	
	НДФЛ = Константы.ВКМ_ПроцентНДФЛ.Получить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОсновныеНачисленияДанныеГрафика.НомерСтроки КАК НомерСтроки,
		|	ЕСТЬNULL(ОсновныеНачисленияДанныеГрафика.ЗначениеФактическийПериодДействия, 0) КАК ФактическиОтработанныхДней,
		|	ЕСТЬNULL(ОсновныеНачисленияДанныеГрафика.ЗначениеПериодДействия, 0) КАК КоличествоРабочихДнейВПериоде,
		|	ОсновныеНачисленияДанныеГрафика.Сотрудник,
		|	ОсновныеНачисленияДанныеГрафика.ОтработаноДней
		|ИЗ
		|	РегистрРасчета.ВКМ_ОсновныеНачисления.ДанныеГрафика(ВидРасчета = &Оклад
		|	И Регистратор = &Ссылка) КАК ОсновныеНачисленияДанныеГрафика";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Оклад", ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Оклад);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Движение = Движения.ВКМ_ОсновныеНачисления[ВыборкаДетальныеЗаписи.НомерСтроки - 1]; 
		

		ДневнаяСтавка = Движение.Показатель / ВыборкаДетальныеЗаписи.КоличествоРабочихДнейВПериоде;
		//ДневнаяСтавка = Движение.Показатель / ВыборкаДетальныеЗаписи.ОтработаноДней;
		
		Движение.Результат = (ДневнаяСтавка * ВыборкаДетальныеЗаписи.ФактическиОтработанныхДней); 
		Движение.ОтработаноДней = ВыборкаДетальныеЗаписи.ФактическиОтработанныхДней;
		
		// регистр ВКМ_Удержания
			//Движения.ВКМ_Удержания.Записывать = Истина;
			Движение = Движения.ВКМ_Удержания.Добавить();
			Движение.Сторно = Ложь;
			Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_Удержания.НДФЛ;
			Движение.ПериодРегистрации = Дата;
			Движение.Сотрудник = ВыборкаДетальныеЗаписи.Сотрудник;
			Движение.Результат = (ДневнаяСтавка * ВыборкаДетальныеЗаписи.ФактическиОтработанныхДней) * (НДФЛ / 100);
			
			// регистр ВКМ_ВзаиморасчетыССотрудниками
			//Движения.ВКМ_ВзаиморасчетыССотрудниками.Записывать = Истина;
			Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.Добавить();
			Движение.Период = Дата;
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Сотрудник = ВыборкаДетальныеЗаписи.Сотрудник;
			Движение.Сумма = ДневнаяСтавка * ВыборкаДетальныеЗаписи.ФактическиОтработанныхДней;
				
	КонецЦикла;
	
	Движения.ВКМ_ОсновныеНачисления.Записать(, Истина);
	Движения.ВКМ_Удержания.Записать();
	Движения.ВКМ_ВзаиморасчетыССотрудниками.Записать();
КонецПроцедуры

//Функция РассчитатьОтпускные(ДатаНачала, ДатаОкончания, Сотрудник)
Процедура РассчитатьОтпускные()
	
//Запрос = Новый Запрос;
//	Запрос.Текст = "ВЫБРАТЬ
//	|	ВКМ_ОсновныеНачисления.ВидРасчета КАК ВидРасчета,
//	|	ВКМ_ОсновныеНачисления.Сотрудник КАК Сотрудник,
//	|	СУММА(ВКМ_ОсновныеНачисления.Результат) КАК Результат
//	|ПОМЕСТИТЬ вт_Оклад
//	|ИЗ
//	|	РегистрРасчета.ВКМ_ОсновныеНачисления КАК ВКМ_ОсновныеНачисления
//	|ГДЕ
//	|	ВКМ_ОсновныеНачисления.Сотрудник = &Сотрудник
//	|	И ВКМ_ОсновныеНачисления.ПериодДействияНачало >= &ПериодДействияНачало12МесяцевНазад
//	|	И ВКМ_ОсновныеНачисления.ПериодДействияКонец <= &ПериодДействияКонецРасчетногоМесяца
//	|	И ВКМ_ОсновныеНачисления.ВидРасчета = &ВидРасчета
//	|СГРУППИРОВАТЬ ПО
//	|	ВКМ_ОсновныеНачисления.ВидРасчета,
//	|	ВКМ_ОсновныеНачисления.Сотрудник
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|ВЫБРАТЬ
//	|	ВКМ_ДополнительныеНачисления.Сотрудник КАК Сотрудник,
//	|	ВКМ_ДополнительныеНачисления.Результат КАК Результат,
//	|	ВКМ_ДополнительныеНачисления.ПериодРегистрации КАК ПериодРегистрации
//	|ПОМЕСТИТЬ вт_Премия
//	|ИЗ
//	|	РегистрРасчета.ВКМ_ДополнительныеНачисления КАК ВКМ_ДополнительныеНачисления
//	|ГДЕ
//	|	ВКМ_ДополнительныеНачисления.Сотрудник = &Сотрудник
//	|	И ВКМ_ДополнительныеНачисления.ПериодРегистрации >= &ПериодДействияНачало12МесяцевНазад
//	|	И ВКМ_ДополнительныеНачисления.ПериодРегистрации <= &ПериодДействияКонецРасчетногоМесяца
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|ВЫБРАТЬ
//	|	ВКМ_ВыполненныеСотрудникомРаботыОбороты.Сотрудник КАК Сотрудник,
//	|	СУММА(ВКМ_ВыполненныеСотрудникомРаботыОбороты.СуммаКОплатеОборот) КАК СуммаКОплатеОборот
//	|ПОМЕСТИТЬ вт_ПрочентыОтРабот
//	|ИЗ
//	|	РегистрНакопления.ВКМ_ВыполненныеСотрудникомРаботы.Обороты(&ПериодДействияНачало12МесяцевНазад, &ПериодДействияКонецРасчетногоМесяца,
//	|		Месяц, Сотрудник = &Сотрудник) КАК ВКМ_ВыполненныеСотрудникомРаботыОбороты
//	|СГРУППИРОВАТЬ ПО
//	|	ВКМ_ВыполненныеСотрудникомРаботыОбороты.Сотрудник
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|ВЫБРАТЬ
//	|	КОЛИЧЕСТВО(ГрафикиРаботы.Значение) КАК Значение
//	|ПОМЕСТИТЬ вт_КоличествоРабочихДней
//	|ИЗ
//	|	РегистрСведений.ГрафикиРаботы КАК ГрафикиРаботы
//	|ГДЕ
//	|	ГрафикиРаботы.Значение = &Значение
//	|	И ГрафикиРаботы.Дата >= &ПериодДействияНачало12МесяцевНазад
//	|	И ГрафикиРаботы.Дата <= &ПериодДействияКонецРасчетногоМесяца
//	|СГРУППИРОВАТЬ ПО
//	|	ГрафикиРаботы.ГрафикРаботы
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|ВЫБРАТЬ
//	|	КОЛИЧЕСТВО(ГрафикиРаботы.Значение) КАК Значение
//	|ПОМЕСТИТЬ вт_КоличествоДнейОтпуска
//	|ИЗ
//	|	РегистрСведений.ГрафикиРаботы КАК ГрафикиРаботы
//	|ГДЕ
//	|	ГрафикиРаботы.Значение = &Значение
//	|	И ГрафикиРаботы.Дата >= &ПериодДействияНачало
//	|	И ГрафикиРаботы.Дата <= &ПериодДействияКонец
//	|СГРУППИРОВАТЬ ПО
//	|	ГрафикиРаботы.ГрафикРаботы
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|ВЫБРАТЬ
//	|	вт_Оклад.Сотрудник КАК Сотрудник,
//	|	вт_Оклад.Результат + вт_Премия.Результат + вт_ПрочентыОтРабот.СуммаКОплатеОборот КАК ОбщаяСумма,
//	|	вт_КоличествоРабочихДней.Значение КАК КоличествоРабочихДней,
//	|	вт_КоличествоДнейОтпуска.Значение КАК КоличествоДнейОтпуска
//	|ИЗ
//	|	вт_Оклад КАК вт_Оклад
//	|		ЛЕВОЕ СОЕДИНЕНИЕ вт_Премия КАК вт_Премия
//	|		ПО вт_Оклад.Сотрудник = вт_Премия.Сотрудник
//	|		ЛЕВОЕ СОЕДИНЕНИЕ вт_ПрочентыОтРабот КАК вт_ПрочентыОтРабот
//	|		ПО вт_Оклад.Сотрудник = вт_ПрочентыОтРабот.Сотрудник,
//	|	вт_КоличествоРабочихДней КАК вт_КоличествоРабочихДней,
//	|	вт_КоличествоДнейОтпуска КАК вт_КоличествоДнейОтпуска";
//	
//	Период12МесяцевНазадНачало = ДобавитьМесяц(ДатаНачала, -12);
//	ПериодДействияКонецРасчетногоМесяца = КонецМесяца(ДатаОкончания);
//	Запрос.УстановитьПараметр("ПериодДействияНачало12МесяцевНазад", Период12МесяцевНазадНачало);
//	Запрос.УстановитьПараметр("ПериодДействияКонецРасчетногоМесяца", ПериодДействияКонецРасчетногоМесяца);
//	Запрос.УстановитьПараметр("ПериодДействияНачало", ДатаНачала);
//	Запрос.УстановитьПараметр("ПериодДействияКонец", ДатаОкончания);
//	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
//	Запрос.УстановитьПараметр("ВидРасчета", ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Оклад);
//	Запрос.УстановитьПараметр("Значение", 1);
//	
//	РезультатЗапроса = Запрос.Выполнить();
//	
//	Выборка = РезультатЗапроса.Выбрать();
//	
//	Выборка.Следующий();
//	
//	Отпускные = (Выборка.ОбщаяСумма / Выборка.КоличествоРабочихДней) * Выборка.КоличествоДнейОтпуска;
	
//	Структура = Новый Структура;
//	Структура.Вставить("ОбщаяСумма", Выборка.ОбщаяСумма);
//	Структура.Вставить("КоличествоРабочихДней", Выборка.КоличествоРабочихДней);
//	Структура.Вставить("КоличествоДнейОтпуска", Выборка.КоличествоДнейОтпуска);
	
	
//	Возврат Отпускные;
НДФЛ = Константы.ВКМ_ПроцентНДФЛ.Получить();		
			
Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОсновныеНачисления.НомерСтроки КАК НомерСтроки,
		|	ЕСТЬNULL(ОсновныеНачисленияБазаОсновныеНачисления.Результат, 0) КАК БазаОсн,
		|	ЕСТЬNULL(ОсновныеНачисленияБазаОсновныеНачисления.ОтработаноДнейБаза, 0) КАК ОтработаноДней,
		|	ВКМ_ОсновныеНачисленияДанныеГрафика.ЗначениеФактическийПериодДействия КАК ФактическийОтработаноДней,
		|	ВКМ_ОсновныеНачисленияДанныеГрафика.ЗначениеБазовыйПериод КАК КоличествоРабочихДнейВПериоде,
		|	ОсновныеНачисленияБазаОсновныеНачисления.БазовыйПериодКонец,
		|	ОсновныеНачисленияБазаОсновныеНачисления.БазовыйПериодНачало,
		|	ОсновныеНачисленияБазаОсновныеНачисления.ПериодДействия,
		|	ОсновныеНачисленияБазаОсновныеНачисления.ПериодДействияКонец,
		|	ОсновныеНачисленияБазаОсновныеНачисления.ПериодДействияНачало,
		|	ОсновныеНачисленияБазаОсновныеНачисления.ПериодРегистрации,
		|	ОсновныеНачисленияБазаОсновныеНачисления.Результат,
		|	ОсновныеНачисленияБазаОсновныеНачисления.Сотрудник,
		|	ОсновныеНачисленияБазаОсновныеНачисления.ОтработаноДней КАК ДнейОтпускаФакт,
		|	ОсновныеНачисленияБазаОсновныеНачисления.РезультатБаза КАК РезультатБаза,
		|	ОсновныеНачисленияБазаОсновныеНачисления.Показатель,
		|	ОсновныеНачисленияБазаОсновныеНачисления.ОтработаноДнейБаза
		|ИЗ
		|	РегистрРасчета.ВКМ_ОсновныеНачисления КАК ОсновныеНачисления
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_ОсновныеНачисления.БазаВКМ_ОсновныеНачисления(&Измерения, &Измерения,,
		|			Регистратор = &Ссылка
		|		И ВидРасчета = &Отпуск) КАК ОсновныеНачисленияБазаОсновныеНачисления
		|		ПО ОсновныеНачисления.НомерСтроки = ОсновныеНачисленияБазаОсновныеНачисления.НомерСтроки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_ОсновныеНачисления.ДанныеГрафика КАК ВКМ_ОсновныеНачисленияДанныеГрафика
		|		ПО ОсновныеНачисления.НомерСтроки = ВКМ_ОсновныеНачисленияДанныеГрафика.НомерСтроки
		|ГДЕ
		|	ОсновныеНачисления.Регистратор = &Ссылка
		|	И ОсновныеНачисления.ВидРасчета = &Отпуск";
	
	БазовыйПериодНачало = ДобавитьМесяц(Дата, -12);
	БазовыйПериодКонец = Дата;
	
	Запрос.УстановитьПараметр("БазовыйПериодНачало", БазовыйПериодНачало);
	Запрос.УстановитьПараметр("БазовыйПериодКонец", БазовыйПериодКонец);
	Запрос.УстановитьПараметр("Отпуск", ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Отпуск);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Измерения = Новый Массив;
	Измерения.Добавить("Сотрудник");
	
	
	Запрос.УстановитьПараметр("Измерения", Измерения);
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Движение = Движения.ВКМ_ОсновныеНачисления[ВыборкаДетальныеЗаписи.НомерСтроки - 1];
		
		Если ВыборкаДетальныеЗаписи.ОтработаноДнейБаза = 0 Тогда
			Движение.Результат = 0;
			Продолжить;
		КонецЕсли;
			
		Движение.Показатель = ВыборкаДетальныеЗаписи.РезультатБаза / ВыборкаДетальныеЗаписи.ОтработаноДнейБаза;
		Результат = (ВыборкаДетальныеЗаписи.РезультатБаза / ВыборкаДетальныеЗаписи.ОтработаноДнейБаза) * ВыборкаДетальныеЗаписи.ДнейОтпускаФакт; 
		Движение.Результат = Результат; 
		
		// регистр ВКМ_Удержания
			//Движения.ВКМ_Удержания.Записывать = Истина;
			Движение = Движения.ВКМ_Удержания.Добавить();
			Движение.Сторно = Ложь;
			Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_Удержания.НДФЛ;
			Движение.ПериодРегистрации = Дата;
			Движение.Сотрудник = ВыборкаДетальныеЗаписи.Сотрудник;
			Движение.Результат = ((ВыборкаДетальныеЗаписи.РезультатБаза / ВыборкаДетальныеЗаписи.ОтработаноДнейБаза) 
					* ВыборкаДетальныеЗаписи.ДнейОтпускаФакт) * (НДФЛ / 100);
			
			// регистр ВКМ_ВзаиморасчетыССотрудниками
			//Движения.ВКМ_ВзаиморасчетыССотрудниками.Записывать = Истина;
			Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.Добавить();
			Движение.Период = Дата;
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Сотрудник = ВыборкаДетальныеЗаписи.Сотрудник;
			Движение.Сумма = Результат;	
	КонецЦикла;	
	
	Движения.ВКМ_ОсновныеНачисления.Записать(, Истина);
	Движения.ВКМ_Удержания.Записать();
	Движения.ВКМ_ВзаиморасчетыССотрудниками.Записать();
	
КонецПроцедуры

#КонецОбласти	
