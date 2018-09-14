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

'*************************************************************************************************************************************************************
'* Данный скрипт находит в списке установленных целевую программу,
'* деинсталирует ее и накатывает новую версию. Все настройки (сохраненные в реестре) остаются на совести установщика/деинсталятора.
'* Для Windows XP, Vista, 7 x86-only.
'* Название программы, имя файла с дистрибутивом, а также раздел реестра со списком установленных программ указываются ниже.
'* Скрипт опробован на TightVNC при переходе от версии 2.0.2 к 2.5.2.
'* Работает только если старая программа установлена с помощью "Setup.exe", а новая идет в формате "Blabla.msi".
'* ИНОЕ НЕ ТЕСТИРОВАЛОСЬ!
'*************************************************************************************************************************************************************

Const Compname = ".", HKLM = &H80000002, _
AppName = "TightVNC 2.0.2", _
newAppDistr = "tightvnc-2.5.2-setup-32bit.msi", _
regBaseKey = "Software\Microsoft\Windows\CurrentVersion\Uninstall\"

Dim objReg, wshShell, tightUninst, colSubKeys, strSubKey, regAppName, strUninstall, FSO, Fscript

'Привязываемся к файлу с нашим сценарием, что бы ниже запустить установку программы из той же папки
Set FSO = CreateObject("Scripting.FileSystemObject")
Set Fscript = FSO.GetFile(Wscript.ScriptFullName)

If FSO.FileExists(Fscript.ParentFolder.Path & "\" & newAppDistr) Then
	'Подключаем пространство имен DEFAULT, в нем находится класс StdRegProv
	Set objReg = GetObject("winmgmts:\\" & Compname & "\Root\DEFAULT:StdRegProv")
	'Привязываемся к WSH_Shell'у для элементарной работы с реестром (здесь - чтение Uninstall строчки для <AppName>)
	Set wshShell = CreateObject("WScript.Shell")

	objReg.EnumKey HKLM, regBaseKey, colSubKeys
	If IsEmpty(colSubKeys) Or IsNull(colSubKeys) Then
		Wscript.Echo "Странно." & vbCrLf & "Раздел " & regBaseKey & "в реестре пустой." & vbCrLf & "Какой хитрый Windows."
	Else
		For Each strSubKey in colSubKeys
			objReg.GetStringValue HKLM, regBaseKey & strSubKey, "DisplayName", regAppName
			If regAppName = AppName Then
				objReg.GetStringValue HKLM, regBaseKey & strSubKey, "UninstallString", strUninstall
				Exit For
			End If
		Next
	End If

	If IsEmpty(strUninstall) Or IsNull(strUninstall) Then
		Wscript.Echo AppName & " не найдена в ""Установке и удалении программ.""" & vbCrLf & "Проверьте значение константы AppName в скрипте и название программы в списке установленных." & vbCrLf & "А можно и в реестр заглянуть."
	Else

'=======================================
'Здесь стоит добавить проверку активного окна, а то ли оно, не выскочило ли там какое лишнее, и только после этого
'слать Enter. Только, выяснить на каком окне фокус средствами VBScript похоже невозможно?
'=======================================	
'Запускаем удаление приложения с помощью его неправильного инсталятора
		Set tightUninst = wshShell.Exec(strUninstall)
		WScript.Sleep 7000	'Лучший ли вариант? Не знаю, пусть будет
		wshShell.AppActivate(tightUninst.ProcessID)
	
'Вытанцовываем последовательность нажатий клавиш для полного удаления старого TightVNC (для каждого инсталятора - своя последовательность!)
		wshShell.SendKeys "{ENTER}"
		WScript.Sleep 5000	'Будем пихать, теперь, везде
		wshShell.AppActivate(tightUninst.ProcessID)
		wshShell.SendKeys "{ENTER}"
		WScript.Sleep 3000
		wshShell.AppActivate(tightUninst.ProcessID) 'Это лучшее чем я смог разродиться для сохранения фокуса окна :)
		wshShell.SendKeys "{ENTER}"
'Все - прога удалена

'Устанавливаем обновленную версию	
		wshShell.Exec("msiexec.exe /package """ & Fscript.ParentFolder.Path & "\" & newAppDistr & """ /quiet /norestart")
	End If

Else
	Wscript.Echo "Нет дистрибутива " & newAppDistr & "? Что ставить-то?"
End If
