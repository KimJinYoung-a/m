<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 기승전쇼핑_빼주세요, APP 쿠폰
' History : 2014.09.04 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/etc/event54738Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim eCode, userid, sub_idx, i, intCLoop, subscriptcount, leaficonimg
	eCode=getevt_code
	userid = getloginuserid()
	subscriptcount=0
dim iCPerCnt, iCPageSize, iCCurrpage
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호

IF iCCurrpage = "" THEN iCCurrpage = 1
iCPageSize = 4
iCPerCnt = 4		'보여지는 페이지 간격
	
dim ccomment
set ccomment = new Cevent_etc_common_list
	ccomment.FPageSize        = iCPageSize
	ccomment.FCurrpage        = iCCurrpage
	ccomment.FScrollCount     = iCPerCnt
	ccomment.event_subscript_one
	ccomment.frectordertype="new"
	ccomment.frectevt_code    = eCode
	ccomment.event_subscript_paging
		
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.mEvt54739 {}
.mEvt54739 img {vertical-align:top; width:100%;}
.mEvt54739 p {max-width:100%;}
.melody .section, .melody .section h3 {margin:0; padding:0;}
.melody .intro {position:relative;}
.melody .intro .movie {position:absolute; width:100%; top:23%; left:0; padding:0 4.79166%; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box;}
.melody .intro .movie .youtube {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#000;}
.melody .intro .movie .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%;}
.melody .intro .btnSite {position:absolute; bottom:20%; left:0; width:100%;}
.melody .intro .btnSite a {display:block; margin:0 17%; text-align:center;}
.melody .intro .btnTime {position:absolute; bottom:3%; left:0; width:100%;}
.melody .intro .btnTime a {display:block; margin:0 5%; text-align:center;}
.melody .intro .lineup {position:absolute; top:12%; left:0; width:100%;}
.melody .intro .lineup .btnClose {position:absolute; bottom:3%; left:0; width:100%; text-align:center;}
.melody .intro .lineup .btnClose img {width:56%; cursor:pointer;}
.melody .md {padding-bottom:10%; background-color:#ffdcaa;}
.melody .md ul {overflow:hidden; padding:0 3%;}
.melody .md ul li {float:left; width:50%; margin-top:7%;}
.melody .md ul li a {display:block; margin:0 7%;}
.melody .md ul li:nth-child(5) {clear:both; margin:7% 25% 0;}
.melody .comment-event {border:5px solid #141b66; background-color:#ffdcaa;}
.melody .comment-event .field {padding:0 2%; background:#fff url(http://webimage.10x10.co.kr/eventIMG/2014/54739/bg_pattern_line.gif) repeat 50% 50%; background-size:4px 4px;}
.melody .comment-event .field fieldset {border:0;}
.melody .comment-event .field legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.melody .comment-event .field ul {overflow:hidden; padding:5% 0;}
.melody .comment-event .field ul li {float:left; width:25%; padding:0 1%; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box;}
.melody .comment-event .field ul li label {display:block; margin-top:5%;}
.melody .comment-event .field ul li input[type=radio] {border-radius:20px;}
.melody .comment-event .field ul li input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/eventIMG/2014/54739/bg_radio.png) no-repeat 50% 50%; background-size:9px 9px;}
.melody .comment-event .field textarea {width:100%; padding:3%; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box; color:#888; font-size:12px;}
.melody .comment-event .field input[type=image] {width:100%;}
.melody .comment-list {background-color:#ffdcaa; padding:7% 3% 5%;}
.melody .comment-list .article {position:relative; min-height:100px; margin-bottom:20px; padding:18px 15px 20px 108px; background-color:#fff; box-shadow: 0 0 5px 5px rgba(196,196,196,0.1); text-align:left;}
.melody .comment-list .color1 .author {border-bottom:1px solid #cd952a;}
.melody .comment-list .color2 .author {border-bottom:1px solid #ff9c00;}
.melody .comment-list .color3 .author {border-bottom:1px solid #feafa0;}
.melody .comment-list .color4 .author {border-bottom:1px solid #d96100;}
.melody .comment-list .article .ico {position:absolute; top:20px; left:10px; width:88px;}
.melody .comment-list .article .author {position:relative; font-size:11px;}
.melody .comment-list .article .author .num {color:#616161;}
.melody .comment-list .article .author em {position:absolute; top:0; right:0; color:#000;}
.melody .comment-list .article .author em span {padding:0 2px;}
.melody .comment-list .article .author em span:first-child {position:relative; padding-right:6px;}
.melody .comment-list .article .author em span:first-child:before {content:' '; position:absolute; top:50%; right:0; z-index:5; width:1px; height:6px; margin-top:-3px; background-color:#757575;}
.melody .comment-list .article .write {margin-top:5px; color:#616161; font-size:12px; line-height:1.5em;}
.melody .comment-list .article .mobile img {width:8px; vertical-align:middle;}
.melody .comment-list .article .btnDel {border:0; background-color:#bdbdbd; color:#fff; font-size:11px;}
.melody .comment-list .paging a {border:1px solid #d8ba90; background-color:transparent;}
.melody .comment-list .paging a.current {border:1px solid #000;}
.melody .comment-list .paging a.current span {background-color:transparent;}
.melody .comment-list .paging a.arrow {background-color:#cdb189;}
.melody .comment-list .paging a.arrow .prev {background:url(http://webimage.10x10.co.kr/eventIMG/2014/54739/blt_arrow_prev.gif) no-repeat 50% 50%; background-size:16px;}
.melody .comment-list .paging a.arrow .next {background:url(http://webimage.10x10.co.kr/eventIMG/2014/54739/blt_arrow_next.gif) no-repeat 50% 50%; background-size:16px;}
.melody .noti {background-color:#fff; text-align:left;}
.melody .noti ul {padding:0 5.41666% 8%;}
.melody .noti ul li {margin-top:7px; padding-left:15px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54739/blt_hypen.gif); background-repeat:no-repeat; background-position:0 10px; background-size:9px auto; color:#444; font-size:16px; line-height:1.5em;}
.melody .noti ul li em {color:#d50c0c; font-style:normal;}
@media all and (max-width:480px){
	.melody .noti ul li {margin-top:2px; padding-left:10px; font-size:11px; background-position:0 6px; background-size:6px auto;}
}
</style>
<script type="text/javascript">
$(function(){
	$(".lineup").hide();
	$(".btnTime a").click(function(){
		$(".lineup").show();
		return false();
	});
	$(".lineup .btnClose a").click(function(){
		$(".lineup").hide();
	});
});

function jsSubmitComment(frm){      //코멘트 입력
	<% If IsUserLoginOK() Then %>
		<% If Now() > #09/15/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If getnowdate>="2014-09-06" and getnowdate<="2014-09-15" Then %>
				<% if subscriptcount < 1 then %>
					var leaficon;
					var tmpleaficongubun='';
					leaficon = document.getElementsByName("leaficon")
	
					for (i=0; i < leaficon.length; i++){
						if (leaficon[i].checked){
							tmpleaficongubun=leaficon[i].value;
						}
					}
					if (tmpleaficongubun==''){
						alert("마음에 드는 잎을 선택해 주세요.");
						return;
					}
					
					if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 200 || frm.txtcomm.value == '페스티벌에 함께 가고픈 이유를 적어주세요(최대100자)'){
						alert("코맨트가 없거나 제한길이를 초과하였습니다. 100자 까지 작성 가능합니다.");
						frm.txtcomm.focus();
						return;
					}
	
					frm.leaficongubun.value=tmpleaficongubun
			   		frm.mode.value="addcomment";
					frm.action="/event/etc/doEventSubscript54738.asp";
					frm.target="evtFrmProc";
					frm.submit();
					return;
				<% else %>
					alert("참여는 한번만 가능 합니다.");
					return;
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>				
		<% End If %>
	<% Else %>
		alert('로그인을 하셔야 참여할 수 있습니다.');
		top.location.href = "/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=getevt_code%>"
	<% End IF %>
}

function jsDelComment(sub_idx)	{
	if(confirm("삭제하시겠습니까?")){
		frmcomm.sub_idx.value = sub_idx;
		frmcomm.mode.value="delcomment";
		frmcomm.action="/event/etc/doEventSubscript54738.asp";
		frmcomm.target="evtFrmProc";
   		frmcomm.submit();
	}
}

function jsGoComPage(iP){
	document.frmcomm.iCC.value = iP;
	document.frmcomm.submit();
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		jsChklogin('<%=IsUserLoginOK%>');
	}
	
	if (frmcomm.txtcomm.value == '페스티벌에 함께 가고픈 이유를 적어주세요(최대100자)'){
		frmcomm.txtcomm.value='';
	}
}
</script>
</head>
<body>
	<%' 2014 멜로디 포레스트 캠프 공식 MD %>
	<div class="mEvt54739">
		<div class="melody">
			<div class="section heading">
				<div class="symbol"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/img_melody_forest_camp.gif" alt="9월 20부터 9월 21일 자라섬 멜로디 포레스트 캠프" /></div>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/txt_only_tenten.gif" alt="멜로디 포레스트 캠프 오직 텐바이텐에서만! 페스티벌 공식MD와 티켓이벤트에 참여하세요!" /></p>
				<p class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/txt_date.gif" alt="이벤트기간은 9월 06일부 9월 17일까지며, 상품 출고일은 09월 20일 부터입니다. 현장수령 가능합니다." /></p>
			</div>

			<div class="section intro">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/txt_mean.gif" alt="멜로디는 대중적인 음악, 포레스트는 자연속에서 캠프는 가족이 함께 즐기는 의미를 담고 있습니다." /></p>
				<p>
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/txt_video_2014.gif" alt="">
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/txt_video.gif" alt="2014 멜로디 포레스트 캠프 2014년 9월, 우리나라를 대표하는 최고의 뮤지션 12팀이 청명한 가을하늘과 푸른 잔디밭이 맞닿은 무대에서 잊지 못할 감동을 선사합니다. 멜로디 포레스트 캠프는 남녀노소 모두가 쉽고 편하게 즐길 수 있는 국내 유일의 대중 음악 페스티벌로, &apos;나무(자연)에서 멜로디를 들으며 쉬다 &apos; 라는 의미를 담고 있습니다. 바람소리에 잠이 들고, 음악 소리에 눈을 뜨는 특별한 가을날의 추억을 만들어 보세요!">
				</p>
				<div class="movie">
					<div class="youtube">
						<iframe src="//player.vimeo.com/video/105113760" frameborder="0" title="2014 멜로디 포레스트 캠프" allowfullscreen></iframe>
					</div>
				</div>
				<div class="btnSite"><a href="http://www.melodyforestcamp.com/" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/btn_go_homepage.gif" alt="멜로디 포레스트 캠프 공식홈페이지 바로가기" /></a></div>
				<div class="btnTime"><a href="#lineup"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/btn_time_table.png" alt="타임 테이블 라인업 확인하기" /></a></div>
				<div id="lineup" class="lineup">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/txt_lineup_01.png" alt="9월 20일 라인업 에디킴, 김예림, 라디, 윤종신, 박정현, 김범수" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/txt_lineup_02.png" alt="9월 21일 라인업 박지윤, 하림, 플라이투더스카이, 정엽과 박주원, 최백호와 에코브릿지, 아이유" /></p>
					<div class="btnClose"><a href="#md"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/btn_close.png" alt="닫기" /></a></div>
				</div>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/img_blue.gif" alt="" />
			</div>

			<div id="md" class="section md">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/tit_md.gif" alt="멜로디 포레스트 캠프 공식 MD" /></h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/txt_md.gif" alt="오직 텐바이텐에서만 만나는, 스폐셜 상품을 만나보세요! 판매기간은 9월 6일부터 9월 17일까지입니다. 페스티벌 MD는 현장 수령이 가능합니다. 하단의 이벤트 안내를 참고해주세요." /></p>
				<ul>
					<li><a href="/category/category_itemPrd.asp?itemid=1121391"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/img_md_01.png" alt="PK SHIRTS 할인가 구매하러 가기" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=1121392"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/img_md_02.png" alt="BLANKET 구매하러 가기" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=1121393"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/img_md_03.png" alt="BOTTLE 구매하러 가기" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=1121395"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/img_md_04.png" alt="PIN BUTTON 구매하러 가기" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=1121394"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/img_md_05.png" alt="CANDLE LIGHT 구매하러 가기" /></a></li>
				</ul>
			</div>

			<div class="section comment-event">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/tit_comment_event.gif" alt="코멘트 이벤트" /></h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/txt_comment_event.gif" alt="멜로디 포레스트 캠프에 함께 가고픈 사람을 선택하고, 그 이유를 적어주세요! 정성껏 댓글을 작성해 주신 분들 중, 15분을 추첨해 9월 21일 티켓을 드립니다. 1인 2매 기간은 9월 6일부터 9월 15일까지며 당첨자 발표는 9월 16일입니다." /></p>

				<%'  코멘트 작성 폼 %>
				<div class="field">
					<form name="frmcomm" action="" onsubmit="return false;" method="post" style="margin:0px;">
					<input type="hidden" name="mode">
					<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
					<input type="hidden" name="sub_idx">
					<input type="hidden" name="leaficongubun">
						<fieldset>
						<legend>캠프에 함께 가고픈 사람과 이유 쓰기</legend>
							<ul>
								<li>
									<input type="radio" id="withperson01" name="leaficon" value="1" />
									<label for="withperson01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/ico_leaf_01.png" alt="가족" /></label>
								</li>
								<li>
									<input type="radio" id="withperson02" name="leaficon" value="2" />
									<label for="withperson02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/ico_leaf_02.png" alt="친구" /></label>
								</li>
								<li>
									<input type="radio" id="withperson03" name="leaficon" value="3" />
									<label for="withperson03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/ico_leaf_03.png" alt="사랑하는 사람" /></label>
									
								</li>
								<li>
									<input type="radio" id="withperson04" name="leaficon" value="4" />
									<label for="withperson04"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/ico_leaf_04.png" alt="낯선 사람" /></label>
								</li>
							</ul>
							<textarea title="신청 이유 쓰기" cols="50" rows="6" name="txtcomm" id="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%>><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>페스티벌에 함께 가고픈 이유를 적어주세요(최대100자)<%END IF%></textarea>
							<div class="btnSubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/54739/btn_submit.gif" onclick="jsSubmitComment(frmcomm); return false;" alt="응모하기" /></div>
						</fieldset>
					</form>
				</div>
			</div>

			<%'  commnet list %>
			<% IF ccomment.ftotalcount>0 THEN %>
			<div class="section comment-list">
				<%'  for dev msg : article이 코멘트 글 묶음입니다. %>
				<%'  라디오버튼 선택에 따라 각각 해당 이미지 보여주시고 클래스명 color1 ~ color4 추가해주세요 %>
				<% for i = 0 to ccomment.fresultcount - 1 %>
				<div class="article color<%=ccomment.FItemList(i).fsub_opt2%>">
					<span class="ico"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/img_leaf_0<%=ccomment.FItemList(i).fsub_opt2%>.gif" alt="" /></span>
					<div class="author">
						<span class="num">No.<%=ccomment.FTotalCount-i-(ccomment.FPageSize*(ccomment.FCurrPage-1))%></span>
						<em><span><%=printUserId(ccomment.FItemList(i).fuserid,2,"*")%></span> <span><%=FormatDate(ccomment.FItemList(i).fregdate,"0000-00-00")%></span></em>
					</div>
					<div class="write">
						<%=ReplaceBracket(ccomment.FItemList(i).fsub_opt3)%>
						
						<% ' for dev msg : 내가 쓴 글일 경우 삭제버튼 노출 %>
						<% if ((userid = ccomment.FItemList(i).fuserid) or (userid = "10x10")) and ( ccomment.FItemList(i).fuserid<>"") then %>
							<button type="button" onclick="jsDelComment('<%= ccomment.FItemList(i).fsub_idx %>'); return false;" class="btnDel">삭제</button>
						<% end if %>
						
						<%'  for dev msg : 모바일에서 작성된 글일 경우 %>
						<% if ccomment.FItemList(i).fdevice = "M" then %>
							<span class="mobile">
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/ico_mobile.gif" alt="모바일에서 작성된 글" />
							</span>
						<% end if %>
					</div>
				</div>
				<% next %>
				<%= fnDisplayPaging_New(ccomment.FCurrpage, ccomment.ftotalcount, ccomment.FPageSize, ccomment.FScrollCount,"jsGoComPage") %>
			</div>
			<% end if %>

			<div class="section noti">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54739/tit_noti.gif" alt="이벤트 유의사항" /></h3>
				<ul>
					<li>현장 수령을 원하실 경우, 결제 페이지에서 배송지 입력 시 &lt;현장 수령&gt;을 꼭 체크해 주세요.</li>
					<li>MD 상품은 ID당 최대 5개까지만 구매할 수 있습니다.</li>
					<li>페스티벌 MD는 텐바이텐 단독배송상품으로, 다른 일반 상품과 함께 결제할 수 없습니다. </li>
					<li>현장 수령 시, 텐바이텐 MD 판매 부스에 방문해 주시기 바랍니다.</li>
					<li>상품 수령 시, 본인 확인을 위해 현장에서 결제확인을 합니다.</li>
				</ul>
			</div>

		</div>
	</div>
	<!-- //2014 멜로디 포레스트 캠프 공식 MD -->
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>
<% set ccomment=nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->