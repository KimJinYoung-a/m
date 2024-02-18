<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  현상금을 노려라
' History : 2015-08-03 이종화
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim eCode , strSql , chkval1 , chkval2 , chkval3 , evt_url , rurl , tmpitemid1 ,  tmpitemid2  ,  tmpitemid3 
Dim userid , tItemid , tday
	userid = getloginuserid()

IF application("Svr_Info") = "Dev" THEN
	eCode   =  64843
Else
	eCode   =  65229
End If

If IsUserLoginOK Then 
	strSql = "select top 1 "
	strSql = strSql & " sub_opt1 ,  sub_opt2 ,  sub_opt3 "
	strSql = strSql & " from db_event.dbo.tbl_event_subscript "
	strSql = strSql & "	where userid = '"& userid &"' and evt_code = '"& eCode &"' and datediff(day,regdate,getdate()) = 0 " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		chkval1 = rsget("sub_opt1") '//1차응모
		chkval2 = rsget("sub_opt2") '//2차응모
		chkval3 = rsget("sub_opt3") '//카카오
	End IF
	rsget.close()
End If 

'//이벤트별 상품 코드 wish용
If Date() = "2015-08-10" Then
	tItemid = "1322304"
ElseIf Date() = "2015-08-11" Then
	tItemid = "1243628"
	tmpitemid1 = "1175785"
	tmpitemid2 = "1243628"
	tmpitemid3 = "1198354"
ElseIf Date() = "2015-08-12" Then
	tItemid = "1246002"
	tmpitemid1 = "1246002"
	tmpitemid2 = "1101803"
	tmpitemid3 = "1232640"
ElseIf Date() = "2015-08-13" Then
	tItemid = "1321876"
	tmpitemid1 = "1327545"
	tmpitemid2 = "1287253"
	tmpitemid3 = "1321876"
ElseIf Date() = "2015-08-14" Then
	tItemid = "1103524"
	tmpitemid1 = "1303905"
	tmpitemid2 = "1152801"
	tmpitemid3 = "1103524"
Else
	tItemid = "1322304"
End If


'//일자
If day(now()) < 10 Or day(now()) > 14 Then 
	tday = "10"
Else
	tday = day(now())
End If 

'// URL
If isapp = "1" Then
	evt_url = "http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&eCode
	rurl = "fnAPPpopupProduct('"&tItemid&"');return false;"
Else
	evt_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
	rurl = "top.location.href='/category/category_itemprd.asp?itemid="&tItemid&"';"
End If 

