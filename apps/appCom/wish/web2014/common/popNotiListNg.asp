<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbAppNotiopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/quickSortAdo.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'####################################################
' Description : 소식 리스트 - 넛지용 (인앱 추가 버전)
' History : 2015.01.14 서동석 추가
'####################################################



function fnUTC2LocalTime(iutcTime)
    ''iutcTime like 2015-07-27T09:20:27Z
    dim buf : buf = Trim(iutcTime)
    if (right(buf,1)="Z") then
        buf = replace(LEFT(iutcTime,19),"T"," ")
        buf = dateAdd("n",9*60,buf)
        fnUTC2LocalTime=FormatDateTime(buf,2)&" "&FormatDateTime(buf,4)&":"&Right(FormatDateTime(buf,3),2)
    else
        buf = replace(LEFT(iutcTime,19),"T"," ")
        fnUTC2LocalTime=buf
    end if
    
end function

function fnStuffArray(tnArr,nudArr)
    
    dim retArr, tRowCnt, nRowCnt
    if Not isArray(nudArr) then
        'nudArr = array(nudArr)
        fnStuffArray = tnArr
        exit function
    end if
    
    if Not isArray(tnArr) then
        'tnArr = array(tnArr)
        fnStuffArray = nudArr
        exit function 
    end if

    dim total_size
    tRowCnt = UBound(tnArr,2)
    nRowCnt = UBound(nudArr,2)
    total_size = tRowCnt + nRowCnt +1

    dim merged
    redim merged(5,total_size)
    
    dim counter : counter = 0
    dim xindex, jindex

    for xindex = 0 to ubound(tnArr,2)''-1
        for jindex = 0 to ubound(tnArr,1)''-1
            merged(jindex,counter) = tnArr(jindex,xindex)
            ''response.write merged(jindex,counter)&"<br>"
        next 
        merged(4,counter) = ""
        merged(5,counter) = ""
        counter=counter+1
    next

    for xindex = 0 to ubound(nudArr,2)''-1
        for jindex = 0 to ubound(nudArr,1)''-1
            merged(jindex,counter) = nudArr(jindex,xindex)
        next 
        counter=counter+1
    next


    
    CALL QuickSortADO(merged,0,ubound(merged,2),2,"DESC")
    

    fnStuffArray = merged

    
end function

