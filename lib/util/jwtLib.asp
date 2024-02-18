<%
'// JWT Class 선언
Class cJwt
	public sType
	public sAlgorism

	'// 토큰 생성
	public Function encode(byVal sBody, byVal sKey)
		Dim sEncBody, sSignature, sToken

		sEncBody       = Base64URLEncode(getHeadStr()) & "." & Base64URLEncode(sBody)
		sSignature     = SHA256SignAndEncode(sEncBody, sKey)
		sToken         = sEncBody & "." & sSignature

		encode = sToken
	end Function

	'// 토큰 분해
	public Function decode(byVal sToken, byVal sKey)
		dim sHead, sBody

		'토큰 검증 후 Decoding
		if verify(sToken,sKey) then
			sHead = Base64URLDecode(split(sToken,".")(0))
			sBody = Base64URLDecode(split(sToken,".")(1))
		end if

		decode = sBody
	end Function

	'// 토큰 검증
	public Function verify(byVal sToken, byVal sKey)
		Dim arrBody, sSignature
		verify=false		'Default

		arrBody = split(trim(sToken),".")
		if ubound(arrBody)<2 then
			exit function
		end if

		'대상코드 암호화
		sSignature     = SHA256SignAndEncode(arrBody(0)&"."&arrBody(1), sKey)

		'대상과 검증코드 비교
		if arrBody(2)=sSignature then
			verify = true
		end if

		'토큰 만료시간 검사
		if verify then
			dim psJson, exptime
			set psJson = JSON.parse(Base64URLDecode(arrBody(1)))
			exptime = psJson.exp
			set psJson = Nothing

			if exptime<SecsSinceEpoch then
				verify = false
			end if
		end if

	end Function

	'// 헤더 생성
	function getHeadStr()
		dim oJson
		set oJson = jsObject()
			oJson("typ") = "JWT"
			oJson("alg") = "HS256"
		getHeadStr = oJson.jsString
		set oJson = Nothing
	end function

	Private Sub Class_Initialize()
		sType = "JWT"
		sAlgorism = "HS256"
	End Sub

	Private Sub Class_Terminate()
	End Sub

end Class


'// Base64 URL Encode
Function Base64URLEncode(sStr)
  Base64URLEncode = Base64ToSafeBase64(Base64Encode(sStr))
End Function

'// Base64 URL Decode
Function Base64URLDecode(sStr)
   sStr = replace(sStr,"-", "+")
   sStr = replace(sStr,"_", "/")

   select case (len(sStr) mod 4)
      case 0: sStr = sStr
      case 2: sStr = sStr +"=="
      case 3: sStr = sStr +"="
      case else:  sStr = ""
   end select

   Base64URLDecode = Base64Decode(sStr)
End function


'// Base64 Safety Convert
Function Base64ToSafeBase64(sIn)
  dim sOut
  sOut = Replace(sIn,"+","-")
  sOut = Replace(sOut,"/","_")
  sOut = Replace(sOut,"\r","")
  sOut = Replace(sOut,"\n","")
  sOut = Replace(sOut,"=","")

  Base64ToSafeBase64 = sOut
End Function


' Returns the number of seconds since epoch
Function SecsSinceEpoch()
  SecsSinceEpoch = DateDiff("s", "01/01/1970 00:00:00", dtmAdjusted_date())
End Function

' Returns a random string to prevent replays
Function UniqueString()
  dim TypeLib
  Set TypeLib = CreateObject("Scriptlet.TypeLib")
    UniqueString = Left(CStr(TypeLib.Guid), 38)
    UniqueString = replace(replace(UniqueString,"{",""),"}","")
    Set TypeLib = Nothing
End Function

Function dtmAdjusted_date()
  Dim dtmDateValue, dtmAdjusted
  Dim objShell, lngBiasKey, lngBias, k

  dtmDateValue = Now()

  ' Obtain local Time Zone bias from machine registry.
  Set objShell = CreateObject("Wscript.Shell")
  lngBiasKey = objShell.RegRead("HKLM\System\CurrentControlSet\Control\" _
      & "TimeZoneInformation\ActiveTimeBias")
  If (UCase(TypeName(lngBiasKey)) = "LONG") Then
      lngBias = lngBiasKey
  ElseIf (UCase(TypeName(lngBiasKey)) = "VARIANT()") Then
      lngBias = 0
      For k = 0 To UBound(lngBiasKey)
          lngBias = lngBias + (lngBiasKey(k) * 256^k)
      Next
  End If

  ' Convert datetime value to UTC.
  dtmAdjusted = DateAdd("n", lngBias, dtmDateValue)
  dtmAdjusted_date = dtmAdjusted

End Function


' SHA256 HMAC
Function SHA256SignAndEncode(sIn, sKey)
  Dim sSignature, sha256

  'Open WSC object to access the encryption function
  Set sha256 = GetObject("script:"&Server.MapPath("/lib/util/sha256.wsc"))

  'SHA256 sign data
  sSignature = sha256.b64_hmac_sha256(sKey, sIn)
  sSignature = Base64ToSafeBase64(sSignature)

  SHA256SignAndEncode = sSignature
End Function
%>