<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbAppNotiopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 소식 리스트
' History : 2015.01.14 서동석 추가
'			2019.04.19 한용민 수정
'####################################################

dim pid : pid = requestCheckvar(request("pid"),200)

''test
''pid = "APA91bEJZeXBkvqEuejQv0n9IcRx3xtfOZ7H3_AqTVbfK7CLkHlSSNbkVN-8QgqCJqLIBEZ5HfZ82yxA3tXqLTXD05dBV2PnxFKFHxOrY7r4w9dODwaqQvzqanaIqPtvJEdM6n_WXdJAQT5h4RAKGgDCqj_jKOp_Vg"

dim sqlStr, ArrRows, RowCnt, i 
sqlStr = "exec db_AppNoti.dbo.sp_Ten_getAppHisRecentNotiList '"&pid&"'"

if pid<>"" then
    rsAppNotiget.Open sqlStr,dbAppNotiget,1
    if Not rsAppNotiget.Eof then
        ArrRows = rsAppNotiget.getRows
    end if
    rsAppNotiget.Close
end if

RowCnt = 0
if isArray(ArrRows) then
    RowCnt = UBound(ArrRows,2)+1
end if

dim multipskey,sendmsg,resultdate,diffmin,pos1,pos2
dim notititle,notitime,notiurl,noticolor, isOrderPop, noticontents
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
			<h1 class="hide">소식</h1>
			
			<% if RowCnt<1 then %>
			<div class="noDataBox" style="padding:70px 0;">
				<p class="noDataMark"><span>!</span></p>
				<p class="tPad05">최근 받은 소식이 없습니다.</p>
			</div>
			<% else %>
			<ul class="alramList">
			<% for i=0 to RowCnt-1 %>
			<%
				multipskey  = ArrRows(0,i)
				sendmsg     = ArrRows(1,i)
				resultdate  = ArrRows(2,i)
				diffmin     = ArrRows(3,i)

				notiurl =""
				notitime =""
				noticolor =""
				isOrderPop = false

				pos1 = InStr(sendmsg,"{""title"":""")
					if (pos1>0) then 
							pos1=pos1+LEN("{""title"":""")
							pos2=InStr(MID(sendmsg,pos1,1024),"""")
							if (pos2>0) then
									notititle = Mid(sendmsg,pos1,pos2-1)
							else
								notititle=""
							end if
					else
						notititle=""
					end if

					pos1 = InStr(sendmsg,"""noti"":""")
					if (pos1>0) then 
							pos1=pos1+LEN("""noti"":""")
							pos2=InStr(MID(sendmsg,pos1,1024),"""")
							if (pos2>0) then
									noticontents = replace(Mid(sendmsg,pos1,pos2-1),"\n","<br>")
							else
								noticontents=""
							end if
					else
						noticontents=""
					end if

					pos1 = InStr(sendmsg,"""url"":""")
					if (pos1>0) then 
							pos1=pos1+LEN("""url"":""")
							pos2=InStr(MID(sendmsg,pos1,1024),"""")
							if (pos2>0) then
									notiurl = Mid(sendmsg,pos1,pos2-1)
							end if
					end if
	
					if (diffmin>=1440) then
							notitime = MID(resultdate,6,2)&"월 "&MID(resultdate,9,2)&"일"
					elseif (diffmin>=60) then
							notitime = CLNG(diffmin/60)&"시간 전"
					elseif (diffmin>1) then
							notitime = diffmin&"분 전"
					elseif (diffmin<1) then
							notitime = "방금 전"
					end if
					
				if (multipskey>0) then
						noticolor = cStr("alram01")
				else
						if InStr(notititle,"상품이 출고")>0 then
								noticolor = cStr("alram02")
								isOrderPop = true
						else
								noticolor = cStr("alram03")
						end if
				end if
			%>
			<% if (notiurl<>"") then %>
			    <%
			    ''2016/11/10
			    notiurl = replace(notiurl,"gaparam=push_","gaparam=pushlist_")
			    %>
				<% if (isOrderPop) then %>
					<li class="<%=noticolor%>">
						<a href="#" onClick="fnAPPpopupBrowserURL('주문배송','<%=notiurl%>','','order');">
							<div>
								<p><%=chkiif(notititle="",noticontents,notititle & "<br>" & noticontents)%></p>
								<% if (notitime<>"") then %>
									<span><%= notitime%></span>
								<% end if %>
							</div>
						</a>
					</li>
				<% else %>
					<li class="<%=noticolor%>">
						<a href="#" onClick="fnAPPpopupBrowserURL('이벤트','<%=notiurl%>','','event');">
							<div>
								<p><%=chkiif(notititle="",noticontents,notititle & "<br>" & noticontents)%></p>
								<% if (notitime<>"") then %>
									<span><%= notitime%></span>
								<% end if %>
							</div>
						</a>
					</li>
				<% end if %>
			<% else %>
					<li class="<%=noticolor%>">
						<div>
							<p><%=chkiif(notititle="",noticontents,notititle & "<br>" & noticontents)%></p>
							<% if (notitime<>"") then %>
								<span><%= notitime%></span>
							<% end if %>
						</div>
					</li>
			<% end if %>
			<% next %>
			</ul>
		<% end if %>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbAppNoticlose.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->