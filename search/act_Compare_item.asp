<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<%
	Dim sqlStr, gubun, itemid, userid, i, arr, cont, ritemid, loadresult
	dim adultChkFlag

	gubun = requestCheckVar(request("gubun"),10)
	userid = GetLoginUserid()
	itemid	 = requestCheckVar(request("itemid"),50)
	itemid = Replace(itemid, "i", "")
	itemid = Replace(itemid, " ", "")
	
	If itemid <> "" Then
		If Left(itemid,1) = "," Then
			itemid = Right(itemid,Len(itemid)-1)
		End If
		If Right(itemid,1) = "," Then
			itemid = Left(itemid,Len(itemid)-1)
		End If
	End If


	If userid <> "" Then
		If gubun = "count" Then	'### db에 담긴거 카운트
			arr = fnGetCompareItem("count",userid)
			Response.Write arr
		ElseIf gubun = "userload" Then	'### db에 담긴거 리스트
			arr = fnGetCompareItem("list",userid)
			
			if IsArray(arr) then
				For i =0 To UBound(arr,2)
					if i > 0 then
						ritemid = ritemid & ","
					end if
					ritemid = ritemid & "i" & arr(0,i) & "i"


					adultChkFlag = session("isAdult") <> true and arr(2,i) = 1																									

					cont = cont & "<li id=""compareitem"&arr(0,i)&"""><div class=""thumbnail"">"
					if adultChkFlag then
						cont = cont & "<img src=""http://fiximage.10x10.co.kr/m/2019/common/img_adult_300.gif"" alt="""" /></div>"
					Else
						cont = cont & "<img src=""http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(arr(0,i)) & "/" & arr(1,i) &""" alt="""" /></div>"
					end if				
					
					cont = cont & "<button type=""button"" class=""btn-del"" onclick=""jsCompareItem('set','"&arr(0,i)&"');"">삭제</button></li>"
				Next
				
				loadresult = ritemid & "$$" & cont
			end if
		
			Response.Write loadresult
			
		ElseIf gubun = "reset" then	'### db에 담긴거 지우고 받아온거 저장
			If itemid <> "" Then
				sqlStr = "delete db_my10x10.dbo.tbl_my_itemCompare where userid = '"&userid&"';"
				For i = LBound(Split(itemid,",")) To UBound(Split(itemid,","))
					If Split(itemid,",")(i) <> "" Then
						sqlStr = sqlStr & "insert into db_my10x10.dbo.tbl_my_itemCompare(userid, itemid) values('"&userid&"', '" & Split(itemid,",")(i) & "');"
					End If
				Next
				dbget.Execute sqlStr

			End If
		ElseIf gubun = "del" then	'### 아에 삭제
				sqlStr = "delete db_my10x10.dbo.tbl_my_itemCompare where userid = '"&userid&"';"
				dbget.Execute sqlStr
		End IF
	End If
	
	If gubun = "load" Then	'### 로그인안했을때 상품저장되있을때 기본 셋팅.
		cont = ""
		ritemid = ""
		loadresult = ""
		
		If itemid <> "" Then

			
			arr = fnGetCompareItem("load",itemid)
			if IsArray(arr) then
				For i =0 To UBound(arr,2)
					if i > 0 then
						ritemid = ritemid & ","
					end if
					ritemid = ritemid & "i" & arr(0,i) & "i"
					
					adultChkFlag = session("isAdult") <> true and arr(2,i) = 1																									

					cont = cont & "<li id=""compareitem"&arr(0,i)&"""><div class=""thumbnail"">"
					if adultChkFlag then
						cont = cont & "<img src=""http://fiximage.10x10.co.kr/m/2019/common/img_adult_300.gif"" alt="""" /></div>"
					Else
						cont = cont & "<img src=""http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(arr(0,i)) & "/" & arr(1,i) &""" alt="""" /></div>"
					end if
					cont = cont & "<button type=""button"" class=""btn-del"" onclick=""jsCompareItem('set','"&arr(0,i)&"');"">삭제</button></li>"
				Next
				
				loadresult = ritemid & "$$" & cont
				
				
				'### 로그인 했을때 새로운걸로 덮어 씌움.
				If userid <> "" Then
					sqlStr = "delete db_my10x10.dbo.tbl_my_itemCompare where userid = '"&userid&"';"
					For i =0 To UBound(arr,2)
						sqlStr = sqlStr & "insert into db_my10x10.dbo.tbl_my_itemCompare(userid, itemid) values('"&userid&"', '"&arr(0,i)&"');"
					Next
					dbget.Execute sqlStr
				End If
			end if
		
			Response.Write loadresult
		End If
	End If
	
	If gubun = "statistic" then	'### 비교버튼 클릭 로그 저장
		If itemid <> "" Then
			If userid = "" Then
				userid = "guest"
			End If
			dim nowtime
			sqlStr = ""
			nowtime = date() & " " & TwoNumber(hour(now)) & ":" & TwoNumber(minute(now)) & ":" & TwoNumber(second(now)) & "." & right("000" & (timer * 1000) Mod 1000, 3)
			For i = LBound(Split(itemid,",")) To UBound(Split(itemid,","))
				If Split(itemid,",")(i) <> "" Then
					sqlStr = sqlStr & "insert into db_log.dbo.tbl_item_Compare_log(itemid,userid,regdate) values('" & Split(itemid,",")(i) & "','"&userid&"','"&nowtime&"');"
				End If
			Next
			dbget.Execute sqlStr

		end if
	End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->