function fnParseNudgeData_OLD(sData, byref iNDataArr)
    dim i,j,jlen
    dim oResult
    dim MaxNdata : MaxNdata     = 4 '넛지 PUSH 최대 표시 갯수
    dim MaxPreDate : MaxPreDate = 2 '넛지 PUSH 최대 표시 기간(일)
    dim bufTime
    dim msgType
    
    fnParseNudgeData_OLD = false
    if (sData="") then Exit function
    if (sData="[]") then Exit function
        
    set oResult = JSON.parse(sData)
   
    if Not (oResult is Nothing) Then
        jlen = oResult.length
        if (jlen>MaxNdata) then jlen = MaxNdata
            
        reDim iNDataArr(5,jlen)
        j=0
        
        for i=0 to jlen-1
            bufTime = fnUTC2LocalTime(oResult.get(i).display_time)
            '''response.write datediff("d",bufTime,now())&"<br>"
            if (datediff("d",bufTime,now())<=MaxPreDate) then
                iNDataArr(0,j) = -1
                iNDataArr(1,j) = oResult.get(i).title
                iNDataArr(2,j) = bufTime
                iNDataArr(3,j) = datediff("n",CDate(bufTime),now())
                iNDataArr(4,j) = replace(oResult.get(i).deep_link,"tenwishapp://","")
                iNDataArr(5,j) = oResult.get(i).token ''replace(oResult.get(i).token,"""","\""")
                iNDataArr(5,j) = server.urlencode(iNDataArr(5,j))
                
                'msgType = oResult.get(i).sdk_data.ad_impression.message_type
                
                'response.write iNDataArr(1,j)
                'response.write fnUTC2LocalTime(oResult.get(i).display_time) &"|"
                
                'multipskey  = ArrRows(0,i)
				'sendmsg     = ArrRows(1,i)
				'resultdate  = ArrRows(2,i)
				'diffmin     = ArrRows(3,i)
				
                j=j+1
            end if
        next
        redim preserve iNDataArr(5,j-1)
        fnParseNudgeData_OLD = true
    end if
    set oResult = Nothing
end function

function fnParseNudgeData(sData, byref iNDataArr)
    dim i,j,jlen
    dim oResult
    dim MaxNdata : MaxNdata     = 4 '넛지 PUSH 최대 표시 갯수
    dim MaxPreDate : MaxPreDate = 2 '넛지 PUSH 최대 표시 기간(일)
    dim bufTime
    dim sdk_data,parse2, msgType
    
    fnParseNudgeData = false
    if (sData="") then Exit function
    if (sData="[]") then Exit function
        
    set oResult = JSON.parse(sData)
   
    if Not (oResult is Nothing) Then
        jlen = oResult.length
        if (jlen>MaxNdata) then jlen = MaxNdata
            
        reDim iNDataArr(5,jlen)
        j=0
        
        for i=0 to jlen-1
            bufTime = fnUTC2LocalTime(oResult.get(i).display_time)
            '''response.write datediff("d",bufTime,now())&"<br>"
            if (datediff("d",bufTime,now())<=MaxPreDate) then
                iNDataArr(0,j) = -1
                iNDataArr(1,j) = oResult.get(i).title
                iNDataArr(2,j) = bufTime
                iNDataArr(3,j) = datediff("n",CDate(bufTime),now())
                iNDataArr(4,j) = replace(oResult.get(i).deep_link,"tenwishapp://","")
                iNDataArr(5,j) = oResult.get(i).token ''replace(oResult.get(i).token,"""","\""")
                iNDataArr(5,j) = server.urlencode(iNDataArr(5,j))
                
                sdk_data = oResult.get(i).sdk_data '.ad_impression.message_type
                msgType = ""
                if (sdk_data<>"") then
                    set parse2 = JSON.parse(sdk_data)
                    msgType = parse2.ad_impression.message_type
                    set parse2 = Nothing
                end if
                
                if (msgType="in_app") then
                    iNDataArr(4,j) = msgType
                end if
                'response.write iNDataArr(1,j)
                'response.write fnUTC2LocalTime(oResult.get(i).display_time) &"|"
                
                'multipskey  = ArrRows(0,i)
				'sendmsg     = ArrRows(1,i)
				'resultdate  = ArrRows(2,i)
				'diffmin     = ArrRows(3,i)
				
                j=j+1
            end if
        next
        redim preserve iNDataArr(5,j-1)
        fnParseNudgeData = true
    end if
    set oResult = Nothing
end function

dim pid : pid = requestCheckvar(request("pid"),200)
Dim sData : sData = Request("njson")
    
Dim nDataExists : nDataExists = false
Dim iNDataArr
Dim isTestMode  : isTestMode =false

if (pid="APA91bGL7oQYkwCD9NG3xXLAx6z6w8-ueKSFB0ENMHSZvPSSRJmEVqzwVYGs1_M4Rsbftnozyf4lLVj8OMZp1z9yOYwVLpthsV44JrOBQ9zz8iaQfbbnlG_H522OLM5foxa6FbISDzo-") then
    isTestMode =true
    'response.write "<textarea cols=50 rows=10>"&sData&"</textarea>"
    'response.end     
end if

if (pid="a0512c31fb5d59f9e1ae0d0cb3c64fdc83e74ff3ea405c090be8d0602ba3ea5f") then
    isTestMode =true
    'response.write "<textarea cols=50 rows=10>"&sData&"</textarea>"
    'response.end    
end if

On Error Resume Next
    nDataExists = fnParseNudgeData(sData, iNDataArr)
    If Err then nDataExists = false
On Error Goto 0

'if (pid="dcfbb4100fa11ce05446bf736df5ea8b56db5694a34dc72985cc0e7f8796125f") then
'    response.write sData
'end if

'if (pid="APA91bHIqApv8GSMxKTLkbruoFx9P9JR1WuozioOq5Ewpoba2Ysoody2h5_w2mggLFuM3UOZPZEwoJXcwM9zxFF2zc0g2hIMitr4edDlZ82UVGQuQa1EiuBzZeb9bGz6hNYIygm7Asm3") then
'    response.write sData
'end if

''response.write sData

''test
if (application("Svr_Info")="Dev") then
    pid = "APA91bETnAM7DIpp81b1b0s6ELS9sEoe2hi7vPlNySc-_as1YYRryVCztx_UXKtYKED-U8cSxQpCRw3Q5pHYGCtzzSJocmsJxjAkC6tLq0zX8kZyGnmjAAl_YhIzjgi3ez_wQxcHydrVW4eFJYNfdlrqkeH5j7rKuw"
end if

dim sqlStr, ArrRows, TnArrRows, RowCnt, i 
sqlStr = "exec db_AppNoti.dbo.sp_Ten_getAppHisRecentNotiList '"&pid&"'"

if pid<>"" then
    rsAppNotiget.Open sqlStr,dbAppNotiget,1
    if Not rsAppNotiget.Eof then
        TnArrRows = rsAppNotiget.getRows
    end if
    rsAppNotiget.Close
end if


''call PrintArrayADO(TnArrRows,0,ubound(TnArrRows,2),2)

''call PrintArrayADO(iNDataArr,0,ubound(iNDataArr,2),2)

ArrRows = fnStuffArray(TnArrRows,iNDataArr)

''call PrintArrayADO(ArrRows,0,ubound(ArrRows,2),2)

RowCnt = 0
if isArray(ArrRows) then
    RowCnt = UBound(ArrRows,2)+1
end if

dim multipskey,sendmsg,resultdate,diffmin,pos1,pos2
dim notititle,notitime,notiurl,noticolor, isOrderPop
dim isNudgePush, nudgeToken


''response.write "RowCnt="&RowCnt

'dim iARRAy(3)
'dim iarray2(iARRAy(3),2)

'
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script language='javascript'>
function fnShowNudgeCampagin(nudgeToken){
    <% if (isTestMode) then %>
    //alert(nudgeToken);
    <% end if %>
    callNativeFunction('showCampaignNg', {
    	"nudgeToken": nudgeToken
    });
    
    <% if (FALSE) then %>
        setTimeout("callNativeFunction('closePopup');",300);
    <% end if %>
    return false;
}

function fnAPPpopupBrowserURLNudge(title,url,drt,pType, nudgeToken){
<% if (isTestMode) then %>
    alert(nudgeToken);
<% end if %>

    var url = url;
    var vDrt;
    if (!pType) pType="";
    if(drt=="right") {
    	vDrt = OpenType.FROM_RIGHT;
    } else {
    	vDrt = OpenType.FROM_BOTTOM;
    }
    var nToken = decodeURIComponent(nudgeToken);
	fnAPPpopupBrowserWithNudgeTrack(vDrt, [], title, [], url, pType, nToken);
	return false;
}

function fnAPPpopupBrowserWithNudgeTrack(openType, leftToolBarBtns, title, rightToolBarBtns, iurl, pageType, nudgeToken) {
    callNativeFunction('popupBrowser', {
    	"openType": openType,
    	"ltbs": leftToolBarBtns,
    	"title": title,
    	"rtbs": rightToolBarBtns,
    	"url": iurl,
    	"pageType": pageType,
    	"nudgeToken": nudgeToken
    });
    return false;
}
</script>
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
                isNudgePush = (multipskey<0)
                nudgeToken =""

''response.write multipskey&"|"&diffmin&"|"&resultdate&"|"&sendmsg&"|"

                if (isNudgePush) then  ''nudge CASE 추가
                    notititle = sendmsg
                    notiurl   = ArrRows(4,i)
                    nudgeToken = ArrRows(5,i)
                    
                    if (diffmin>=1440) then
    						notitime = MID(resultdate,6,2)&"월 "&MID(resultdate,9,2)&"일"
    				elseif (diffmin>=60) then
    						notitime = CLNG(diffmin/60)&"시간 전"
    				elseif (diffmin>=1) then
    						notitime = diffmin&"분 전"
    				elseif (diffmin<1) then
    						notitime = "방금 전"
    				end if
    				
    				noticolor = cStr("alram01")
    				
    				if (notiurl="") then noticolor = cStr("alram03")
                else
    				pos1 = InStr(sendmsg,"{""noti"":""")
    				if (pos1>0) then 
    						pos1=pos1+LEN("{""noti"":""")
    						pos2=InStr(MID(sendmsg,pos1,1024),"""")
    						if (pos2>0) then
    								notititle = Mid(sendmsg,pos1,pos2-1)
    						end if
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
    				elseif (diffmin>=1) then
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
								<p><%=notititle%></p>
								<% if (notitime<>"") then %>
									<span><%= notitime%></span>
								<% end if %>
							</div>
						</a>
					</li>
				<% else %>
					<li class="<%=noticolor%>">
					    <% if (isNudgePush) then %>
    					    <% if (notiurl="in_app") then %>
    					    <a href="#" onClick="fnShowNudgeCampagin('<%=nudgeToken%>');">
    					    	<div>
    								<p><%=notititle%></p>
    								<% if (notitime<>"") then %>
    									<span><%= notitime%></span>
    								<% end if %>
    							</div>
    						</a>
    						<% else %>
    						<a href="#" onClick="fnShowNudgeCampagin('<%=nudgeToken%>');">
    						    <div>
    								<p><%=notititle%></p>
    								<% if (notitime<>"") then %>
    									<span><%= notitime%></span>
    								<% end if %>
    							</div>
    						</a>
    					    <% end if %>
					    <% else %>
						<a href="#" onClick="fnAPPpopupBrowserURL('이벤트','<%=notiurl%>','','event');">
							<div>
								<p><%=notititle%></p>
								<% if (notitime<>"") then %>
									<span><%= notitime%></span>
								<% end if %>
							</div>
						</a>
					    <% end if %>
					</li>
				<% end if %>
			<% else %>
				<li class="<%=noticolor%>">
					<div>
						<p><%=notititle%></p>
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