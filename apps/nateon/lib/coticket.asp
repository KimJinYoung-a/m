<script runat="server" language="jscript">
	function UnixTime()
	{
		return Math.floor(new Date().getTime()/1000);
	}
</script><%
'------------------------------------------------------------------
' When : 2009-04-16 3:00:33
' Writer : Lim, Dong-moon
' Organazation : SK Communications
' E-Mail : dmlim@nate.com
'------------------------------------------------------------------

Const CAPICOM_ENCODE_BASE64 = 0
Const CAPICOM_ENCODE_BINARY = 1
Const CAPICOM_ENCODE_ANY = -1

Const CAPICOM_ENCRYPTION_ALGORITHM_RC2 = 0
Const CAPICOM_ENCRYPTION_ALGORITHM_RC4 = 1
Const CAPICOM_ENCRYPTION_ALGORITHM_DES = 2
Const CAPICOM_ENCRYPTION_ALGORITHM_3DES = 3
Const CAPICOM_ENCRYPTION_ALGORITHM_AES = 4

Const CAPICOM_ENCRYPTION_KEY_LENGTH_MAXIMUM = 0
Const CAPICOM_ENCRYPTION_KEY_LENGTH_40_BITS = 1
Const CAPICOM_ENCRYPTION_KEY_LENGTH_56_BITS = 2
Const CAPICOM_ENCRYPTION_KEY_LENGTH_128_BITS = 3
Const CAPICOM_ENCRYPTION_KEY_LENGTH_192_BITS = 4
Const CAPICOM_ENCRYPTION_KEY_LENGTH_256_BITS = 5

Function EncodeBase64URI(ByVal data)

	data = Replace(data, "+", "-")
	data = Replace(data, "/", "_")
	data = Replace(data, "=", "")
	data = Replace(data, chr(10), "")
	data = Replace(data, chr(13), "")
	
	EncodeBase64URI = data

End Function

Function DecodeBase64URI(ByVal data)

	Select Case Len(data) Mod 4

		Case 2
			data = data & "=="
		Case 3
			data = data & "="
	End Select
	
	data = Replace(data, "-", "+")
	data = Replace(data, "_", "/")

	DecodeBase64URI = data

End Function


Function CAPICOM_Encrypt(ByVal password, ByVal data)

	Dim objEncData
	Set objEncData = Server.CreateObject("CAPICOM.EncryptedData")

	objEncData.Algorithm.Name = CAPICOM_ENCRYPTION_ALGORITHM_AES
	objEncData.Algorithm.KeyLength = CAPICOM_ENCRYPTION_KEY_LENGTH_128_BITS
	objEncData.SetSecret(password)
	objEncData.Content = data
	CAPICOM_Encrypt = EncodeBase64URI(objEncData.Encrypt())

	Set objEncData = Nothing

End Function

Function CAPICOM_Decrypt(ByVal password, ByVal data)

	Dim objEncData
	Set objEncData = Server.CreateObject("CAPICOM.EncryptedData")

	objEncData.SetSecret(password)
	objEncData.Decrypt DecodeBase64URI(data)
	CAPICOM_Decrypt = objEncData.Content

	Set objEncData = Nothing

End Function

'Function UnixTime()
'	UnixTime = DateDiff("s", "01/01/1970 00:00:00", now())
'End Function

Function EncodeParam(ByVal param)
	param = Replace(param, "%", "%25")
	param = Replace(param, "=", "%3d")
	param = Replace(param, "&", "%26")
	EncodeParam = param
End Function

Function DecodeParam(ByVal param)
	param = Replace(param, "%3d", "=")
	param = Replace(param, "%26", "&")
	param = Replace(param, "%25", "%")
	DecodeParam = param
End Function

Class CoTicket

	Dim Dictionary

	Private Sub Class_Initialize()
		Set Dictionary = Server.CreateObject("Scripting.Dictionary")
	End Sub
	
	Private Sub Class_Terminate()
		Set Dictionary = Nothing
	End Sub
	
	Public Default Property Get Item(k)
		Item = Dictionary.Item(k)
	End Property
	
	Public Property Let Item(k, v)
		Dictionary.Item(k) = v
	End Property
	
	Public Property Get Key(k)
		Key = Dictionary.Key(k)
	End Property
	
	Public Property Let Key(k, v)
		Dictionary.Key(k) = v
	End Property

	Public Property Get Count
		Count = Dictionary.Count
	End Property
	
	Public Function Items
		Items = Dictionary.Items
	End Function
	
	Public Function Keys
		Keys = Dictionary.Keys
	End Function
	
	Public Function Exists(k)
		Exists = Dictionary.Exists(k)
	End Function
	
	Public Function Remove(k)
		Remove = Dictionary.Remove(k)
	End Function

	Public Function RemoveAll()
		RemoveAll = Dictionary.RemoveAll()
	End Function

	Public Function Add(k, v)
		Add = Dictionary.Add(k, v)
	End Function
		
	Public Function GetTicket(password, timeout_sec)
		Dim merged, key, i
		Dictionary.Item("utcexpire") = UnixTime() + timeout_sec
		For Each key in Dictionary.Keys()
			If Len(merged) > 0 Then
				merged = merged & "&"
			End If
			merged = merged & EncodeParam(key) & "=" & EncodeParam(Dictionary(key))
		Next
		GetTicket = CAPICOM_Encrypt(password, merged)
	End Function
	
	Public Function SetTicket(password, ticket)
		Dim keyValArr, keyVal, i, utcexpire

		keyValArr = Split(CAPICOM_Decrypt(password, ticket), "&")

		For i = LBound(keyValArr) to UBound(keyValArr)
			keyVal = Split(keyValArr(i), "=")
			If UBound(keyVal) >= 1 Then
				Dictionary(DecodeParam(keyVal(0))) = DecodeParam(keyVal(1))
			ElseIf UBound(keyVal) >= 0 Then
				Dictionary(DecodeParam(keyVal(0))) = ""
			End If
		Next
		
		utcexpire = Dictionary("utcexpire")
		
		If utcexpire = "" Then
			SetTicket = False
			Dictionary.RemoveAll
			Exit Function
		End If
		
		'Response.Write utcexpire & ", " & UnixTime() & "," & now() & "<br>"
		
		If CLng(utcexpire) < UnixTime() Then
			SetTicket = False
			Dictionary.RemoveAll
			Exit Function
		End If
		
		SetTicket = True		
	End Function
	
	Public Sub PrintItems
		Dim key
		Response.Write "<table style='font-family:verdana; font-size:9pt;' cellpadding=3 cellspacing=0 border=1>"
		For Each key in Dictionary.Keys()
			Response.Write "<tr><td>" & Server.HTMLEncode(key) & "</td><td>" & Server.HTMLEncode(Dictionary(key)) & "</td></tr>"
		Next
		Response.Write "</table>"
	End Sub
	
End Class
%>
