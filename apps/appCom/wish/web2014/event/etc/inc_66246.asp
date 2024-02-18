<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : ##추석특선영화
' History : 2015-09-18 원승현 생성
'####################################################
	Dim vUserID, eCode, cMil, vMileValue, vMileArr
	Dim couponidx
	Dim totalbonuscouponcount, vNowDate

	'// 로그인 한 유저 아이디 긁어옴
	vUserID = getEncLoginUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64889"
	Else
		eCode = "66246"
	End If

	Dim strSql , totcnt
	'// 응모여부(기간중 1회만 참여가능)
	strSql = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& vUserID &"' and evt_code = '"& ecode &"' " 
	rsget.Open strSql,dbget,adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()


%>
<style type="text/css">
img {vertical-align:top;}
.mEvt66246 {position:relative;}
.mEvt66246 button {background:transparent;}
.btnApply {vertical-align:top;}
.movieWrap {padding:0 2%; background:#222022;}
.movieWrap .movie {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#5884bb;}
.movieWrap .movie iframe {position:absolute; top:0; left:0; bottom:0; width:100%; height:100%;}
.evtNoti {padding:6.5% 5.2%; text-align:left; background:#fff7ec;}
.evtNoti h3 {display:inline-block; font-size:15px; font-weight:bold; padding-bottom:1px; color:#000; border-bottom:2px solid #000; margin-bottom:12px;}
.evtNoti li {position:relative; font-size:11px; line-height:1.4; padding:0 0 3px 8px; color:#444; }
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:4px; width:3px; height:3px; background:#000; border-radius:50%;}
/* layer popup */
.finishLayer {display:none; position:absolute; left:0; top:0; width:100%; height:100%; padding:25% 7% 0; background:rgba(0,0,0,.7);}
.finishLayer .finishLayerCont {position:relative;}
.finishLayer .btnConfirm {position:absolute; left:10%; bottom:10%; width:80%; height:13%; color:transparent;}
@media all and (min-width:480px){
	.movieWrap {padding-bottom:48px;}
	.movieWrap .movie {border:7px solid #5884bb;}
	.evtNoti h3 {font-size:23px; border-bottom:3px solid #000; margin-bottom:18px;}
	.evtNoti li {font-size:17px; padding:0 0 4px 12px;}
	.evtNoti li:after {top:6px; width:4px; height:4px;}
}
</style>
<script type="text/javascript">


function fnClosemask()
{
	$('.finishLayer').hide();
	document.location.reload();
}


function checkform(){

	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% if isApp="1" then %>
				calllogin();
				return false;
			<% else %>
				jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
				return false;
			<% end if %>
		}
	<% End If %>

	<% If vUserID <> "" Then %>
		<% If totcnt >= 1 then %>
			alert("이미 참여하셨습니다.");
			document.location.reload();
			return false;
		<% Else %>
			$.ajax({
				type:"GET",
				url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript66246.asp?mode=add",
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
									$("#finishLyC").empty().html(res[1]);
									$('.finishLayer').show();
									window.parent.$('html,body').animate({scrollTop:200}, 300);
								}
								else
								{
									errorMsg = res[1].replace(">?n", "\n");
									alert(errorMsg );
									document.location.reload();
									return false;
								}
							} else {
								alert("잘못된 접근 입니다.");
								document.location.reload();
								return false;
							}
						}
					}
				},
				error:function(jqXHR, textStatus, errorThrown){
					alert("잘못된 접근 입니다.");
					var str;
					for(var i in jqXHR)
					{
						 if(jqXHR.hasOwnProperty(i))
						{
							str += jqXHR[i];
						}
					}
					alert(str);
					document.location.reload();
					return false;
				}
			});
		 <% End If %>
	<% End If %>
}
</script>


<%' 추석특선영화 %>
<div class="mEvt66246">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/66246/tit_movie.jpg" alt="연휴를 알차게 보내는 방법! 추석특선영화 - 성큼 다가온 추석, 집에만 있을 것 같은 여러분을 위해 준비했습니다" /></h2>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/66246/img_detective.jpg" alt="탐정:더비기닝 포스터" /></div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66246/txt_gift.jpg" alt="추첨을 통해 100분에게 영화예매권을 드립니다." /></p>
	<%' 응모버튼 %><button type="button" class="btnApply" onclick="checkform();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66246/btn_apply.jpg" alt="응모하기" /></button>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/66246/img_deco.jpg" alt="" /></div>
	<div class="movieWrap">
		<div class="movie">
			<iframe src='http://serviceapi.rmcnmv.naver.com/flash/outKeyPlayer.nhn?vid=9EF73880E545C788A94E062E833F97B7DA2E&outKey=V12126359b6b18524d5d7e76242da74df96f75f7c88c0eba0bd41e76242da74df96f7&controlBarMovable=true&jsCallable=true&skinName=default' frameborder='no' scrolling='no' marginwidth='0' marginheight='0' allowfullscreen></iframe>
		</div>
	</div>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/66246/txt_movie_story.jpg" alt="영화 줄거리" /></div>
	<div class="evtNoti">
		<h3>이벤트 안내</h3>
		<ul>
			<li>텐바이텐 고객님을 위한 이벤트 입니다. 비회원이신 경우 회원가입 후 참여해 주세요.</li>
			<li>본 이벤트는 텐바이텐 모바일에서만 참여 가능합니다.</li>
			<li>본 이벤트는 ID당 1회만 응모가능 합니다.</li>
			<li>당첨자는 9월 21일 공지사항을 통해 확인 할 수 있습니다. </li>
			<li>당첨 시 개인정보에 있는 이메일 주소로 관람권이 발송 됩니다. 마이텐바이텐에서 이메일 주소를 확인해 주세요!</li>
		</ul>
	</div>
	<!-- 응모완료 팝업 -->
	<div class="finishLayer">
		<div class="finishLayerCont" id="finishLyC">
			
		</div>
	</div>
	<!--// 응모완료 팝업 -->
</div>
<!--// 추석특선영화 -->


<!-- #include virtual="/lib/db/dbclose.asp" -->