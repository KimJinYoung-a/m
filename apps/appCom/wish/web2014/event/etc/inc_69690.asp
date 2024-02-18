<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 사대천왕 A
' History : 2016-03-17 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid , strSql
dim itemid1, itemid2, itemid3, itemid4
Dim lastusercnt '앱마지막 로그인 카운트
Dim logusercnt '로그인내역 카운트
Dim evt_pass : evt_pass = False '이벤트 응모 여부 chkflag

IF application("Svr_Info") = "Dev" THEN
	eCode = "66073"
	itemid1 = "1226544"	''라인 공기청정기
	itemid2 = "1232621"	''아이리버 스피커
	itemid3 = "1238973"	''에코백
	itemid4 = "1238010"	''토끼
Else
	eCode = "69690"
	itemid1 = "1452537"	''라인 공기청정기
	itemid2 = "1452460"	''아이리버 스피커
	itemid3 = "1452414"	''에코백
	itemid4 = "1452385"	''토끼
End If

userid = getEncLoginUserID

If IsUserLoginOK() Then

	strSql = "select min(convert(varchar(10),regdate,120)) from db_contents.dbo.tbl_app_regInfo where userid = '" & userid & "' "
	rsget.CursorLocation = adUseClient
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly

	IF Not rsget.Eof Then
		lastusercnt = rsget(0) '// 날짜
	Else
		lastusercnt = ""
	End IF
	rsget.close

	If lastusercnt <> "" Then '//어쨌든 값은 있음
		If lastusercnt >= "2016-03-21" Then '// 기준 충족시
			evt_pass = true
		Else
			evt_pass = false
		End If 
	Else '//값 없음 ios라던가 값이 없을 수 있음
		strSql = "select min(convert(varchar(10),regdate,120)) from db_contents.[dbo].[tbl_app_NidInfo] WHERE lastuserid = '"& userid &"'"
		rsget.CursorLocation = adUseClient
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly

		IF Not rsget.Eof Then
			logusercnt = rsget(0) '// 날짜
		Else
			logusercnt = ""
		End IF
		rsget.close

		If logusercnt <> "" Then '//여기엔 있다
			If logusercnt >= "2016-03-21" Then '// 기준 충족시
				evt_pass = true
			Else
				evt_pass = false
			End If
		Else
			evt_pass = false
		End if
	End If 

End If 

'If userid = "baboytw" then
'Response.write lastusercnt &"<br/>"
'Response.write logusercnt &"<br/>"
'Response.write evt_pass
'End If 

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("[텐바이텐] 사대천왕")
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=69691")
snpPre = Server.URLEncode("10x10 이벤트")

'기본 태그
snpTag = Server.URLEncode("텐바이텐 사대천왕")
snpTag2 = Server.URLEncode("#10x10")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 사대천왕\n\n신규 앱 설치자에게\n엄청난 혜택을 준비했습니다.\n\n사대천왕중 하나의 상품을\n4천원에 만나볼 수 있는 기회!\n\n지금 APP 설치하고 확인해보세요!\n오직 텐바이텐 APP에서"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/69690/img_kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}
.mEvt69690 {position:relative;}
.mEvt69690 button {background:transparent;}
.item {overflow:hidden;}
.item li {float:left; width:50%;}
.btnArea {position:relative;}
.btnArea .btnApply {display:block; position:absolute; left:0; top:25.88%; width:100%; background:transparent; vertical-align:top;}
.shareSns {position:relative;}
.shareSns ul {position:absolute; left:7%; top:52%; width:86%; height:38%;}
.shareSns ul li {float:left; width:25%; height:100%; padding:0 2%;}
.shareSns ul li a {display:block; width:100%; height:100%; text-indent:-9999px;}
.evtNoti {color:#fff; padding:2rem 4% 2.5rem; background:#454545;}
.evtNoti h3 {padding-bottom:1.2rem;}
.evtNoti h3 strong {display:inline-block; font-size:1.4rem; line-height:2rem; padding-left:2.5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69690/ico_mark.png) no-repeat 0 0; background-size:1.9rem 1.9rem;}
.evtNoti li {position:relative; padding-left:1rem; font-size:1rem; line-height:1.4; letter-spacing:-0.003em;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.5rem; width:0.4rem; height:1px; background:#fff;}

/* 레이어팝업 */
.resultLayer {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.6);}
.layerCont {position:absolute; left:0; top:15%; width:100%;}
.layerCont .btnClose {position:absolute; right:12%; top:1.5rem; width:3rem; height:3rem; z-index:100;}
.layerCont .win {position:relative;}
.layerCont .goBuy {display:block; position:absolute; left:16%; bottom:5%; width:70%; height:26%; text-indent:-9999px;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt69690").offset().top}, 0);
//	$('.btnClose').click(function(){
//		$('.resultLayer').fadeOut();
//	});
});

