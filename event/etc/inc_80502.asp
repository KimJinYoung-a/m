<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#############################################################
' Description : 모바일 리뉴얼 설문 이벤트 
' History : 2017-09-18 유태욱 생성
'#############################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	Dim eCode, mycnt
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66430
	Else
		eCode   =  80502
	End If

	dim userid, i, UserAppearChk, nowdate
		userid = GetEncLoginUserID()

	nowdate = Left(Now(), 10)
'																							nowdate = "2017-09-20"

	'// 이벤트 참여 응모현황
	if userid <> "" then 
		UserAppearChk = getevent_subscriptexistscount(eCode,userid,"","","")
	else
		UserAppearChk=1
	end if

%>
<style type="text/css">
.event1 {background-color:#efefef;}
.event1 ul {width:90%; margin:0 auto; padding-bottom:3.5rem; border:1px solid #dedede; background-color:#fff;}
.event1 li {color:#000; font-size:1.28rem; border-top:1px solid #dedede;}
.event1 li:first-child {border-top:0;}
.event1 li label {display:inline-block; padding-top:0.2rem; vertical-align:middle;}
.event1 .answer {overflow:hidden;}
.event1 .answer p {float:left; width:50%;}
.event1 .q1 {padding-bottom:1.96rem;}
.event1 .q1 .answer {padding-left:1rem;}
.event1 .q1 .answer p {padding:0 0 1.7rem 1.7rem; line-height:1.8rem;}
.event1 .q1 label {padding-left:0.5rem;}
.event1 .q2 {text-align:center; padding-bottom:3.58rem;}
.event1 .q2 input {margin-top:1.02rem;}
.event1 .q3 input {display:block; width:80%; height:4.5rem; margin:0 auto; padding:0.5rem 0; color:#000; font-size:1.45rem; font-weight:600; border:0.2rem solid #ff3131; text-align:center; border-radius:0;}
.event1 button {width:100%;}
.event2 {padding-bottom:3rem; background:#fff;}
.noti {padding:4.2rem 7%; font-size:1.4rem; background:#efefef; color:#333; letter-spacing:-0.025em;}
.noti h3 {text-align:center; padding-bottom:1.7rem;}
.noti h3 span {display:inline-block; padding-bottom:0.2rem; font-size:1.54rem; font-weight:bold; color:#ff3131; border-bottom:0.15rem solid #ff3131;}
.noti li {position:relative; padding:0.3rem 0 0 1.3rem; font-size:1.19rem; line-height:1.4;}
.noti li:before {content:'-'; position:absolute; left:0; top:0.35rem;}
</style>
<script type="text/javascript">
function gonewq(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(now(),10)>="2017-09-19" and left(now(),10)<"2017-10-02" ) Then %>
			alert("응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if UserAppearChk > 0 then %>
				alert("이미 응모하셨습니다.");
				return false;
			<% else %>
				if(!$(':input:radio[name=new1]:checked').val()) {
					alert("새로 추가된 검색 기능이 아닌것을 선택해 주세요.");
					$("#new1").focus();
					return false;
				}

//				if($(':input:radio[name=new1]:checked').val()!="3") {
//					alert("정답을 다시 확인해주세요!");
//					$("#new1").focus();
//					return false;
//				}

				if(!$(':input:radio[name=new2]:checked').val()) {
					alert("새로워진 텐바이텐의 모습을 선택해 주세요.");
					$("#view1").focus();
					return false;
				}

				if ($("#newtenTxt").val() == '' || GetByteLength($("#newtenTxt").val()) > 64){
					alert("메뉴명을 입력해주세요.");
					$("#newtenTxt").focus();
					return false;
				}

				$.ajax({
					type:"GET",
					url:"/event/etc/doeventsubscript/doEventSubscript80502.asp",
					data: $("#frmcom").serialize(),
					dataType: "text",
					async:false,
					cache:true,
					success : function(Data, textStatus, jqXHR){
						if (jqXHR.readyState == 4) {
							if (jqXHR.status == 200) {
								if(Data!="") {
									res = Data.split("|");
									if (res[0]=="OK")
									{
										alert("응모가 완료 되었습니다.");
										parent.location.reload();
										return false;
									}
									else
									{
										errorMsg = res[1].replace(">?n", "\n");
										alert(errorMsg);
										return false;
									}
								} else {
									alert("잘못된 접근 입니다.1");
									parent.location.reload();
									return false;
								}
							}
						}
					},
					error:function(jqXHR, textStatus, errorThrown){
						alert("잘못된 접근 입니다.2");
						parent.location.reload();
						return false;
					}
				});
			<% end if %>
		<% end if %>
	<% else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% end if %>
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	}
}

function fnqnot() {
	<% If IsUserLoginOK() Then %>
		alert('정답을 다시 확인해 주세요!');
		return false;
	<% end if %>
}
</script>
	<!-- Buy Different -->
	<div class="mEvt80502">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/80502/m/tit_buy.jpg" alt="Buy Different" /></h2>
		<div class="event1">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/80502/m/txt_event_1.png" alt="EVENT1 새로워진 모바일에 대한 퀴즈를 풀어주세요" /></h3>
			<form method="post" name="frmcom" id="frmcom">
				<input type="hidden" name="mode" value="newq">
				<ul>
					<li class="q1">
						<p class="question"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80502/m/txt_q1.png" alt="Q1.이번 모바일에서는 검색 기능이 대폭 강화되었답니다! 다음 중 새로 추가된 검색 기능이 아닌 것은 무엇일까요?" /></p>
						<div class="answer">
							<p><input type="radio" id="new1" name="new1" value="1" onclick="fnqnot();" class="frmRadioV16" /> <label for="new1">인기검색어</label></p>
							<p><input type="radio" id="new2" name="new1" value="2" onclick="fnqnot();" class="frmRadioV16" /> <label for="new2">카테고리검색</label></p>
							<p><input type="radio" id="new3" name="new1" value="3" class="frmRadioV16" /> <label for="new3">유전자 감식</label></p>
							<p><input type="radio" id="new4" name="new1" value="4" onclick="fnqnot();" class="frmRadioV16" /> <label for="new4">브랜드검색</label></p>
						</div>
					</li>
					<li class="q2">
						<p class="question"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80502/m/txt_q2.png" alt="Q2.아래 두 화면 중 새로워진 텐바이텐의 모습은 어느 것일까요?" /></p>
						<div class="answer">
							<p><label for="view1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80502/m/img_view_1.jpg" alt="" /></label><input type="radio" id="view1" name="new2" value="1" class="frmRadioV16" /></p>
							<p><label for="view2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80502/m/img_view_2.jpg" alt="" /></label><input type="radio" id="view2" name="new2" value="2" class="frmRadioV16" /></p>
						</div>
					</li>
					<li class="q3">
						<p class="question"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80502/m/txt_q3.png" alt="Q3.모바일 화면 하단 바 메뉴 중 빈칸에 들어갈 메뉴명을 적어주세요!" /></p>
						<div class="answer">
							<input type="text" maxlength="32" name="newtenTxt" id="newtenTxt" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <% IF NOT(IsUserLoginOK) THEN %>readonly<% END IF %> placeholder="<% IF NOT IsUserLoginOK THEN %>로그인을 해주세요<% else %>메뉴명을 입력해주세요<% end if %>" />
						</div>
					</li>
				</ul>
			</form>
			<button type="button" onclick="gonewq();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80502/m/btn_apply.png" alt="응모하기" /></button>
		</div>
		<div class="event2">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/80502/m/tit_event_2.png" alt="EVENT2 축하메시지를 SNS에 공유해주세요!" /></h3>
			<a href="/category/category_itemPrd.asp?itemid=1485011&pEtr=80502" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80502/m/img_gift.jpg" alt="포켓 빔프로젝터 Mini ray (3명)" /></a>
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1485011&pEtr=80502" onclick="fnAPPpopupProduct('1485011&pEtr=80502');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80502/m/img_gift.jpg" alt="포켓 빔프로젝터 Mini ray (3명)" /></a>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/80502/m/txt_process.png" alt="[축하 댓글 남기러 가기] 버튼 누르고 이벤트 포스팅 방문 → 해당 이벤트 포스팅을 좋아요 + 공유하기(전체공개) → 해당 이벤트 포스팅글에 축하댓글 남기면 응모 완료" /></div>
			<a href="https://www.facebook.com/your10x10/posts/1679045642115941" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80502/m/btn_go.png" alt="축하 댓글 남기러 가기" /></a>
		</div>
		<!--<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/80502/m/txt_coming_soon.jpg" alt="새로운 감성 한 조각이 10월에 여러분을 찾아갑니다 Coming Soon" /></div>-->
		<div class="noti">
			<h3><span>이벤트 유의사항</span></h3>
			<ul>
				<li>EVENT1은 ID당 한 번씩만 응모하실 수 있습니다.</li>
				<li>EVENT2 응모시 페이스북 계정이나 이벤트 게시물이<br />비공개일 경우 이벤트 참여가 되지 않습니다.</li>
				<li>당첨자 발표는 10월2일(월) 공지사항에 게시될 예정입니다.</li>
			</ul>
		</div>
	</div>
	<!--// Buy Different -->
<!-- #include virtual="/lib/db/dbclose.asp" -->