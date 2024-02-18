<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 가을을 준비하는 올바른 자세
' History : 2015-08-19 이종화
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode , userid , strSql , todaycnt
Dim totcnt1 , totcnt2 , totcnt3 , totcnt4
Dim mycnt1 , mycnt2 , mycnt3 , mycnt4
Dim addurl

If isapp = "1" Then
	addurl = "/apps/appcom/wish/web2014"
End If

userid = GetEncLoginUserID()

IF application("Svr_Info") = "Dev" THEN
	eCode   =  65949
Else
	eCode   =  67446
End If
	
	'// 응모자 설정
	If IsUserLoginOK Then
		strSql = " select  "
		strSql = strSql & " isnull(sum(case when sub_opt2 = 1 then 1 else 0 end),0) as mycnt1 , "
		strSql = strSql & " isnull(sum(case when sub_opt2 = 2 then 1 else 0 end),0) as mycnt2 , "
		strSql = strSql & " isnull(sum(case when sub_opt2 = 3 then 1 else 0 end),0) as mycnt3 , "
		strSql = strSql & " isnull(sum(case when sub_opt2 = 4 then 1 else 0 end),0) as mycnt4  "
		strSql = strSql & " From [db_event].[dbo].[tbl_event_subscript] "
		strSql = strSql & " where evt_code = '"&eCode&"' and userid = '"&userid&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly 
		IF Not rsget.Eof Then
			mycnt1 = rsget(0)
			mycnt2 = rsget(1)
			mycnt3 = rsget(2)
			mycnt4 = rsget(3)
		End IF
		rsget.close()
	End If 

	strSql = " select  "
	strSql = strSql & " isnull(sum(case when sub_opt2 = 1 then 1 else 0 end),0) as totcnt1 , "
	strSql = strSql & " isnull(sum(case when sub_opt2 = 2 then 1 else 0 end),0) as totcnt2 , "
	strSql = strSql & " isnull(sum(case when sub_opt2 = 3 then 1 else 0 end),0) as totcnt3 , "
	strSql = strSql & " isnull(sum(case when sub_opt2 = 4 then 1 else 0 end),0) as totcnt4  "
	strSql = strSql & " From [db_event].[dbo].[tbl_event_subscript] "
	strSql = strSql & " where evt_code = '"&eCode&"' "
	rsget.CursorLocation = adUseClient
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly 
	IF Not rsget.Eof Then
		totcnt1 = rsget(0)
		totcnt2 = rsget(1)
		totcnt3 = rsget(2)
		totcnt4 = rsget(3)
	End IF
	rsget.close()