function fnClosemask()
{
	$('.resultLayer').fadeOut();
	document.location.reload();
}

function addshoppingBag(v){
	<% If IsUserLoginOK() Then %>
		var str = $.ajax({
			type: "GET",
			url: "/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript69690.asp",
			data: "mode=G&getitemno="+v,
			dataType: "text",
			async: false
		}).responseText;

		if(str=="OK") {
			var frm = document.sbagfrm;
			var optCode = "0000";
		
			if (!frm.itemea.value){
				alert('장바구니에 넣을 수량을 입력해주세요.');
				return;
			}

			if (v=="1"){
				frm.itemid.value = "<%= itemid1 %>";
			}
			else if (v=="2"){
				frm.itemid.value = "<%= itemid2 %>";
			}
			else if (v=="3"){
				frm.itemid.value = "<%= itemid3 %>";
			}
			else if (v=="4"){
				frm.itemid.value = "<%= itemid4 %>";
			}
			else{
				frm.itemid.value = "";
			}

			
			frm.itemoption.value = optCode;
			frm.mode.value = "DO3"; 
			frm.target = "evtFrmProc"; 
			frm.action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp";
			frm.submit();
			return;
		}else{
			alert('오류가 발생했습니다.');
			return false;
		}
	<% else %>
		<% if isApp = "1" then %>
			calllogin();
			return false;
		<% else %>
			alert('APP 에서만 진행 되는 이벤트 입니다.');
			return false;
		<% end if %>
	<% end if %>
}

function getcouponreal(){
//alert("시스템 오류 입니다");
//return false;
<% If Now() > #03/21/2016 10:00:00# and Now() < #03/27/2016 23:59:59# Then %>
	<% If IsUserLoginOK Then %>
		<% if isApp=1 then %>
			$.ajax({
				type:"POST",
				url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript69690.asp",
		        data: $("#frmEvt").serialize(),
		        dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								var str;
								for(var i in Data)
								{
									 if(Data.hasOwnProperty(i))
									{
										str += Data[i];
									}
								}
								str = str.replace("undefined","");
								res = str.split("|");
								if (res[0]=="OK")
								{
									$("#viewResult").empty().html(res[1]);
									$('.resultLayer').fadeIn();
									//$('.resultLayer .result').show();
									window.parent.$('html,body').animate({scrollTop:100}, 300);
								}
								else
								{
									errorMsg = res[1].replace(">?n", "\n");
									alert(errorMsg );
									$(".mask").hide();
									//document.location.reload();
									<% If isapp="1" Then %>
										document.location.href = "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>";
									<% else %>
										document.location.href = "/event/eventmain.asp?eventid=<%= eCode %>";
									<% end if %>
									return false;
								}
							} else {
								alert("잘못된 접근 입니다1.");
								//document.location.reload();
								<% If isapp="1" Then %>
									document.location.href = "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>";
								<% else %>
									document.location.href = "/event/eventmain.asp?eventid=<%= eCode %>";
								<% end if %>
								return false;
							}
						}
					}
				},
				error:function(jqXHR, textStatus, errorThrown){
					alert("잘못된 접근 입니다!");
					//document.location.reload();
					<% If isapp="1" Then %>
						document.location.href = "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>";
					<% else %>
						document.location.href = "/event/eventmain.asp?eventid=<%= eCode %>";
					<% end if %>
					return false;
				}
			});
		<% else %>
			alert('APP 에서만 진행 되는 이벤트 입니다.');
			return false;
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			alert('APP 에서만 진행 되는 이벤트 입니다.');
			return false;
		<% end if %>
	<% End If %>
