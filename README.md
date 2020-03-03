# Работа с временными файлами

Позволяет удобно управлять созданием и удалением временных файлов.

## API

Для обращения к методам модуля используется простанство имен **ВременныеФайлы**, например:
`ВременныйКаталог = ВременныеФайлы.СоздатьКаталог();`

|Метод|Описание
|----|----|
|``НовоеИмяФайла(Расширение = "tmp")`` | генерирует уникальное имя, по которому можно создать временный файл
|``СоздатьФайл(Расширение = "tmp")`` | создает файл во временном каталоге системы, возвращает путь
|``СоздатьКаталог(Расширение = "tmp")`` | создает каталог во временном каталоге системы, возвращает путь
|``Удалить()`` | удаляет все ранее созданные файлы и каталоги
|``УдалитьФайл(Путь)`` | удаляет указанный файл/каталог. Если у файла указан файловый атрибут "только для чтения", перед удалением происходит попытка снять этот атрибут.
|``БезопасноУдалитьФайл(Путь)`` | удаляет указанный файл полностью аналогично методу `УдалитьФайл`
|``Файлы()`` | возвращает массив с путями ко всем временным файлам
|``УдалитьНакопленныеВременныеФайлы(ВременныеФайлыДо)`` | удаляются все накопленные временные файлы, которые были добавлены после фиксации набора временных файлов с помощью метода `Файлы`