%>
<style type="text/css">
img {vertical-align:top;}
.giftstagram li {position:relative;}
.giftstagram li .giftInfo {position:absolute; left:57%; top:50%; width:36%;}
.giftstagram li .goPdt {position:absolute; left:4.5%; top:3%; width:47%; height:75%; background:rgba(0,0,0,0); color:transparent;}
.giftstagram li:nth-child(even) .goPdt {left:48%;}
.giftstagram li:last-child .goPdt {height:81%;}
.giftstagram li:nth-child(even) .giftInfo {left:8%;}
.giftstagram li .giftInfo .btnLike {position:relative; display:inline-block; width:20%;}
.giftstagram li .giftInfo .btnLike.on:after {content:''; display:inline-block; position:absolute; left:0; top:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67446/m/ico_heart_on.png) no-repeat 0 0; background-size:100% 100%;}
.giftstagram li .giftInfo .posting {display:inline-block; width:20%; margin-left:10px;}
.giftstagram li .giftInfo .like {font-size:11px; line-height:1; padding-left:12px; margin:10px 0 0 3px; color:#6d6d6d; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67446/m/ico_heart02.png) no-repeat 0 0; background-size:10px auto;}
.evtNoti {padding:6.5% 4.6%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67446/m/bg_notice.png) repeat-y 0 0; background-size:100% auto;}
.evtNoti h3 {position:relative; display:inline-block; font-weight:bold; color:#000; font-size:15px; padding-bottom:14px; margin-left:7px;}
.evtNoti h3:after {content:''; display:inline-block; position:absolute; left:106%; top:5px; width:45px; height:1px; background:#424242;}
.evtNoti li {position:relative; font-size:11px; line-height:1.2; color:#656565; padding:0 0 3px 7px;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:4px; width:3px; height:1px; background:#656565;}
.evtNoti li em {color:#d44242;}
.evtNoti li img {display:inline-block; width:134px; margin:2px 0 5px;}
.bnr {padding-top:30px;}
.bnr div {padding-top:20px;}
@media all and (min-width:480px){
	.giftstagram li .giftInfo {top:54%;}
	.giftstagram li .giftInfo .posting {margin-left:15px;}
	.giftstagram li .giftInfo .like {font-size:17px; padding-left:18px; margin:15px 0 0 4px; background-size:15px auto;}
	.evtNoti h3 {font-size:23px; padding-bottom:21px; margin-left:11px;}
	.evtNoti h3:after {top:7px; width:68px;}
	.evtNoti li {font-size:17px; padding:0 0 4px 11px;}
	.evtNoti li:after {top:6px; width:4px;}
	.evtNoti li:nth-child(2) {margin-top:5px;}
	.evtNoti li img {width:201px;}
	.bnr {padding-top:45px;}
	.bnr div {padding-top:30px;}
}
</style>
<script>
function chklike(v){
	<% If IsUserLoginOK() Then %>
		var frm = document.frm
		frm.opt.value = v;
		frm.action = "/event/etc/doeventsubscript/doeventsubscript67446.asp";
		frm.submit();
	<% Else %>
		<% If isapp="1" Then %>
			calllogin();
			return;
		<% else %>
			jsevtlogin();
			return;
		<% End If %>
	<% End IF %>
}
</script>
<div class="mEvt67380">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/tit_gift_stagram.png" alt="#사은품스타그램" /></h2>
	<div class="giftstagram">
		<ol>
			<li class="g01">
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/img_gift01.jpg" alt="플레이버 : 틴-캔들" /></div>
				<% If isapp = "1" Then %>
				<a href="" onclick="fnAPPpopupProduct('1212471'); return false;" class="goPdt">상품 보러가기</a>
				<% Else %>
				<a href="/category/category_itemPrd.asp?itemid=1212471" class="goPdt">상품 보러가기</a>
				<% End If %>
				<div class="giftInfo">
					<span class="btnLike <%=chkiif(mycnt1 = 1," on","")%>" onclick="chklike('1');"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/ico_heart_off.png" alt="좋아요 버튼" /></span>
					<a href="https://www.instagram.com/p/wlmYvWSRwU/?taken-by=your10x10" target="_blank" class="posting"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/btn_posting.png" alt="관련 포스팅 보기" /></a>
					<p class="like"><%=totcnt1%>명이 좋아합니다</p>
				</div>
			</li>
			<li class="g02">
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/img_gift02.jpg" alt="데꼴:크리스마스 피규어" /></div>
				<% If isapp = "1" Then %>
				<a href="" onclick="fnAPPpopupProduct('1371651'); return false;" class="goPdt">상품 보러가기</a>
				<% Else %>
				<a href="/category/category_itemPrd.asp?itemid=1371651" class="goPdt">상품 보러가기</a>
				<% End If %>
				<div class="giftInfo">
					<span class="btnLike <%=chkiif(mycnt2 = 1," on","")%>" onclick="chklike('2');"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/ico_heart_off.png" alt="좋아요 버튼" /></span>
					<a href="https://www.instagram.com/p/9pAu_wSR3v/?taken-by=your10x10" target="_blank" class="posting"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/btn_posting.png" alt="관련 포스팅 보기" /></a>
					<p class="like"><%=totcnt2%>명이 좋아합니다</p>
				</div>
			</li>
			<li class="g03">
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/img_gift03.jpg" alt="서커스보이밴드:마그넷" /></div>
				<% If isapp = "1" Then %>
				<a href="" onclick="fnAPPpopupProduct('1381298'); return false;" class="goPdt">상품 보러가기</a>
				<% Else %>
				<a href="/category/category_itemPrd.asp?itemid=1381298" class="goPdt">상품 보러가기</a>
				<% End If %>
				<div class="giftInfo">
					<span class="btnLike <%=chkiif(mycnt3 = 1," on","")%>" onclick="chklike('3');"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/ico_heart_off.png" alt="좋아요 버튼" /></span>
					<a href="https://www.instagram.com/p/-BHLocyR_u/?taken-by=your10x10" target="_blank" class="posting"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/btn_posting.png" alt="관련 포스팅 보기" /></a>
					<p class="like"><%=totcnt3%>명이 좋아합니다</p>
				</div>
			</li>
			<li class="g04">
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/img_gift04.jpg" alt="쿨 이너프 스튜디오:더 미러" /></div>
				<% If isapp = "1" Then %>
				<a href="" onclick="fnAPPpopupProduct('1114756'); return false;" class="goPdt">상품 보러가기</a>
				<% Else %>
				<a href="/category/category_itemPrd.asp?itemid=1114756" class="goPdt">상품 보러가기</a>
				<% End If %>
				<div class="giftInfo">
					<span class="btnLike <%=chkiif(mycnt4 = 1," on","")%>" onclick="chklike('4');"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/ico_heart_off.png" alt="좋아요 버튼" /></span>
					<a href="https://www.instagram.com/p/5zlqROSRxF/?taken-by=your10x10" target="_blank" class="posting"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/btn_posting.png" alt="관련 포스팅 보기" /></a>
					<p class="like"><%=totcnt4%>명이 좋아합니다</p>
				</div>
			</li>
		</ol>
	</div>
	<div class="evtNoti">
		<h3>이벤트공지사항</h3>
		<ul>
			<li>텐바이텐 사은 이벤트는 <em>텐바이텐 회원님</em>을 위한 혜택입니다.(비회원 구매 증정 불가)</li>
			<li><em>텐바이텐 배송상품을 포함</em>해야 사은품 선택이 가능합니다.<br /><a href="eventmain.asp?eventid=66572"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/btn_ten_delivery.png" alt="텐바이텐 배송상품 받으러 가기" /></a></li>
			<li>상품쿠폰, 보너스쿠폰, 할인카드 등의 사용 후 구매확정 금액이 <em>6만원 이상</em> 이어야 선택 가능 합니다.</li>
			<li>마일리지, 예치금, 기프트카드를 사용하신 경우는 구매확정 금액에 포함되어 사은품을 받으실 수 있습니다.</li>
			<li>각 상품 별 한정수량이므로, 조기에 소진 될 수 있습니다.</li>
			<li>텐바이텐 기프트카드를 구매하신 경우는 사은품 증정이 되지 않습니다.</li>
			<li>사은품은 텐바이텐 배송 상품과 함께 배송됩니다.</li>
			<li>환불이나 교환 시 최종 구매 가격이 사은품 수량 가능금액 미만이 될 경우, 사은품과 함께 반품해야 합니다.</li>
			<li>이벤트는 조기종료 될 수 있습니다.</li>
		</ul>
	</div>
	<div class="bnr">
			<a href="<%=addurl%>/event/eventmain.asp?eventid=67567"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/bnr_hot_item.png" alt="금주의 핫 아이템" /></a>
		<div>
		<% If Date() <= "2015-11-16" Then %>
			<a href="<%=addurl%>/event/eventmain.asp?eventid=67460"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/bnr_keyword01.png" alt="핫키워드 기획전 #아이폰6S" /></a>
		<% End If %>
		<% If Date() = "2015-11-17" Then %>
			<a href="<%=addurl%>/event/eventmain.asp?eventid=67518"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/bnr_keyword02.png" alt="핫키워드 기획전 #방한소품" /></a>
		<% End If %>
		<% If Date() = "2015-11-18" Then %>
			<a href="<%=addurl%>/event/eventmain.asp?eventid=67538"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/bnr_keyword03.png" alt="핫키워드 기획전 #보온" /></a>
		<% End If %>
		<% If Date() = "2015-11-19" Then %>
			<a href="<%=addurl%>/event/eventmain.asp?eventid=67460"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/bnr_keyword04.png" alt="핫키워드 기획전 #건조주의보" /></a>
		<% End If %>
		<% If Date() >= "2015-11-20" Then %>
			<a href="<%=addurl%>/event/eventmain.asp?eventid=67460"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/m/bnr_keyword05.png" alt="핫키워드 기획전 #BOTTLE" /></a>
		<% End If %>
		</div>
	</div>
</div>
<form name="frm" method="post" style="margin:0px;" target="prociframe">
<input type="hidden" name="opt" value=""/>
</form>
<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px"></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->