<% else %>
	alert('이벤트 기간이 아닙니다!');
	return;
<% end if %>
}

function getsnscnt(snsno) {
	<% If IsUserLoginOK() Then %>
		var str = $.ajax({
			type: "GET",
			url: "/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript69690.asp",
			data: "mode=S&snsno="+snsno,
			dataType: "text",
			async: false
		}).responseText;
		if(str=="tw") {
			popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
		}else if(str=="fb"){
			popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
		}else if(str=="ka"){
			parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');
		}else if(str=="ln"){
			popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','','');
		}else{
			alert('오류가 발생했습니다.');
			return false;
		}
	<% else %>
		<% if isApp = "1" then %>
			calllogin();
			return false;
		<% else %>
			alert('APP 에서만 진행 되는 이벤트 입니다.');
			return false;
		<% end if %>
	<% end if %>
}

</script>
<div class="mEvt69690">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/69690/tit_4000.png" alt="특별한 당신에게 보이는 사대천왕 - 앱에서 처음 로그인한 분에게 드리는 4천원의 행복 지금 응로하고 확인해보세요!" /></h2>
	<ul class="item">
		<li><a href="" onclick="fnAPPpopupProduct('1452414'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69690/img_item_01.jpg" alt="미밈 프로젝트 에코백" /></a></li>
		<li><a href="" onclick="fnAPPpopupProduct('841828'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69690/img_item_02.jpg" alt="미니토끼 LED램프" /></a></li>
		<li><a href="" onclick="fnAPPpopupProduct('1440324'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69690/img_item_03.jpg" alt="라인프렌즈 공기청정기" /></a></li>
		<li><a href="" onclick="fnAPPpopupProduct('1387323'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69690/img_item_04.jpg" alt="아이리버 스피커" /></a></li>
	</ul>
	<div class="btnArea">
		<button class="btnApply" onclick="getcouponreal();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69690/btn_apply.png" alt="응모하기" /></button>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/69690/txt_delivery.png" alt="사대천왕은 3월 28일 순차적으로 일괄 배송됩니다." /></div>
	</div>
	<div class="shareSns">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69690/txt_share.png" alt="친구에게 사대천왕 알려주고 즐거운 혜택 나눠갖자!" /></p>
		<ul>
			<li><a href="" onclick="getsnscnt('fb');return false;">facebook</a></li>
			<li><a href="" onclick="getsnscnt('tw');return false;">twitter</a></li>
			<li><a href="" onclick="getsnscnt('ka');return false;">kakaotalk</a></li>
			<li><a href="" onclick="getsnscnt('ln');return false;">line</a></li>
		</ul>
	</div>
	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>본 이벤트는 앱에서 로그인 이력이 한번도 없는 고객님을 위한 이벤트입니다.</li>
			<li>ID당 1회만 구매가 가능합니다.</li>
			<li>이벤트는 상품 품절 시 조기 마감 될 수 있습니다.</li>
			<li>상품은 즉시결제로만 구매가 가능하며 배송 후 반품/교환/취소가 불가능합니다.</li>
			<li>구매하신 상품은 3월 28일 순차적으로 일괄 배송될 예정입니다.</li>
			<li>5만원 이상의 쿠폰할인을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
			<li>개인정보 확인이 되지 않을 시에는 당첨이 취소될 수 있습니다.</li>
		</ul>
	</div>

	<div class="resultLayer">
		<div class="LayerCont"  id="viewResult"></div>
	</div>
</div>
<form name="sbagfrm" method="post" action="" style="margin:0px;">
<input type="hidden" name="mode" value="add" />
<input type="hidden" name="itemid" value="" />
<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
<input type="hidden" name="itemoption" value="0000" />
<input type="hidden" name="userid" value="<%= getloginuserid() %>" />
<input type="hidden" name="isPresentItem" value="" />
<input type="hidden" name="itemea" readonly value="1" />
</form>
<form method="post" name="frmEvt" id="frmEvt">
	<input type="hidden" name="mode" id="mode" value="I">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->