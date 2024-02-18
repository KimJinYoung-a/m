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
' Discription : mobile_main_banner // cache DB경유
' History : 2016-04-27 이종화 생성
' 			2019-02-14 최종원 오픈한 이벤트만 노출
'#######################################################
Dim poscode , intI ,intJ
Dim sqlStr , rsMem , arrList
Dim gaParam : gaParam = "&gaparam=today_mainroll_" '//GA 체크 변수
Dim CtrlDate : CtrlDate = now()
Dim limitcnt : limitcnt = 0 '//최대 배너 갯수

poscode = 2075

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "MBIMG_"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "MBIMG"
End If

IF poscode = "" THEN
	Call Alert_Return("잘못된 접근입니다.")
	response.End
END IF

Dim topcnt : topcnt = 15

If isapp = "1" Then
	limitcnt = 15 '배열이라 -1개 총 4개 (app 전용 배너)
Else
	limitcnt = 15 '배열이라 -1개 총 4개 (M 전용 배너)
End If

sqlStr = "SELECT top "& topcnt &" c.imageurl , c.linkurl , c.startdate ,  c.enddate , c.altname , c.maincopy , c.subcopy , c.maincopy2 , c.tag_gift ,  c.tag_plusone"
sqlStr = sqlStr & " , c.tag_launching , c.tag_actively , c.sale_per , c.coupon_per, c.evt_code, e.salePer, e.saleCPer, c.salediv , c.tag_only "
sqlStr = sqlStr & " FROM [db_sitemaster].[dbo].tbl_mobile_mainCont as c WITH(NOLOCK)"
sqlStr = sqlStr & " LEFT JOIN [db_event].[dbo].[tbl_event_display] as e WITH(NOLOCK) ON e.evt_code=c.evt_code"
sqlStr = sqlStr & " OUTER APPLY( SELECT evt_state, evt_startdate, evt_enddate FROM db_event.dbo.tbl_event WITH(NOLOCK) WHERE evt_code = c.evt_code ) as et"
	If isapp ="1" Then
		sqlStr = sqlStr & " WHERE poscode in (2075,2077) "
	Else
		sqlStr = sqlStr & " WHERE poscode in (2075,2076) "
	End If
sqlStr = sqlStr & " AND isusing = 'Y' AND isnull(imageurl,'') <> '' "
sqlStr = sqlStr & " AND startdate <= getdate() "
sqlStr = sqlStr & " AND enddate >= getdate() "
sqlStr = sqlStr & " AND (et.evt_state is null or et.evt_state = 7) " '20190214 이슬비님 요청 - 오픈한 이벤트만 노출
sqlStr = sqlStr & " and (	"
sqlStr = sqlStr & "	 case when c.evt_code = 0	"
sqlStr = sqlStr & "			then convert(char(10), c.startdate, 23)	"
sqlStr = sqlStr & "			else convert(char(10), et.evt_startdate, 23)	"
sqlStr = sqlStr & "	 end	"
sqlStr = sqlStr & " ) <= convert(char(10),getdate(), 23) 	"
sqlStr = sqlStr & " and (	"
sqlStr = sqlStr & "	 case when c.evt_code = 0	"
sqlStr = sqlStr & "			then convert(char(10), c.enddate, 23)	"
sqlStr = sqlStr & "			else convert(char(10), et.evt_enddate, 23)	"
sqlStr = sqlStr & "	 end	"
sqlStr = sqlStr & " ) >= convert(char(10),getdate(), 23) 	"
sqlStr = sqlStr & " ORDER BY orderidx ASC , idx DESC , poscode ASC"

'Response.write sqlStr

set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

on Error Resume Next
intJ = 0
If IsArray(arrList) Then
%>
<div id="mainSwiper" class="text-bnr main-bnr">
	<div class="swiper-container">
		<div class="swiper-wrapper">
<%
	Dim img, link ,startdate , enddate , altname , alink , maincopy , maincopy2 ,  subcopy , tag_gift , tag_plusone , tag_launching ,  tag_actively , sale_per , coupon_per, evt_code, salePer, saleCPer, salediv , tag_only
	Dim opttag
	For intI = 0 To ubound(arrlist,2)
		opttag = ""
		If CDate(CtrlDate) >= CDate(arrlist(2,intI)) AND CDate(CtrlDate) <= CDate(arrlist(3,intI)) Then
			If intJ > limitcnt Then Exit For '//매뉴별 최대 갯수

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

		If tag_actively = "Y" Then opttag = "참여"
		If tag_launching = "Y" Then opttag = "런칭"
		If tag_plusone = "Y" Then opttag = "1+1"
		If tag_gift = "Y" Then opttag = "GIFT"
		If tag_only = "Y" Then opttag = "ONLY"

		If isapp = "1" Then
			If InStr(link,"/clearancesale/") > 0 Then
				alink = "fnAmplitudeEventMultiPropertiesAction('click_mainrolling','rollingnumber|linkurl','"&intJ+1&"|" & link & "', function(bool){if(bool) {fnAPPpopupClearance_URL('"& link & gaparamchk(link,gaParam) & (intJ+1) &"');}});return false;"
			elseif InStr(lcase(link),"/subgnb/goods") > 0 Then
				alink = "fnAmplitudeEventMultiPropertiesAction('click_mainrolling','rollingnumber|linkurl','"&intJ+1&"|" & link & "', function(bool){if(bool) {fnAPPselectGNBMenu('GOODS','"& wwwUrl & appUrlPath & link & gaparamchk(link,gaParam) & (intJ+1) &"');}});return false;"			
			Else
				alink = "fnAmplitudeEventMultiPropertiesAction('click_mainrolling','rollingnumber|linkurl','"&intJ+1&"|" & link & "', function(bool){if(bool) {fnAPPpopupAutoUrl('"& link & gaparamchk(link,gaParam) & (intJ+1) &"');}});return false;"
			End If
		Else
			alink = link & gaparamchk(link,gaParam) & (intJ+1)
		End If
