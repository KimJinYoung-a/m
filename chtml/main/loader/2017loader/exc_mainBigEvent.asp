<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
Session.Codepage = 65001
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'#######################################################
' Discription : mobile_main_big_event // cache DB경유
' History : 2018-02-19 원승현 생성
'#######################################################
Dim poscode , intI ,intJ
Dim sqlStr , rsMem , arrList
Dim gaParam : gaParam = "&gaparam=today_mainbigevent_" '//GA 체크 변수
Dim CtrlDate : CtrlDate = now()
Dim limitcnt : limitcnt = 0 '//최대 배너 갯수

poscode = 2085

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "MBEVENTBIG2_"&Cint(timer/60)
Else
	cTime = 60*1
	dummyName = "MBEVENTBIG2"
End If

IF poscode = "" THEN
	Call Alert_Return("잘못된 접근입니다.")
	response.End
END IF

sqlStr = "SELECT c.imageurl , c.linkurl , c.startdate ,  c.enddate , c.altname , c.maincopy , c.subcopy , c.maincopy2 , c.tag_gift ,  c.tag_plusone"
sqlStr = sqlStr & " , c.tag_launching , c.tag_actively , c.sale_per , c.coupon_per, c.evt_code, c.salediv , c.tag_only "
sqlStr = sqlStr & " FROM [db_sitemaster].[dbo].tbl_mobile_mainCont as c WITH(NOLOCK)"
sqlStr = sqlStr & " WHERE poscode = '"&poscode&"' "
sqlStr = sqlStr & " AND isusing = 'Y' AND isnull(imageurl,'') <> '' "
sqlStr = sqlStr & " AND startdate <= getdate() "
sqlStr = sqlStr & " AND enddate >= getdate() "
sqlStr = sqlStr & " ORDER BY orderidx ASC , idx DESC , poscode ASC"

'Response.write sqlStr

set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

on Error Resume Next
intJ = 0
Dim img, link ,startdate , enddate , altname , alink , maincopy , maincopy2 ,  subcopy , tag_gift , tag_plusone , tag_launching ,  tag_actively , sale_per , coupon_per, evt_code, salePer, saleCPer, salediv , tag_only
If IsArray(arrList) Then
%>
    <div class="bigevt-bnr">
        <ul>
            <%
                For intI = 0 To ubound(arrlist,2)
                    img				= staticImgUrl & "/mobile/" + db2Html(arrlist(0,intI))
                    link			= db2Html(arrlist(1,intI))
                    startdate		= arrlist(2,intI)
                    enddate			= arrlist(3,intI)
                    altname			= db2Html(arrlist(4,intI))
                    maincopy		= db2Html(arrlist(5,intI))
                    maincopy2		= db2Html(arrlist(7,intI))
                    subcopy			= db2Html(arrlist(6,intI))
                    tag_gift		= arrlist(8,intI)
                    tag_plusone		= arrlist(9,intI)
                    tag_launching	= arrlist(10,intI)
                    tag_actively	= arrlist(11,intI)
                    sale_per		= db2Html(arrlist(12,intI))
                    coupon_per		= db2Html(arrlist(13,intI))
                    evt_code		= arrlist(14,intI)
                    salePer			= arrlist(15,intI)
                    saleCPer		= arrlist(16,intI)
                    salediv			= arrlist(17,intI)
                    tag_only		= arrlist(18,intI)

                    If isapp = "1" Then
                        If InStr(link,"/clearancesale/") > 0 Then
                            alink = "fnAmplitudeEventMultiPropertiesAction('click_eventbig','number','"&intJ+1&"', function(bool){if(bool) {fnAPPpopupClearance_URL('"& link & gaparamchk(link,gaParam) & (intJ+1) &"');}});return false;"
                        elseif InStr(lcase(link),"/subgnb/goods") > 0 Then
                            alink = "fnAmplitudeEventMultiPropertiesAction('click_eventbig','number','"&intJ+1&"', function(bool){if(bool) {fnAPPselectGNBMenu('GOODS','"& wwwUrl & appUrlPath & link & gaparamchk(link,gaParam) & (intJ+1) &"');}});return false;"			
                        Else
                            alink = "fnAmplitudeEventMultiPropertiesAction('click_eventbig','number','"&intJ+1&"', function(bool){if(bool) {fnAPPpopupAutoUrl('"& link & gaparamchk(link,gaParam) & (intJ+1) &"');}});return false;"
                        End If
                    Else
                        alink = link & gaparamchk(link,gaParam) & (intJ+1)
                    End If
            %>
                <li>
                    <% If link <> "" And img <> "" Then %>
                        <% If isapp = "1" Then %>
                        <a href="" onclick="<%=alink%>">
                        <% Else %>
                        <a href="<%=alink%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_eventbig','number','<%=intJ+1%>');">
                        <% End If %>
                            <img src="<%=img%>" alt="<%=altname%>" />
                        </a>
                    <% End If %>
                </li>
            <%
                    intJ = intJ + 1
                Next
            %>
        </ul>
    </div>
<%
End If
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->