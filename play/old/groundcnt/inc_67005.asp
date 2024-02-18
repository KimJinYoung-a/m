<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : play 스물다섯 번째 이야기 TOY Im your MAN
' History : 2015.10.23 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim eCode , sqlStr , userid , totcnt , iCTotCnt, pagereload
Dim rank(4) , seltoy(4) , selcnt(4)
pagereload	= requestCheckVar(request("pagereload"),2)

IF application("Svr_Info") = "Dev" THEN
	eCode   =  "64935"
Else
	eCode   =  "67005"
End If

userid = GetEncLoginUserID

If GetEncLoginUserID <> "" then
	sqlStr = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& userid &"' and evt_code = '"& ecode &"' and datediff(day,regdate,getdate()) = 0 " 
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly 

	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()
End If 

	sqlStr = "select count(*) from db_event.dbo.tbl_event_subscript where evt_code = '"& ecode &"' " 
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly 

	IF Not rsget.Eof Then
		iCTotCnt = rsget(0)
	End IF
	rsget.close()

	Dim ii : ii = 0
	Dim vi
	sqlStr = "select RANK() OVER (ORDER BY count(*) desc) as ranking "
	sqlStr = sqlStr & " , sub_opt1 , count(*) as totcnt "
	sqlStr = sqlStr & "	from db_event.dbo.tbl_event_subscript where evt_code = '"& ecode &"' " 
	sqlStr = sqlStr & "	group by sub_opt1 " 
	sqlStr = sqlStr & "	order by totcnt desc " 
	rsget.CursorLocation = adUseClient

	'response.write sqlStr & "<br>"
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
	If Not rsget.Eof Then
		Do Until rsget.eof
			rank(ii)	= rsget("ranking")
			seltoy(ii)	= rsget("sub_opt1")
			selcnt(ii)	= rsget("totcnt")
		ii = ii + 1
		rsget.movenext
		Loop
	End IF
	rsget.close

	for ii = 0 To 3
		For vi = 1 To 4
			If seltoy(ii) = "" And seltoy(ii) <> vi Then
				seltoy(ii) = vi
			End if
		next
	Next 
