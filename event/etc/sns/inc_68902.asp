<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 텐바이텐을 with 영화'좋아해줘' 좋아해줘
' History : 2016-01-26 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
Dim eCode , userid, i
Dim iCCurrpage , iCPageSize , iCTotCnt , iCTotalPage
Dim iCPerCnt , arrCList , intCLoop
dim cEComment , pagereload

	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	pagereload	= requestCheckVar(request("pagereload"),2)

dim currenttime
	currenttime =  now()

IF application("Svr_Info") = "Dev" THEN
	eCode   =  66019
Else
	eCode   =  68902
End If

userid = GetEncLoginUserID()

dim commentcount
commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 4		'보여지는 페이지 간격
iCPageSize = 4		'풀단이면 15개	

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수
	
	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
set cEComment = nothing

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}
img {vertical-align:top;}

.likeCont {position:relative;}
.movieInfo button {display:inline-block; position:absolute; top:38.5%; z-index:50; width:4.3%; background:transparent;}
.movieInfo .btnPrev {left:6%;}
.movieInfo .btnNext {right:6%;}
.step1 .fbArea {position:absolute; left:50%; top:54%; width:200px; padding:5px; margin-left:-100px; background:#fff;z-index:9999}
.step2 {background:url(http://webimage.10x10.co.kr/eventIMG/2016/68902/m/bg_pattern.png) repeat-y 0 0; background-size:100% auto;}
.step2 ul {overflow:hidden; padding:0 2%;}
.step2 li {float:left; width:33.33333%; padding:0 2% 2.2rem; text-align:center;}
.step2 li label {display:block; padding-bottom:1rem;}
.step2 .write {padding:0 4%;}
.step2 .btnApply {display:block; width:100%; margin-top:1rem;}
.step2 textarea {display:block; width:100%; height:10rem; border:0; border-radius:0; vertical-align:top;}
.step2 .goPreview {position:absolute; right:3.2%; top:0; width:18%;}
.likeList {padding:2rem 0 3.5rem; background:#fff;}
.likeList ul {overflow:hidden; padding:0 2% 0.5rem;}
.likeList li { float:left; width:50%; padding:1.5rem 1.6% 0;}
.likeList li .cmtWrap {position:relative;}
.likeList li.c01 .cmtWrap {background-color:#5772bb;}
.likeList li.c02 .cmtWrap {background-color:#51c7d9;}
.likeList li.c03 .cmtWrap {background-color:#fc72aa;}
.likeList li .cmtInfo {position:absolute; left:0; top:0; width:100%; height:100%; padding:17% 7% 16%; font-size:1.1rem; color:#fff;}
.likeList li .cmtInfo .num {position:absolute; left:7%; top:6%; font-weight:bold;}
.likeList li .cmtInfo .writer {position:absolute; right:7%; top:6%; font-weight:bold;}
.likeList li .cmtInfo .writer img {width:0.5rem; margin-left:3px;}
.likeList li .cmtInfo .txt {overflow-y:auto; width:100%; height:100%; padding:1rem; line-height:1.4; color:#111; background:#fff; -webkit-overflow-scrolling:touch;}
.likeList li .cmtInfo .delete {position:absolute; right:7%; bottom:3%; width:1rem;}
.likeList li .cmtInfo:after {display:inline-block; position:absolute; left:7%; bottom:3%; z-index:100; color:#fff; font-size:1rem;}
.likeList li.c01 .cmtInfo:after {content:'#유아인 #이미연 #커플';}
.likeList li.c02 .cmtInfo:after {content:'#김주혁 #최지우 #커플';}
.likeList li.c03 .cmtInfo:after {content:'#강하늘 #이솜 #커플';}
.preview .movieWrap {position:absolute; left:5%; top:37%; width:90%; padding:0.5rem; z-index:100; background:#fff; box-shadow:2px 2px 5px 1px rgba(0,0,0, .2);}
.preview .movieWrap .movie {overflow:hidden; position:relative; height:0; padding-bottom:54%; background:#000;}
.preview .movieWrap .movie  iframe {position:absolute; top:0; left:0; width:100%; height:100%; vertical-align:top;}
</style>
<script type="text/javascript">
<% if pagereload<>"" then %>
	setTimeout("pagedown()",500);
<% else %>
	setTimeout("pagup()",500);
<% end if %>

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-02-02" and left(currenttime,10)<="2016-02-11" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount > 0 then %>
				alert("이벤트는 1회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if (!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked))
				{
					alert('커플을 선택 해주세요');
					frm.spoint[0].focus();
					return false;
				}
				if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 200){
					alert("코맨트는 200자 까지만 작성이 가능합니다. 코맨트를 남겨주세요.");
					frm.txtcomm.focus();
					return false;
				}
				frm.action = "/event/lib/doEventComment.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmactNew.Cidx.value = cidx;
   		document.frmactNew.submit();
	}
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	}
}

function pagup(){
	window.$('html,body').animate({scrollTop:$(".mEvt68902").offset().top}, 0);
}

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#commentevt").offset().top}, 0);
}

$(function(){
	slideTemplate = new Swiper('.swiper',{
		loop:true,
		autoplay:3000,
		speed:700,
		pagination:".pagination",
		paginationClickable:true,
		nextButton:'.btnNext',
		prevButton:'.btnPrev',
		effect:'fade'
	});

	$(".goPreview").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 800);
	});
});
</script>
<div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/ko_KR/sdk.js#xfbml=1&version=v2.5&appId=417711631728635";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>
<div class="mEvt68902">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/68902/m/tit_like_10x10.png" alt="텐바이텐을 좋아해줘" /></h2>
	<div class="likeCont movieInfo">
		<div class="swiper-container swiper">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68902/m/img_slide_01.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68902/m/img_slide_02.jpg" alt="" /></div>
			</div>
		</div>
		<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68902/m/btn_prev.png" alt="이전" /></button>
		<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68902/m/btn_next.png" alt="다음" /></button>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68902/m/txt_preview_info.png" alt="시사회 일정:2016/02/16(화) 오후 8시 영등포CGV" /></p>
	</div>
	<div class="likeCont step1">
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/68902/m/txt_step_01.png" alt="Step1. 추측만 하지 말고 친구해!" /></div>
		<div class="fbArea">
			<div>
				<div class="fb-page" data-href="https://www.facebook.com/your10x10/?fref=ts" data-width="190" data-height="70" data-small-header="true" data-adapt-container-width="false" data-hide-cover="false" data-show-facepile="false"><div class="fb-xfbml-parse-ignore"><blockquote cite="https://www.facebook.com/your10x10/?fref=ts"><a href="https://www.facebook.com/your10x10/?fref=ts">텐바이텐(www.10x10.co.kr)</a></blockquote></div></div>
			</div>
		</div>
	</div>
	<%'<!-- 커플 선택 -->%>
	<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
	<input type="hidden" name="mode" value="add">
	<input type="hidden" name="pagereload" value="ON">
	<input type="hidden" name="iCC" value="1">
	<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
	<input type="hidden" name="eventid" value="<%= eCode %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
	<input type="hidden" name="gubunval">
	<input type="hidden" name="isApp" value="<%= isApp %>">	
	<div class="likeCont step2" id="commentevt">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/68902/m/txt_step_02.png" alt="Step2. 댓글만 달지 말고 대시해! 가장 기대되는 커플을 선택해 기대평을 남기면 응모완료!" /></h3>
		<a href="#preview" class="goPreview"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68902/m/btn_preview.png" alt="예고편 보기" /></a>
		<ul>
			<li>
				<label for="c01"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68902/m/img_couple_01.png" alt="유아인♥이미연" /></label>
				<input type="radio" id="c01" name="spoint" value="1" />
			</li>
			<li>
				<label for="c02"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68902/m/img_couple_02.png" alt="김주혁♥최지우" /></label>
				<input type="radio" id="c02" name="spoint" value="2" />
			</li>
			<li>
				<label for="c03"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68902/m/img_couple_03.png" alt="강하늘♥이솜" /></label>
				<input type="radio" id="c03" name="spoint" value="3" />
			</li>
		</ul>
		<div class="write">
			<textarea cols="30" rows="5" id="txtcomm" name="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%>><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
			<button class="btnApply" onclick="jsSubmitComment(document.frmcom); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68902/m/btn_apply.png" alt="응모하기" /><button>
		</div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/68902/m/bg_film.png" alt="" /></div>
	</div>
	</form>
	<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="pagereload" value="ON">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
	<input type="hidden" name="eventid" value="<%= eCode %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	<input type="hidden" name="isApp" value="<%= isApp %>">
	</form>
	<%'<!-- 코멘트 리스트 -->%>
	<% IF isArray(arrCList) THEN %>
	<div class="likeCont likeList">
		<ul>
			<% For intCLoop = 0 To UBound(arrCList,2) %>
			<li class="c0<%=arrCList(3,intCLoop)%>">
				<div class="cmtWrap">
					<div class="cmtInfo">
						<p class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
						<p class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%> <% If arrCList(8,i) <> "W" Then %><img src="http://webimage.10x10.co.kr/eventIMG/2016/68902/m/ico_mobile.png" alt="모바일에서 작성" /><% End If %></p>
						<p class="txt"><%=db2html(arrCList(1,intCLoop))%></p>
						<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
						<a href="" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;" class="delete"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68902/m/btn_delete.png" alt="삭제" /></a>
						<% end if %>
					</div>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/68902/m/bg_cmt.png" alt="" /></div>
				</div>
			</li>
			<% Next %>
		</ul>
		<% IF isArray(arrCList) THEN %>
			<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
		<% end if %>
	</div>
	<% end if %>
	<div class="likeCont preview" id="preview">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/68902/m/txt_video.png" alt="영화 좋아해줘 예고편" /></h3>
		<div class="movieWrap">
			<div class="movie">
				<iframe src="http://serviceapi.rmcnmv.naver.com/flash/outKeyPlayer.nhn?vid=912CF399604EA322402801D2991DD77D6E08&outKey=V129041e52d82e261c1f492ce3428178337279b1aaa2674d1cb2092ce342817833727&controlBarMovable=true&jsCallable=true&skinName=default" frameborder="0" title="좋아해줘 메인예고편" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen=""></iframe>
			</div>
		</div>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->