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
'* ������ ������ ������� � ������ ������������� ������� ���������,
'* ������������� �� � ���������� ����� ������. ��� ��������� (����������� � �������) �������� �� ������� �����������/�������������.
'* ��� Windows XP, Vista, 7 x86-only.
'* �������� ���������, ��� ����� � �������������, � ����� ������ ������� �� ������� ������������� �������� ����������� ����.
'* ������ ��������� �� TightVNC ��� �������� �� ������ 2.0.2 � 2.5.2.
'* �������� ������ ���� ������ ��������� ����������� � ������� "Setup.exe", � ����� ���� � ������� "Blabla.msi".
'* ���� �� �������������!
'*************************************************************************************************************************************************************

Const Compname = ".", HKLM = &H80000002, _
AppName = "TightVNC 2.0.2", _
newAppDistr = "tightvnc-2.5.2-setup-32bit.msi", _
regBaseKey = "Software\Microsoft\Windows\CurrentVersion\Uninstall\"

Dim objReg, wshShell, tightUninst, colSubKeys, strSubKey, regAppName, strUninstall, FSO, Fscript

'������������� � ����� � ����� ���������, ��� �� ���� ��������� ��������� ��������� �� ��� �� �����
Set FSO = CreateObject("Scripting.FileSystemObject")
Set Fscript = FSO.GetFile(Wscript.ScriptFullName)

If FSO.FileExists(Fscript.ParentFolder.Path & "\" & newAppDistr) Then
	'���������� ������������ ���� DEFAULT, � ��� ��������� ����� StdRegProv
	Set objReg = GetObject("winmgmts:\\" & Compname & "\Root\DEFAULT:StdRegProv")
	'������������� � WSH_Shell'� ��� ������������ ������ � �������� (����� - ������ Uninstall ������� ��� <AppName>)
	Set wshShell = CreateObject("WScript.Shell")

	objReg.EnumKey HKLM, regBaseKey, colSubKeys
	If IsEmpty(colSubKeys) Or IsNull(colSubKeys) Then
		Wscript.Echo "�������." & vbCrLf & "������ " & regBaseKey & "� ������� ������." & vbCrLf & "����� ������ Windows."
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
		Wscript.Echo AppName & " �� ������� � ""��������� � �������� ��������.""" & vbCrLf & "��������� �������� ��������� AppName � ������� � �������� ��������� � ������ �������������." & vbCrLf & "� ����� � � ������ ���������."
	Else

'=======================================
'����� ����� �������� �������� ��������� ����, � �� �� ���, �� ��������� �� ��� ����� ������, � ������ ����� �����
'����� Enter. ������, �������� �� ����� ���� ����� ���������� VBScript ������ ����������?
'=======================================	
'��������� �������� ���������� � ������� ��� ������������� �����������
		Set tightUninst = wshShell.Exec(strUninstall)
		WScript.Sleep 7000	'������ �� �������? �� ����, ����� �����
		wshShell.AppActivate(tightUninst.ProcessID)
	
'������������� ������������������ ������� ������ ��� ������� �������� ������� TightVNC (��� ������� ����������� - ���� ������������������!)
		wshShell.SendKeys "{ENTER}"
		WScript.Sleep 5000	'����� ������, ������, �����
		wshShell.AppActivate(tightUninst.ProcessID)
		wshShell.SendKeys "{ENTER}"
		WScript.Sleep 3000
		wshShell.AppActivate(tightUninst.ProcessID) '��� ������ ��� � ���� ����������� ��� ���������� ������ ���� :)
		wshShell.SendKeys "{ENTER}"
'��� - ����� �������

'������������� ����������� ������	
		wshShell.Exec("msiexec.exe /package """ & Fscript.ParentFolder.Path & "\" & newAppDistr & """ /quiet /norestart")
	End If

Else
	Wscript.Echo "��� ������������ " & newAppDistr & "? ��� �������-��?"
End If
