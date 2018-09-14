'===============================================================================
'MIT License
'
'Copyright (c) 2018 Alexander Kirichenko
'
'Permission is hereby granted, free of charge, to any person obtaining a copy
'of this software and associated documentation files (the "Software"), to deal
'in the Software without restriction, including without limitation the rights
'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
'copies of the Software, and to permit persons to whom the Software is
'furnished to do so, subject to the following conditions:
'
'The above copyright notice and this permission notice shall be included in all
'copies or substantial portions of the Software.
'
'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
'LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
'OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
'SOFTWARE.
'===============================================================================

'   Sub OnClientConnect(oClient)
'   End Sub

   Sub OnAcceptMessage(oClient, oMessage)
	'*******************************************************************************************'
	'Здесь отлавливаем нестандартные письма от Rubytech Media Converter Rack и добавляем                 '
	'в них недостающую пустую строку, которой (по стандарту) должен отделяться текст содержания '
	'письма от его заголовка.                                                                   '
	'*******************************************************************************************'
	'Переменные - значения параметров скрипта по умолчанию: чьи письма смотреть и где кончается заголовок и начинается содержание письма.
	Const Sender = "Media Converter Rack", lstHeadLine = "Subject:"	

	If oMessage.From = Sender Then 'От Кривого ли письмо?
		'Переменные для работы с файловой системой.
		'FSO - спец. объект, корневой для работы с файлами и папками
		'FText - объект-текстовый поток (здесь - текстовый файл), его методами читаем и пишем в файл.
		'NewFText - строка, новое содержимое для нашего письма (текстового файла).
		Dim FSO, FText, NewFText		
		'Неспециализированные переменные.
		'TeString - вычитываем в нее строку из файла.
		Dim TeString

		Set FSO = CreateObject("Scripting.FileSystemObject")
		Set FText = FSO.OpenTextFile(oMessage.FileName,1) 'Открываем файл для чтения.

		TeString = ""
		NewFText = ""
		Do Until FText.AtEndOfStream 'Пока не доберемся до последней строки файла, будем повторять.
			TeString  = FText.ReadLine() & VbCrLf 'Вычитали одну строку и добавили к ней символы возврата каретки и перевода строки.
			NewFText = NewFText & TeString

			If InStr(TeString,lstHeadLine) <> 0 Then 'Добрались до последней строки заголовка письма? Значить пришло время проверить отступ перед "телом" письма.
				TeString  = FText.ReadLine() & VbCrLf
				If TeString <> "" & VbCrLf Then 'Если строка оказалась не пустой.
					NewFText = NewFText & VbCrLf & TeString 'Добавим перед ней пустую (перевод строки)
				Else
					NewFText = NewFText & TeString
				End If
			End If			
		Loop
		
		FText.Close 'Закрываем файл, чтобы ниже переоткрыть его для записи.
			
		Set FText = FSO.OpenTextFile(oMessage.FileName,2)
		FText.Write NewFText
		FText.Close 'Завершая работу освобождаем файл.
	End If
	
   End Sub

'   Sub OnDeliveryStart(oMessage)
'   End Sub

'   Sub OnDeliverMessage(oMessage)
'   End Sub

'   Sub OnBackupFailed(sReason)
'   End Sub

'   Sub OnBackupCompleted()
'   End Sub

'   Sub OnError(iSeverity, iCode, sSource, sDescription)
'   End Sub

'   Sub OnDeliveryFailed(oMessage, sRecipient, sErrorMessage)
'   End Sub

'   Sub OnExternalAccountDownload(oMessage, sRemoteUID)
'   End Sub