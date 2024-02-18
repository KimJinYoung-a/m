<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 오벤져스 APP
' History : 2016-05-12 허진원 생성
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
Dim lastusercnt '앱마지막 로그인 카운트
Dim logusercnt '로그인내역 카운트
Dim evt_pass : evt_pass = False '이벤트 응모 여부 chkflag

IF application("Svr_Info") = "Dev" THEN
	eCode = "66128"
Else
	eCode = "70684"
End if

userid = getEncLoginUserID

If IsUserLoginOK() Then

	'// APP등록 정보에서 확인
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
		If lastusercnt >= "2016-05-16" Then '// 기준 충족시
			evt_pass = true
		Else
			evt_pass = false
		End If 
	Else '//값 없음 ios라던가 값이 없을 수 있음
		'// APP 기기정보에서 확인
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
			If logusercnt >= "2016-05-16" Then '// 기준 충족시
				evt_pass = true
			Else
				evt_pass = false
			End If
		Else
			evt_pass = false
		End if
	End If 

End If 


'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
dim snpTitle, snpLink, snpImg
snpTitle = Server.URLEncode("[텐바이텐] 오벤져스")
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=70686")
snpImg = Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2016/70686/etcitemban20160512185825.jpeg")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 오벤져스\n\n신규 앱 설치자에게 드리는\n엄청난 혜택을 준비했습니다.\n\n텐바이텐에서 잘나가는 하나의 상품을 5천원에 만나볼 수 있는 기회!\n\n지금 APP 설치하고 확인해보세요!\n오직 텐바이텐 APP에서!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/70686/etcitemban20160512185825.jpeg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url : kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
%>
<style type="text/css">
img {vertical-align:top;}
button {outline:none; background-color:transparent;}
.item ul {overflow:hidden;}
.item ul li {float:left; width:50%;}
.btnApply {width:100%;}
.shareSns {position:relative;}
.shareSns ul {position:absolute; left:15%; top:46%; width:70%; height:38%;}
.shareSns ul li {float:left; width:33%; height:100%; padding:0 2%;}
.shareSns ul li a {display:block; width:100%; height:100%; text-indent:-9999px;}
.evtNoti {color:#fff; padding:2rem 4% 2.5rem; background:#30363a;}
.evtNoti h3 {padding-bottom:1.2rem;}
.evtNoti h3 strong {display:inline-block; font-size:1.4rem; line-height:2rem; padding-left:2.5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/70686/m/ico_mark.png) no-repeat 0 0; background-size:1.9rem 1.9rem;}
.evtNoti li {position:relative; padding-left:1rem; font-size:1rem; line-height:1.4; letter-spacing:-0.003em;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.5rem; width:0.4rem; height:1px; background:#fff;}

/* 레이어팝업 */
.resultLayer {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.6);}
.layerCont {position:absolute; left:0; top:24%; width:100%;}
.layerCont .btnClose {position:absolute; right:12%; top:1.5rem; width:2rem; height:2rem; z-index:100;}
.layerCont .win {position:relative;}
.layerCont .goBuy {display:block; position:absolute; left:15%; bottom:11%; width:70%; height:18%; text-indent:-9999px;}
.layerCont .code {display:block; position:absolute; left:11%; bottom:2%; width:70%; height:3.5%; font-size:0.6rem; color:#886600; font-family:verdana, tahoma, arial, sans-serif; z-index:50;}
</style>
<script type="text/javascript">
$(function(){
	// 캡션 변경
	fnAPPchangPopCaption('이벤트');
});

function fnClosemask() {
	$("#viewResult").hide();
	document.location.reload();
}

function fnCheckHero(){
<% if isApp = "1" then %>
	<% If IsUserLoginOK() Then %>
		<% if (evt_pass) then %>
		$.ajax({
			type: "GET",
			url: "/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript70684.asp",
			data: "mode=G",
			cache: false,
			success: function(str) {
				str = str.replace("undefined","");
				res = str.split("|");
				if (res[0]=="OK") {
					$("#viewResult").empty().html(res[1]);
					$("#viewResult").fadeIn();
					window.parent.$('html,body').animate({scrollTop:$("#viewResult .layerCont").offset().top-50}, 300);
				} else {
					errorMsg = res[1].replace(">?n", "\n");
					alert(errorMsg );
					$(".mask").hide();

					<% If isapp="1" Then %>
						document.location.replace("/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>");
					<% else %>
						document.location.replace("/event/eventmain.asp?eventid=<%= eCode %>");
					<% end if %>
					return false;
				}
			}
			,error: function(err) {
				console.log(err.responseText);
				alert("통신중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
			}
		});
		<% else %>
			alert('APP에서 처음 로그인한 고객대상으로 응모 가능합니다.');
			return false;
		<% end if %>
	<% else %>
			calllogin();
			return false;
	<% end if %>
<% else %>
	alert('APP 에서만 진행 되는 이벤트 입니다.');
	return false;
<% end if %>
}

function addshoppingBag(v){
	<% If IsUserLoginOK() Then %>
		var frm = document.sbagfrm;
		frm.itemid.value = v;
		frm.mode.value = "DO3"; 
		frm.target = "evtFrmProc"; 
		frm.action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp";
		frm.submit();
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

// SNS 공유 팝업 (본 이벤트는 비하인드라 APP에서의 연결은 사용안함)
function fnAPPRCVpopSNS(){
    return false;
}
</script>
<div class="mEvt70684">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/70684/m/tit_5venzers.png" alt="텐바이텐 오벤져스 - 앱에서 처음 로그인한 분께 드리는 5천원의 행복" /></h2>
	<div class="item">
		<ul>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/70684/m/img_5venzers_item1.png" alt="인스탁스 카메라" /></li>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/70684/m/img_5venzers_item2.png" alt="스티키몬스터 보틀" /></li>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/70684/m/img_5venzers_item3.png" alt="스파이더맨 탁상 선풍기" /></li>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/70684/m/img_5venzers_item4.png" alt="500 마일리지" /></li>
		</ul>
	</div>
	<p>
		<button type="button" onclick="fnCheckHero();" class="btnApply"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70684/m/btn_5venzers.png" alt="응모하기" /></button>
	</p>
	<div class="shareSns">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70684/m/sns_5venzers.png" alt="" /></p>
		<ul>
			<li><a href="#" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;">facebook</a></li>
			<li><a href="#" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');return false;">kakaotalk</a></li>
			<li><a href="#" onclick="popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','',''); return false;">line</a></li>
		</ul>
	</div>
	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<l1i>본 이벤트는 앱에서 로그인 이력이 한번도 없는 고객님을 위한 이벤트입니다.</li>
			<li>ID당 1회만 구매가 가능합니다.</li>
			<li>이벤트는 상품 품절 시 조기 마감 될 수 있습니다.</li>
			<li>이벤트는 즉시결제로만 구매가 가능하며, 배송 후 반품/교환/구매취소가 불가능합니다.</li>
		</ul>
	</div>

	<!-- 응모결과 레이어팝업 -->
	<div class="resultLayer" id="viewResult"></div>
	<!--// 응모결과 레이어팝업 -->
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
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