%>
<style type="text/css">
img {vertical-align:top;}
.playEvent {background:#f0efe7 url(http://webimage.10x10.co.kr/playmo/ground/20151019/bg_gray.gif) 0 100% no-repeat; background-size:100% auto;}
.toyStyle {background:#f0f0f0;}
.toyStyle ul {overflow:hidden; padding:0 10% 6.5%;}
.toyStyle li { float:left; width:50%; padding:0 2% 6%;}
.toyStyle li a {display:block; position:relative;}
.toyStyle li strong {display:none; position:absolute; left:0; top:0; width:100%; }
.toyStyle li a.on strong {display:block;}
.toyStyle .tabCont {position:relative;}
.toyStyle .btnDate {position:absolute; width:37%; z-index:50;}
.toyStyle #toy01 .btnDate {left:10%; top:52%;}
.toyStyle #toy02 .btnDate {left:50%; top:66%;}
.toyStyle #toy03 .btnDate {left:10%; top:48%;}
.toyStyle #toy04 .btnDate {right:8%; top:49%;}
.viewRank {background:url(http://webimage.10x10.co.kr/play/ground/20151026/bg_zigzag.gif) 0 0 repeat; background-size:6.2% auto; background-position:0 0;}
.result {padding-bottom:13%; background:url(http://webimage.10x10.co.kr/playmo/ground/20151026/bg_flower.png) 100% 100% no-repeat; background-size:33.5% auto;}
.result .total {padding-top:3%; font-size:12px; color:#fff; text-align:center; }
.result .total span {display:inline-block; padding-bottom:5px; font-size:13px;  font-weight:600;border-bottom:2px solid #fff;}
.result .total span em {position:relative; top:2px; font-weight:bold; padding:0 5px; font-size:20px;}
.result ol {padding:0 9%; line-height:1;}
.result li {position:relative; height:35px; margin:0 0 20px 25px; background:#4e87bf; border-radius:0 18px 18px 0;}
.result li:after {content:' '; display:inline-block; position:absolute; left:0; top:0; width:100%; height:50%; background:#6095c9; border-radius:0 18px 0 0;}
.result li .thumb {display:inline-block; position:absolute; left:-25px; top:-7px; width:50px; height:50px; border:2px solid #4e87bf; border-radius:50%; background-position:0 0; background-repeat:no-repeat; background-size:100% 100%; background-color:#fff; z-index:40;}
.result li.toy01 .thumb {background-image:url(http://webimage.10x10.co.kr/play/ground/20151026/img_thumb_toy01.png);}
.result li.toy02 .thumb {background-image:url(http://webimage.10x10.co.kr/play/ground/20151026/img_thumb_toy02.png);}
.result li.toy03 .thumb {background-image:url(http://webimage.10x10.co.kr/play/ground/20151026/img_thumb_toy03.png);}
.result li.toy04 .thumb {background-image:url(http://webimage.10x10.co.kr/play/ground/20151026/img_thumb_toy04.png);}
.result li .ranking {display:inline-block; position:absolute; left:30px; top:13px; color:#afcafe; font-size:12px; z-index:50; font-weight:bold;}
.result li .count {display:inline-block; position:absolute; left:60px; top:11px; color:#fff; font-size:11px; z-index:50; letter-spacing:-0.025em;}
.result li .count em {display:inline-block; position:relative; top:1px; padding:0 3px 0 5px; font-size:14px; color:#d5e4ff; font-weight:bold;}
.result li.rank01 {background:#fad1cc;}
.result li.rank01:after {background:#ffddd9;}
.result li.rank01 .thumb {border:2px solid #fbc0ba;}
.result li.rank01 .ranking {color:#ec5b4f;}
.result li.rank01 .count {color:#ec5b4f;}
.result li.rank01 .count em {color:#ec5b4f;}
@media all and (min-width:480px){
	.result .total {font-size:18px;}
	.result .total span {padding-bottom:7px; font-size:20px; border-bottom:3px solid #fff;}
	.result .total span em {top:3px; padding:0 7px; font-size:30px;}
	.result li {height:53px; margin:0 0 30px 38px; border-radius:0 27px 27px 0;}
	.result li:after {border-radius:0 27px 0 0;}
	.result li .thumb {left:-38px; top:-11px; width:75px; height:75px; border:3px solid #4e87bf;}
	.result li .ranking {left:50px; top:20px; font-size:18px;}
	.result li .count {left:90px; top:17px; font-size:17px;}
	.result li .count em {top:2px; padding:0 4px 0 7px; font-size:21px;}
	.result li.rank01 .thumb {border:3px solid #fbc0ba;}
}
</style>
<script type="text/javascript">
$(function(){
	$('.tabCont').hide();
	$('.tabCont:first').show();
	$(".toyStyle ul").find("li:first a").addClass("on");
	$(".toyStyle li").click(function() {
		window.parent.$('html,body').animate({scrollTop:$('.tabContainer').offset().top}, 400);
		$(this).siblings("li").find("a").removeClass("on");
		$(this).find("a").addClass("on");
		$(this).closest(".toyStyle ul").nextAll(".tabContainer:first").find(".tabCont").hide();
		var activeTab = $(this).find("a").attr("href");
		$(activeTab).show();
		return false;
	});

	<% if pagereload<>"" then %>
		setTimeout("pagedown()",500);
	<% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#mystudioEvt").offset().top}, 0);
}

function jsSubmitEvt(v){
	<% if Not(IsUserLoginOK) then %>
		<% If isapp="1" Then %>
			calllogin();
			return;
		<% else %>
			jsevtlogin();
			return;
		<% End If %>
	<% end if %>
   
   var frm = document.frmcom;
   frm.spoint.value = v;
   frm.action = "/play/groundcnt/doeventsubscript67005.asp";
   frm.submit();
   return true;
}

</script>
</head>
<body>

<div class="mPlay20151026">
	<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20151026/tit_toy_man.png" alt="I'M YOUR MAN" /></h2>
	<div><img src="http://webimage.10x10.co.kr/playmo/ground/20151026/txt_purpose.png" alt="플레이에서는 여러분의 이상형을 찾기 위해 미팅을 준비했습니다! 우리의 미팅남들은 테이블위에 자신만의 소지품을 올려두었습니다. 어떤 것을 선택하시겠어요? 4인4색 멋지고 다양한 매력을 지닌 소지품 중 하나를 골라보세요!" /></div>
	<div><img src="http://webimage.10x10.co.kr/playmo/ground/20151026/img_manual.png" alt="MEETING MANUAL" /></div>

	<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
		<input type="hidden" name="spoint" value=""/>
		<input type="hidden" name="isApp" value="<%=isApp%>"/>
	</form>
	<div class="toyStyle">
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20151026/tit_toy_type.gif" alt="I'M YOUR MAN" /></h3>
		<ul>
			<li class="t01"><a href="#toy01"><strong><img src="http://webimage.10x10.co.kr/playmo/ground/20151026/txt_drone.png" alt="미니드론" /></strong><img src="http://webimage.10x10.co.kr/playmo/ground/20151026/img_drone.png" alt="미니드론" /></a></li>
			<li class="t02"><a href="#toy02"><strong><img src="http://webimage.10x10.co.kr/playmo/ground/20151026/txt_lamp.png" alt="토이조명" /></strong><img src="http://webimage.10x10.co.kr/playmo/ground/20151026/img_lamp.png" alt="토이조명" /></a></li>
			<li class="t03"><a href="#toy03"><strong><img src="http://webimage.10x10.co.kr/playmo/ground/20151026/txt_gundam.png" alt="건담" /></strong><img src="http://webimage.10x10.co.kr/playmo/ground/20151026/img_gundam.png" alt="건담" /></a></li>
			<li class="t04"><a href="#toy04"><strong><img src="http://webimage.10x10.co.kr/playmo/ground/20151026/txt_rc.png" alt="RC카" /></strong><img src="http://webimage.10x10.co.kr/playmo/ground/20151026/img_rc.png" alt="RC카" /></a></li>
		</ul>
		<div class="tabContainer">
			<div id="toy01" class="tabCont">
				<div class="pic">
					<% if isApp then %>
						<a href="" onclick="fnAPPpopupProduct('1335447'); return false;">
					<% else %>
						<a href="/category/category_itemPrd.asp?itemid=1335447">
					<% end if %>

					<img src="http://webimage.10x10.co.kr/playmo/ground/20151026/img_toy_type01.jpg" alt="" /></a>
				</div>
				<input type="image" onclick="jsSubmitEvt(1);" src="http://webimage.10x10.co.kr/playmo/ground/20151026/btn_date01.png" alt="데이트신청" class="btnDate" />
			</div>
			<div id="toy02" class="tabCont">
				<div class="pic">
					<% if isApp then %>
						<a href="" onclick="fnAPPpopupProduct('1119270'); return false;">
					<% else %>
						<a href="/category/category_itemPrd.asp?itemid=1119270">
					<% end if %>

					<img src="http://webimage.10x10.co.kr/playmo/ground/20151026/img_toy_type02.jpg" alt="" /></a>
				</div>
				<input type="image" onclick="jsSubmitEvt(2);" src="http://webimage.10x10.co.kr/playmo/ground/20151026/btn_date02.png" alt="데이트신청" class="btnDate" />
			</div>
			<div id="toy03" class="tabCont">
				<div class="pic">
					<% if isApp then %>
						<a href="" onclick="fnAPPpopupProduct('1285796'); return false;">
					<% else %>
						<a href="/category/category_itemPrd.asp?itemid=1285796">
					<% end if %>

					<img src="http://webimage.10x10.co.kr/playmo/ground/20151026/img_toy_type03.jpg" alt="" /></a>
				</div>
				<input type="image" onclick="jsSubmitEvt(3);" src="http://webimage.10x10.co.kr/playmo/ground/20151026/btn_date03.png" alt="데이트신청" class="btnDate" />
			</div>
			<div id="toy04" class="tabCont">
				<div class="pic">
					<% if isApp then %>
						<a href="" onclick="fnAPPpopupProduct('1176066'); return false;">
					<% else %>
						<a href="/category/category_itemPrd.asp?itemid=1176066">
					<% end if %>

					<img src="http://webimage.10x10.co.kr/playmo/ground/20151026/img_toy_type04.jpg" alt="" /></a>
				</div>
				<input type="image" onclick="jsSubmitEvt(4);" src="http://webimage.10x10.co.kr/playmo/ground/20151026/btn_date04.png" alt="데이트신청" class="btnDate" />
			</div>
		</div>
	</div>

	<div class="viewRank">
		<div class="result" id="mystudioEvt">
			<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20151026/tit_view_ranking.png" alt="어떤 남자에게 데이트신청 하셨나요? 미팅의 인기순위를 공개합니다!" /></h3>
			<ol>
				<li class="rank01 <% if selcnt(0)<>0 then %>toy0<%=seltoy(0)%><% end if %>" id="mystudioEvt01">
					<span class="thumb"></span>
					<span class="ranking">1위</span>
					<p class="count">총<em><%=FormatNumber(selcnt(0),0)%></em>명이 데이트 신청을 했습니다.</p>
				</li>
				<li class="rank02 <% if selcnt(1)<>0 then %>toy0<%=seltoy(1)%><% end if %>" id="mystudioEvt02">
					<span class="thumb"></span>
					<span class="ranking">2위</span>
					<p class="count">총<em><%=FormatNumber(selcnt(1),0)%></em>명이 데이트 신청을 했습니다.</p>
				</li>
				<li class="rank03 <% if selcnt(2)<>0 then %>toy0<%=seltoy(2)%><% end if %>" id="mystudioEvt03">
					<span class="thumb"></span>
					<span class="ranking">3위</span>
					<p class="count">총<em><%=FormatNumber(selcnt(2),0)%></em>명이 데이트 신청을 했습니다.</p>
				</li>
				<li class="rank04 <% if selcnt(3)<>0 then %>toy0<%=seltoy(3)%><% end if %>" id="mystudioEvt04">
					<span class="thumb"></span>
					<span class="ranking">4위</span>
					<p class="count">총<em><%=FormatNumber(selcnt(3),0)%></em>명이 데이트 신청을 했습니다.</p>
				</li>
			</ol>
			<p class="total" id="total"><span>총<em><%=FormatNumber(iCTotCnt,0)%></em>명이 데이트 신청을 했습니다.</span></p>
		</div>
	</div>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->