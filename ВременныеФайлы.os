﻿//////////////////////////////////////////////////////////////////
//
// Простой хелпер создания временных файлов и каталогов
//
//////////////////////////////////////////////////////////////////

#Использовать logos

Перем мВременныеФайлы;
Перем Лог;
Перем ЭтоWindows;

Перем БазовыйКаталог Экспорт;

/////////////////////////////////////////////////////////////////////////
// Программный интерфейс

// генерирует уникальное имя, по которому можно создать временный файл
//
// Параметры:
//   Расширение - Строка - Расширение файла. По умолчанию "tmp"
//
//  Возвращаемое значение:
//   Строка - полный путь временного файла
//
Функция НовоеИмяФайла(Знач Расширение = "tmp") Экспорт
	
	ИмяВремФайла = ПолучитьИмяВременногоФайла(Расширение);
	Если ЗначениеЗаполнено(БазовыйКаталог) Тогда
		ИмяВремФайла = ОбъединитьПути(БазовыйКаталог, ИмяВремФайла);
	КонецЕсли;
	
	мВременныеФайлы.Добавить(ИмяВремФайла);
	
	Возврат ИмяВремФайла;
	
КонецФункции

// создает файл с расширением во временном каталоге системы
//
// Параметры:
//   Расширение - Строка - Расширение файла. По умолчанию "tmp"
//
//  Возвращаемое значение:
//   Строка - полный путь созданного временного файла
//
Функция СоздатьФайл(Знач Расширение = "tmp") Экспорт

	ИмяФайла = НовоеИмяФайла(Расширение);
	Кодировка = ?(ЭтоWindows, КодировкаТекста.ANSI, "utf-8");
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла, Кодировка);
	ЗаписьТекста.Закрыть();
	Возврат ИмяФайла;

КонецФункции

// создает каталог с расширением во временном каталоге системы
//
// Параметры:
//   Расширение - Строка - Расширение файла. По умолчанию "tmp"
//
//  Возвращаемое значение:
//   Строка - полный путь созданного временного каталога
//
Функция СоздатьКаталог(Знач Расширение = "tmp") Экспорт

	ИмяФайла = НовоеИмяФайла(Расширение);
	СоздатьКаталог(ИмяФайла);
	
	Возврат ИмяФайла;

КонецФункции

// удаляет все ранее созданные файлы и каталоги
//
Процедура Удалить() Экспорт
	
	КрайнийИндекс = мВременныеФайлы.Количество()-1;
	Для Сч = 0 По КрайнийИндекс Цикл
		
		Индекс = КрайнийИндекс-Сч;
		ИмяВременногоФайла = мВременныеФайлы[Индекс];
		Если БезопасноУдалитьФайл(ИмяВременногоФайла) Тогда
			мВременныеФайлы.Удалить(Индекс);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// удаляет указанный файл/каталог. 
// Если у файла указан файловый атрибут "только для чтения", перед удалением происходит попытка снять этот атрибут.
//
// Параметры:
//   Путь - Строка - путь файла
//
//  Возвращаемое значение:
//   Булево - удалось или не удалось удалить файл
//
Функция УдалитьФайл(Знач Путь) Экспорт
	Возврат БезопасноУдалитьФайл(Путь);
КонецФункции

// удаляет указанный файл/каталог. 
// Если у файла указан файловый атрибут "только для чтения", перед удалением происходит попытка снять этот атрибут.
//
// Параметры:
//   Путь - Строка - путь файла
//
//  Возвращаемое значение:
//   Булево - удалось или не удалось удалить файл
//
Функция БезопасноУдалитьФайл(Знач Путь) Экспорт
	
	Попытка

		Для каждого Файл Из НайтиФайлы(Путь, ПолучитьМаскуВсеФайлы(), Истина) Цикл
			Если Файл.ПолучитьТолькоЧтение() Тогда
				Файл.УстановитьТолькоЧтение(Ложь);
			КонецЕсли;
		КонецЦикла;

		УдалитьФайлы(Путь);

		Возврат Истина;

	Исключение

		ТекстОшибки = "Попытка удаления " + Путь + " закончилась неудачей, по причине " + ОписаниеОшибки();
		Лог.Предупреждение(ТекстОшибки);

	КонецПопытки;

	Возврат Ложь;
	
КонецФункции

// Массив накопленных путей временных файлов
//
//  Возвращаемое значение:
//   Массив - <описание возвращаемого значения>
//
Функция Файлы() Экспорт
	Результат = Новый Массив;
	Для каждого Путь Из мВременныеФайлы Цикл
		Результат.Добавить(Путь);
	КонецЦикла;
	Возврат Результат;
КонецФункции

// Удалить все накопленные временные файлы, которые были добавлены после фиксации набора временных файлов.
// Удобно использовать для быстрой очистки на очередной итерации
// Предварительно нужно зафиксировать текущий набор временных файлов через Файлы()
// Алгоритм:
// 	ВременныеФайлыДо = ВременныеФайлы.Файлы();
// 	Попытка
// 		// основной код						
// 	Исключение
// 		// обработка ошибок
// 		ВременныеФайлы.УдалитьНакопленныеВременныеФайлы(ВременныеФайлыДо);
// 		ВызватьИсключение;
// 	КонецПопытки;
// 	ВременныеФайлы.УдалитьНакопленныеВременныеФайлы(ВременныеФайлыДо);
//
// Параметры:
//   ВременныеФайлыДо - Массив - набор ранее полученных временных файлов через Файлы()
//
Процедура УдалитьНакопленныеВременныеФайлы(Знач ВременныеФайлыДо) Экспорт
	ВременныеФайлыПосле = Файлы();

	ОтборФайлов = Новый Соответствие;
	СкопироватьКоллекцию(ВременныеФайлыДо, ОтборФайлов);

	КрайнийИндекс = ВременныеФайлыПосле.Количество()-1;
	Для Сч = 0 По КрайнийИндекс Цикл
		
		Индекс = КрайнийИндекс-Сч;
		ИмяВременногоФайла = ВременныеФайлыПосле[Индекс];
		Если ОтборФайлов.Получить(ИмяВременногоФайла) = Неопределено
				И БезопасноУдалитьФайл(ИмяВременногоФайла) Тогда
				ВременныеФайлыПосле.Удалить(Индекс);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Скопировать одну простую коллекцию (Массив) в другую (Структура, Соответствие)
// значение из источника становится и ключем, и значение приемника
//
// Параметры:
//   Массив - Массив - <описание параметра>
//   Приемник - Структура, Соответствие - <описание параметра>
//
Процедура СкопироватьКоллекцию(Массив, Приемник) Экспорт
	Для каждого Значение Из Массив Цикл
		Приемник.Вставить(Значение, Значение);
	КонецЦикла;
КонецПроцедуры

СистемнаяИнформация = Новый СистемнаяИнформация;
ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;

мВременныеФайлы = Новый Массив;
Лог = Логирование.ПолучитьЛог("oscript.app.tempfiles");