%>
<style type="text/css">
img {vertical-align:top;}
.mEvt65229 {position:relative; margin-bottom:-20px;}
.todayWanted {position:relative;}
.todayWanted .reward {position:absolute; left:0; top:40.5%; width:100%; z-index:50;}
.todayWanted .openPdt {position:absolute; left:0; top:0; width:100%; z-index:40; display:none;}
.report {text-align:center;}
.report input {display:inline-block; height:49px; border:0; border-radius:0; vertical-align:top;}
input.writeCode {width:160px; text-align:center; color:#333; font-size:14px;}
input.submitCode {width:100px;}
.findCode {position:relative; padding-top:25px; margin-top:35px;}
.findCode a {display:block; width:45%; margin:0 auto;}
.findCode:after {content:' '; display:inline-block; position:absolute; left:8%; top:0; width:84%; height:1px; background:rgba(255,255,255,.15);}
.viewHint {padding-bottom:34px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65229/bg_brick02.gif) 0 0 repeat-y; background-size:100% auto ;}
.viewHint ul {position:relative; overflow:hidden; padding:18px 7.5%;}
.viewHint ul:after {content:' '; display:inline-block; position:absolute; left:8%; top:0; width:84%; height:1px; background:rgba(255,255,255,.15);}
.viewHint li {float:left; width:33.33333%; padding:0 1.25%; text-align:center;}
.viewHint li a {display:block; margin-bottom:10px;}
.viewHint li input {position:relative; width:27px; height:27px; border:0; border-radius:50%;}
.viewHint li input:checked {display:inline-block; overflow:hidden; background:#fff;}
.viewHint li input:checked:after {content:' '; display:inline-block; position:absolute; left:22%; top:22%; width:56%; height:56%; background:#d60000; border-radius:50%;}
.evtNoti {padding:25px 9px 30px;}
.evtNoti h3 strong {display:inline-block; font-size:14px; line-height:13px; margin-left:8px; padding-left:1px; letter-spacing:1px; color:#000; border-bottom:2px solid #000;}
.evtNoti ul {padding-top:13px;}
.evtNoti li {position:relative; padding:0 0 0 8px; font-size:11px; line-height:1.3; letter-spacing:-0.01em; color:#444;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:4px; width:3px; height:3px; background:#d60000; border-radius:50%;}

/* 레이어팝업 */
.reportLayer {display:none; position:absolute; left:0; top:0; width:100%; height:100%; padding-top:90%; background:rgba(0,0,0,.65); z-index:60;}
.reportCont {position:relative; margin:0 auto;}
.reportCont .closeLayer {display:inline-block; position:absolute; right:7%; top:2.5%; width:10%; cursor:pointer;}
.arrest .reportCont {width:85%;}
.arrest .putWish {display:block; position:absolute; left:24%; bottom:9%; width:52%;}
.pastArrest .reportCont {width:89%;}
.pastArrest ol {overflow:hidden; position:absolute; left:12%; top:18.5%; width:76%;}
.pastArrest li {float:left; width:50%; padding:0 1.5% 6.5%;}
.pastArrest li:last-child {margin-left:25%;}
.pastArrest li div {position:relative;}
.pastArrest .open {position:absolute; left:0; top:0; width:100%;}
@media all and (min-width:375px){
	input.writeCode {width:200px;}
}
@media all and (min-width:480px){
	.report input {height:74px;}
	input.writeCode {width:240px; font-size:21px;}
	input.submitCode {width:150px;}
	.findCode {padding-top:38px; margin-top:53px;}
	.viewHint {padding-bottom:51px;}
	.viewHint ul {padding:24px 7.5%;}
	.viewHint li a {margin-bottom:15px;}
	.viewHint li input {width:38px; height:38px;}
	.evtNoti {padding:38px 14px 45px;}
	.evtNoti h3 strong {font-size:21px; line-height:20px; margin-left:12px; padding-left:2px; letter-spacing:2px; border-bottom:3px solid #000;}
	.evtNoti ul {padding-top:20px;}
	.evtNoti li {padding:0 0 0 12px; font-size:17px;}
	.evtNoti li:after {top:6px; width:4px; height:4px;}
}
</style>
<script>
<!--
$(function(){
	// 레이어팝업
	$('.viewPrev').click(function(){
		<% if date() < "2015-08-11" then %>
			alert('지난 현상금이 아직 없습니다.');
		<% else %>
			$('.pastArrest').show();
			window.parent.$('html,body').animate({scrollTop:440}, 300);
		<% end if %>
	});
	$('.closeLayer').click(function(){
		$('.reportLayer').hide();
		document.frm.itemid.value = "";
	});

	<% If chkval1 <> "" And chkval2 <> "" And chkval3 <> "" Then %>
	$('.openPdt').css("display","block");
	<% end if %>
});

//숫자
function SetNum(obj){
	 val=obj.value;
	 re=/[^0-9]/gi;
	 obj.value=val.replace(re,"");
}

//실행
function jsevt_go(){
	<% if Not(IsUserLoginOK) then %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsevtlogin();
			return;
		<% end if %>	
	<% end if %>

	if (document.frm.itemid.value=="")
	{
		alert("상품번호를 입력해주세요.");
		document.frm.itemid.focus();
		return;
	}
	else
	{
		var result;
		$.ajax({
			type:"GET",
			url:"/event/etc/doeventsubscript/doEventSubscript65229.asp",
			data: $("#frm").serialize(),
			dataType: "text",
			async:false,
			cache:true,
			success : function(Data){
				result = jQuery.parseJSON(Data);

				if (result.stcode=="77")
				{
					alert("이벤트에 응모를 하려면 로그인이 필요합니다.");
					return;
				}
				else if (result.stcode=="55")
				{
					alert("잘못된 접근입니다.");
					return;
				}
				else if (result.stcode=="99")
				{
					alert("존재하지 않는 이벤트 입니다.");
					return;
				}
				else if (result.stcode=="88")
				{
					alert("죄송합니다. 이벤트 기간이 아닙니다.");
					return;
				}
				else if (result.stcode=="888")
				{
					alert("오전 10시 부터 신고 하실 수 있습니다.");
					return;
				}
				else if (result.stcode=="22")
				{
					alert("상품당 2회까지만 가격입력이 가능합니다.");
					return;
				}
				else if (result.stcode=="999")
				{
					alert("다시 신고 하시려면 \n카카오톡으로 공유하고, 응모기회 한 번 더 받으세요!");
					return;
				}
				else if (result.stcode=="00")
				{
					if (result.rcode == "2")
					{
						$('.openPdt').css("display","block");
					}
					$('.arrest').show();
					window.parent.$('html,body').animate({scrollTop:400}, 300);
					return;
				}
			}
		});
	}
}

//카카오
function kakaosendcall(){
	<% If IsUserLoginOK Then %>
		<% If date() >="2015-08-10" and date() <"2015-08-15" Then %>
			var result;
			$.ajax({
				type:"GET",
				url: "/event/etc/doeventsubscript/doEventSubscript65229.asp",
				data: "mode=kakao",
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if (result.stcode=="11")
					{
						alert("상품코드 신고 내역이 없습니다. 신고 후에 초대 해주세요");
						return;
					}
					else if (result.stcode=="22")
					{
						parent_kakaolink('[텐바이텐] 현상금을 노려라!\n\n텐바이텐 구경하면서\n상품 찾고, 이벤트 참여하자!\n\n매일 현상금\n5만원을 지원합니다!\n오직 텐바이텐 Mobile & APP에서만!' , 'http://webimage.10x10.co.kr/eventIMG/2015/65229/bnr_kakao.jpg' , '200' , '200' , '<%=evt_url%>' );
						return false;
					}
					else if (result.stcode=="33")
					{
						alert("오늘의 기회는 끝! 내일을 기다려 주세요!");
						return;
					}
					else if (result.stcode=="99")
					{
						alert("10시 이후 부터 친구에게 알려 줄 수 있어요.");
						return;
					}
					else if (result.stcode=="888")
					{
						alert("10시 이후 부터 친구에게 알려 줄 수 있어요.");
						return;
					}
				}
			});
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		<% If isapp="1" Then %>
			calllogin();
			return;
		<% else %>
			jsevtlogin();
			return;
		<% End If %>
	<% End If %>
}

//wish
function TnAddFavoritePrd(iitemid){
	<% If IsUserLoginOK() Then %>
		<% If isApp="1" or isApp="2" Then %>
			fnAPPpopupBrowserURL("위시폴더","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popWishFolder.asp?itemid="+iitemid+"&ErBValue=3");
		<% else %>
			top.location.href="/common/popWishFolder.asp?itemid="+iitemid+"&ErBValue=3";
		<% end if %>
	<% Else %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsevtlogin();
			return;
		<% end if %>
	<% End If %>
}

function chknum(v){
	if (v == "1"){
		document.frm.itemid.value = "<%=tmpitemid1%>";
	}else if (v == "2"){
		document.frm.itemid.value = "<%=tmpitemid2%>";
	}else if (v == "3"){
		document.frm.itemid.value = "<%=tmpitemid3%>";
	}
}
//-->
</script>
<div class="mEvt65229">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/tit_reward.gif" alt="현상금을 노려라!" /></h2>
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/txt_wanted.gif" alt="WANTED" /></h3>
	<div class="todayWanted">
		<p class="reward"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/txt_gift_card.png" alt="50,000원 텐바이텐 기프트카드 10명" /></p>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_wanted_08<%=tday%>_blind.jpg" alt="" /></div>
		<div class="openPdt" onclick="<%=rurl%>"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_wanted_08<%=tday%>_open.jpg" alt="" /></div>
	</div>
	
	<div class="viewHint">
		<% If Date() >= "2015-08-11" Then %>
		<ul>
			<li onclick="chknum('1');">
				<% If isapp = "1" Then %>
				<a href="" onclick="fnAPPpopupProduct('<%=tmpitemid1%>'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_hint08<%=tday%>_01.png" alt="" /></a>
				<% Else %>
				<a href="/category/category_itemprd.asp?itemid=<%=tmpitemid1%>" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_hint08<%=tday%>_01.png" alt="" /></a>
				<% End If %>
				<input type="radio" id="hint01"  name="spoint"/>
			</li>
			<li onclick="chknum('2');">
				<% If isapp = "1" Then %>
				<a href="" onclick="fnAPPpopupProduct('<%=tmpitemid2%>'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_hint08<%=tday%>_02.png" alt="" /></a>
				<% Else %>
				<a href="/category/category_itemprd.asp?itemid=<%=tmpitemid2%>" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_hint08<%=tday%>_02.png" alt="" /></a>
				<% End If %>
				<input type="radio" id="hint02" name="spoint"/>
			</li>
			<li onclick="chknum('3');">
				<% If isapp = "1" Then %>
				<a href="" onclick="fnAPPpopupProduct('<%=tmpitemid3%>'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_hint08<%=tday%>_03.png" alt="" /></a>
				<% Else %>
				<a href="/category/category_itemprd.asp?itemid=<%=tmpitemid3%>" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_hint08<%=tday%>_03.png" alt="" /></a>
				<% End If %>
				<input type="radio" id="hint03"  name="spoint"/>
			</li>
		</ul>
		<% End If %>
		<form name="frm" id="frm" method="get" style="margin:0px;">
		<input type="hidden" name="mode" value="insert">
		<div class="report">
			<input type="tel" placeholder="숫자 7자리 상품코드" class="writeCode" name="itemid" onkeypress="SetNum(this);" onblur="SetNum(this)" style="IME-MODE: disabled" maxlength="9"/>
			<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/65229/btn_report.gif" alt="신고하기" class="submitCode" onclick="jsevt_go();return false;"/>
		</div>
		</form>

		<div class="findCode">
			<a href="#" class="viewPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/btn_past.png" alt="지난 현상금 보기" /></a>
		</div>
	</div>

	<div><a href="" onclick="kakaosendcall();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/btn_kakao.gif" alt="카카오톡으로 공유하고, 당첨확률 높이자!" /></a></div>
	<div class="evtNoti">
		<h3><strong>유 의 사 항</strong></h3>
		<ul>
			<li>텐바이텐 고객님을 위한 이벤트입니다. 비회원이신 경우 회원가입 후 참여해주세요.</li>
			<li>본 이벤트는 텐바이텐 모바일과 APP에서만 참여 가능합니다.</li>
			<li>본 이벤트는 ID 당 1일 1회 응모 가능하며, 친구 초대시 한번 더 응모 기회가 주어집니다.</li>
			<li>당첨시 제세공과금은 고객 부담입니다.</li>
			<li>당첨자는 익일 오전 11시에 텐바이텐 공지사항을 통해 발표됩니다.</li>
		</ul>
	</div>
	<div id="arrest" class="reportLayer arrest">
		<div class="reportCont">
			<span class="closeLayer"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/btn_layer_close.png" alt="닫기" /></span>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_arrest_08<%=tday%>.png" alt="검거완료" /></p>
			<a href="" onclick="TnAddFavoritePrd('<%=tItemid%>');return false;" class="putWish"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/btn_wish.gif" alt="WISH담기" /></a>
		</div>
	</div>
	<div id="pastArrest" class="reportLayer pastArrest">
		<div class="reportCont">
			<span class="closeLayer"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/btn_layer_close.png" alt="닫기" /></span>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/tit_past.png" alt="지난 현상금 보기" /></p>
			<ol>
				<li>
					<div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/txt_blind_0810.png" alt="8월 10일" />
						<% If Date() >= "2015-08-11" Then %>
						<p class="open">
							<% If isapp = "1" Then %>
							<a href="#" onclick="fnAPPpopupProduct('1322304'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_past_0810.jpg" alt="8월 10일 정답상품" /></a>
							<% Else %>
							<a href="/category/category_itemprd.asp?itemid=1322304" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_past_0810.jpg" alt="8월 10일 정답상품" /></a>
							<% End If %>
						</p>
						<% End If %>
					</div>
				</li>
				<li>
					<div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/txt_blind_0811.png" alt="8월 11일" />
						<% If Date() >= "2015-08-12" Then %>
						<p class="open">
							<% If isapp = "1" Then %>
							<a href="#" onclick="fnAPPpopupProduct('1243628'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_past_0811.jpg" alt="8월 11일 정답상품" /></a>
							<% Else %>
							<a href="/category/category_itemprd.asp?itemid=1243628" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_past_0811.jpg" alt="8월 11일 정답상품" /></a>
							<% End If %>
						</p>
						<% End If %>
					</div>
				</li>
				<li>
					<div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/txt_blind_0812.png" alt="8월 12일" />
						<% If Date() >= "2015-08-13" Then %>
						<p class="open">
							<% If isapp = "1" Then %>
							<a href="#" onclick="fnAPPpopupProduct('1246002'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_past_0812.jpg" alt="8월 12일 정답상품" /></a>
							<% Else %>
							<a href="/category/category_itemprd.asp?itemid=1246002" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_past_0812.jpg" alt="8월 12일 정답상품" /></a>
							<% End If %>
						</p>
						<% End If %>
					</div>
				</li>
				<li>
					<div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/txt_blind_0813.png" alt="8월 13일" />
						<% If Date() >= "2015-08-14" Then %>
						<p class="open">
							<% If isapp = "1" Then %>
							<a href="#" onclick="fnAPPpopupProduct('1321876'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_past_0813.jpg" alt="8월 13일 정답상품" /></a>
							<% Else %>
							<a href="/category/category_itemprd.asp?itemid=1321876" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_past_0813.jpg" alt="8월 13일 정답상품" /></a>
							<% End If %>
						</p>
						<% End If %>
					</div>
				</li>
				<li>
					<div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/txt_blind_0814.png" alt="8월 14일" />
						<% If Date() >= "2015-08-15" Then %>
						<p class="open">
							<% If isapp = "1" Then %>
							<a href="#" onclick="fnAPPpopupProduct('1103524'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_past_0814.jpg" alt="8월 14일 정답상품" /></a>
							<% Else %>
							<a href="/category/category_itemprd.asp?itemid=1103524" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_past_0814.jpg" alt="8월 14일 정답상품" /></a>
							<% End If %>
						</p>
						<% End If %>
					</div>
				</li>
			</ol>
		</div>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->