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
	'����� ����������� ������������� ������ �� Rubytech Media Converter Rack � ���������                 '
	'� ��� ����������� ������ ������, ������� (�� ���������) ������ ���������� ����� ���������� '
	'������ �� ��� ���������.                                                                   '
	'*******************************************************************************************'
	'���������� - �������� ���������� ������� �� ���������: ��� ������ �������� � ��� ��������� ��������� � ���������� ���������� ������.
	Const Sender = "Media Converter Rack", lstHeadLine = "Subject:"	

	If oMessage.From = Sender Then '�� ������� �� ������?
		'���������� ��� ������ � �������� ��������.
		'FSO - ����. ������, �������� ��� ������ � ������� � �������
		'FText - ������-��������� ����� (����� - ��������� ����), ��� �������� ������ � ����� � ����.
		'NewFText - ������, ����� ���������� ��� ������ ������ (���������� �����).
		Dim FSO, FText, NewFText		
		'�������������������� ����������.
		'TeString - ���������� � ��� ������ �� �����.
		Dim TeString

		Set FSO = CreateObject("Scripting.FileSystemObject")
		Set FText = FSO.OpenTextFile(oMessage.FileName,1) '��������� ���� ��� ������.

		TeString = ""
		NewFText = ""
		Do Until FText.AtEndOfStream '���� �� ��������� �� ��������� ������ �����, ����� ���������.
			TeString  = FText.ReadLine() & VbCrLf '�������� ���� ������ � �������� � ��� ������� �������� ������� � �������� ������.
			NewFText = NewFText & TeString

			If InStr(TeString,lstHeadLine) <> 0 Then '��������� �� ��������� ������ ��������� ������? ������� ������ ����� ��������� ������ ����� "�����" ������.
				TeString  = FText.ReadLine() & VbCrLf
				If TeString <> "" & VbCrLf Then '���� ������ ��������� �� ������.
					NewFText = NewFText & VbCrLf & TeString '������� ����� ��� ������ (������� ������)
				Else
					NewFText = NewFText & TeString
				End If
			End If			
		Loop
		
		FText.Close '��������� ����, ����� ���� ����������� ��� ��� ������.
			
		Set FText = FSO.OpenTextFile(oMessage.FileName,2)
		FText.Write NewFText
		FText.Close '�������� ������ ����������� ����.
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