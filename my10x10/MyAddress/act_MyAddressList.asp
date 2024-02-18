<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.Buffer = True
Response.CharSet = "UTF-8"

'####################################################
' Description : 나의 주소록 내용 접수 (Ajax-XML)
' History : 2014-12-09 허진원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/orderCls/clsMyAddress.asp" -->
<%
''방식변경.20180219
if (GetEncLoginUserID="") then
    dbget.close()
    response.end
end if

Dim i
Dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))	'페이지사이즈
Dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))	'페이지
Dim sCrtCd		: sCrtCd = requestCheckVar(request("ctrCd"),2)				'지역코드
Dim sDiv		: sDiv = requestCheckVar(request("div"),3)					'구분 ('':내주소록, OLD:과거배송지)

if PageSize="" then PageSize="10"
if CurrPage="" then CurrPage="1"

Dim obj	: Set obj = new clsMyAddress
obj.CurrPage	= CurrPage

obj.GetList_New sCrtCd, sDiv , "3" , PageSize

if (obj.TotalCount<1) then
    set obj = Nothing
    dbget.close()
    response.end
end if

'// 결과 XML로 출력
Dim objXML, objCont
Set objXML = server.CreateObject("Microsoft.XMLDOM")
	objXML.async = False

	 '----- XML 해더 생성
	objXML.appendChild(objXML.createProcessingInstruction("xml","version=""1.0"""))
	objXML.appendChild(objXML.createElement("myAddress"))

	 '-----프로세스 시작
	For i = 1 To UBound(obj.Items)
		Set objCont = objXML.createElement("item")
			'Element 선언
			objCont.appendChild(objXML.createElement("countryCd"))
			objCont.appendChild(objXML.createElement("place"))
			objCont.appendChild(objXML.createElement("name"))
			objCont.appendChild(objXML.createElement("hp"))
			objCont.appendChild(objXML.createElement("tel"))
			objCont.appendChild(objXML.createElement("email"))
			objCont.appendChild(objXML.createElement("zip"))
			objCont.appendChild(objXML.createElement("addr1"))
			objCont.appendChild(objXML.createElement("addr2"))
			objCont.appendChild(objXML.createElement("emsCd"))
			objCont.appendChild(objXML.createElement("countyNmKr"))
			objCont.appendChild(objXML.createElement("countyNmEn"))

			'CData 타입정의
			objCont.childNodes(1).appendChild(objXML.createCDATASection("place_Cdata"))
			objCont.childNodes(2).appendChild(objXML.createCDATASection("name_Cdata"))
			objCont.childNodes(3).appendChild(objXML.createCDATASection("hp_Cdata"))
			objCont.childNodes(4).appendChild(objXML.createCDATASection("tel_Cdata"))
			objCont.childNodes(5).appendChild(objXML.createCDATASection("email_Cdata"))
			objCont.childNodes(6).appendChild(objXML.createCDATASection("zip_Cdata"))
			objCont.childNodes(7).appendChild(objXML.createCDATASection("addr1_Cdata"))
			objCont.childNodes(8).appendChild(objXML.createCDATASection("addr2_Cdata"))
			objCont.childNodes(10).appendChild(objXML.createCDATASection("cNmK_Cdata"))
			objCont.childNodes(11).appendChild(objXML.createCDATASection("cNmE_Cdata"))

			'Data
			objCont.childNodes(0).text = trim(obj.Items(i).countryCode)
			objCont.childNodes(1).childNodes(0).text = trim(obj.Items(i).reqPlace)
			objCont.childNodes(2).childNodes(0).text = trim(obj.Items(i).reqName)
			objCont.childNodes(3).childNodes(0).text = trim(obj.Items(i).reqHp)
			objCont.childNodes(4).childNodes(0).text = trim(obj.Items(i).reqPhone)
			objCont.childNodes(5).childNodes(0).text = trim(obj.Items(i).reqEmail)
			objCont.childNodes(6).childNodes(0).text = trim(obj.Items(i).reqZipcode)
			objCont.childNodes(7).childNodes(0).text = trim(obj.Items(i).reqZipaddr)
			objCont.childNodes(8).childNodes(0).text = trim(obj.Items(i).reqAddress)
			objCont.childNodes(9).text = trim(obj.Items(i).emsAreaCode)
			objCont.childNodes(10).childNodes(0).text = trim(obj.Items(i).countryNameKr)
			objCont.childNodes(11).childNodes(0).text = trim(obj.Items(i).countryNameEn)

			objXML.documentElement.appendChild(objCont.cloneNode(True))
		Set objCont = Nothing
	Next

	'----- 생성된 내용 출력
	Response.ContentType = "text/xml"
	Response.Write(objXML.xml)
 '-----객체 해제
Set objXML = Nothing

Set obj = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->