%>
		<% If salediv="2" or salediv="3" Then %>
			<!-- 주말특가 A/B타입 구분 제거 -->
			<!-- section class="swiper-slide spc-weekendV19 <%=chkiif(salediv="3","btype","")%>" -->
			<section class="swiper-slide spc-weekendV21">
				<% If isapp = "1" Then %>
				<a href="javascript:void(0)" onclick="click_main_rolling('a', '', '<%=link%>', `<%=maincopy%>`, `<%=subcopy%>`, '<%=opttag%>'); setTimeout(function(){let act_amplitude = new Function(`<%=alink%>`); act_amplitude();}, 500);">
				<% Else %>
				<a href="<%=alink%>" onclick="click_main_rolling('m', '<%=intJ+1%>', '<%=link%>', `<%=maincopy%>`, `<%=subcopy%>`, '<%=opttag%>')">
				<% End If %>
					<% If application("Svr_Info") = "Dev" Then %>
					<div class="thumbnail"><img src="<%=img%>" alt="<%=altname%>" /></div>
					<% Else %>
					<div class="thumbnail"><img src="<%=getThumbImgFromURL(img,750,"","","")%>" alt="<%=altname%>" /></div>
					<% End If %>
					<% If salePer<>"" Then %><p class="discount"><i>~</i><%=salePer%><span>%</span></p><% End If %>
					<div class="desc" data-swiper-parallax="-100">
						<h2 class="headline"><%=maincopy%><br /> <%=maincopy2%></h2>
						<p class="subcopy"><% If opttag <> "" Then %><span class="label label-color"><em class="color-blue"><%=opttag%></em></span><% End If %><%=Replace(db2html(subcopy),Chr(13),"<br/>")%></p>
					</div>
				</a>
			</section>
		<% Else %>
			<section class="swiper-slide">
				<% If isapp = "1" Then %>
				<a href="javascript:void(0)" onclick="click_main_rolling('a', '', '<%=link%>', `<%=maincopy%>`, `<%=subcopy%>`, '<%=opttag%>'); setTimeout(function(){let act_amplitude = new Function(`<%=alink%>`); act_amplitude();}, 500);">
				<% Else %>
				<a href="<%=alink%>" onclick="click_main_rolling('m', '<%=intJ+1%>', '<%=link%>', `<%=maincopy%>`, `<%=subcopy%>`, '<%=opttag%>')">
				<% End If %>
					<% If application("Svr_Info") = "Dev" Then %>
					<div class="thumbnail"><img src="<%=img%>" alt="<%=altname%>" /></div>
					<% Else %>
					<div class="thumbnail"><img src="<%=getThumbImgFromURL(img,750,"","","")%>" alt="<%=altname%>" /></div>
					<% End If %>
					<div class="desc" data-swiper-parallax="-100">
						<% If sale_per <> "" Or coupon_per <> "" Then %>
						<span class="label label-speech"><% If sale_per <> "" Then %><b class="discount"><%=sale_per%></b><% End If %> <% If coupon_per <> "" Then %><b class="discount">쿠폰 <%=coupon_per%></b><% End If %></span>
						<% End If %>
						<h2 class="headline"><%=maincopy%><br /> <%=maincopy2%></h2>
						<p class="subcopy"><% If opttag <> "" Then %><span class="label label-color"><em class="color-blue"><%=opttag%></em></span><% End If %><%=Replace(db2html(subcopy),Chr(13),"<br/>")%></p>
					</div>
				</a>
			</section>
		<% End If %>
<%
			intJ = intJ + 1
		End if
	Next
%>
		</div>
		<div class="pagingNo"><p class="page"><strong></strong><em>/</em><span></span></p></div> 
	</div>
</div>
<script>
    // 스와이퍼
    function toprollingslide(){
        /* main banner */
        var mainSwiper = new Swiper("#mainSwiper .swiper-container", {
            paginationClickable:true,
            //autoplay:3000,
            loop:true,
            speed:600,
            parallax:true,
            onSlideChangeStart: function (mainSwiper) {
                var vActIdx = parseInt(mainSwiper.activeIndex);
                if (vActIdx<=0) {
                    vActIdx = mainSwiper.slides.length-2;
                } else if(vActIdx>(mainSwiper.slides.length-2)) {
                    vActIdx = 1;
                }
                $("#mainSwiper .pagingNo .page strong").text(vActIdx);
            }
        });
        $('#mainSwiper .pagingNo .page strong').text(1);
        $('#mainSwiper .pagingNo .page span').text(mainSwiper.slides.length-2);
    }
    setTimeout(function(){
        toprollingslide();
        rectPosition('#mainSwiper');
    },100);

    function click_main_rolling(device, index, link, maincopy, subcopy, opttag){
        let appier_content_clicked = {
            "Content_url" : link
            , "Content_name" : maincopy
            , "Content_detail" : subcopy
            , "Content_tag" : opttag
        };

        if(device == "a"){
            fnAppierLogEventProperties("content_clicked", appier_content_clicked);
        }else{
            fnAmplitudeEventMultiPropertiesAction('click_mainrolling','rollingnumber|linkurl',index + '|' + link);

            if(typeof qg !== "undefined"){
                setTimeout(function(){
                    qg("event", "content_clicked", appier_content_clicked);
                }, 500);
            }
        }
    }
</script>
<%
End If
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->