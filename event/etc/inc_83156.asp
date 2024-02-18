<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : 텐바이텐 감사 프로젝트
' History : 2017-12-22 정태훈
'####################################################
Dim eCode, userid

IF application("Svr_Info") = "Dev" THEN
	eCode   =  67496
Else
	eCode   =  83156
End If

userid = GetEncLoginUserID()

Dim OldTotalPrice, sqlStr, NowTotalPrice, TotalPrice

If userid <> "" Then
'1. 2017-01~11월 총 구매금액 뽑기
sqlStr = "SELECT totalPrice FROM [db_temp].[dbo].[tbl_temp_2017OrderUserPrice] WHERE userid = '" & Cstr(userid) & "'"
rsget.Open sqlStr,dbget,1
If not rsget.EOF Then
	OldTotalPrice = rsget(0)
Else
	OldTotalPrice=0
End If
rsget.close

'2. 2017-12월 총 구매금액 뽑기
sqlStr = "select sum(subtotalprice) as totPrc" & vbcrlf
sqlStr = sqlStr + " from [db_order].[dbo].[tbl_order_master] with (noLock)" & vbcrlf
sqlStr = sqlStr + " where ipkumdiv>3" & vbcrlf
sqlStr = sqlStr + " and jumundiv<>'6'" & vbcrlf
sqlStr = sqlStr + " and sitename='10x10'" & vbcrlf
sqlStr = sqlStr + " and cancelyn='N'" & vbcrlf
sqlStr = sqlStr + " and userid='" & Cstr(userid) & "'" & vbcrlf
sqlStr = sqlStr + " and regdate between '2017-12-01' and '2018-01-01'" & vbcrlf
sqlStr = sqlStr + " group by userid"

rsget.Open sqlStr,dbget,1
If not rsget.EOF Then
	NowTotalPrice = rsget(0)
Else
	NowTotalPrice=0
End If
rsget.close

TotalPrice=OldTotalPrice+NowTotalPrice
Else
TotalPrice=0
End If

Dim signUpCheck
sqlStr = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"'"
rsget.CursorLocation = adUseClient
rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	signUpCheck = rsget(0)
End IF
rsget.close

%>
<style type="text/css">
.thnx-prj .thx-cont {overflow:hidden;}
.thnx-prj .thx-cont > div {position:relative; width:50%; float:left; position:relative;}
.thnx-prj .thx-cont > div p {position:absolute; top:37.65%; left:0; width:100%; margin-left:.6rem; text-align:center; color:#fff; font:bold 2.1rem/1 'AvenirNext-Bold', 'AppleSDGothicNeo-Bold';}
.thnx-prj .thx-cont .price2 p {top:60.27%; margin-left:-.5rem; color:#fee53c;}
.thnx-prj .thx-cont > div em {display:inline-block; position:absolute; bottom:6.6%; left:11.1%; width:70.5%;}
.thnx-prj .thx-cont > div a {display:inline-block; position:absolute; bottom:0; left:0; width:100%; height:86%;}
.thnx-prj .submit button{background-color:transparent;}
.event-noti {padding:3.84rem 1.96rem 4.69rem; background-color:#d4d4d4;}
.event-noti h3 {position:relative; color:#000; font-size:1.62rem; font-weight:bold; text-align:center; letter-spacing:.01rem;}
.event-noti h3:after {content:' '; display:block; position:absolute; bottom:-0.6rem; left:50%; width:11.8rem; height:2px; margin-left:-5.9rem; background-color:#000;}
.event-noti ul {margin-top:2.39rem;}
.event-noti ul li {position:relative; padding-left:1.45rem; color:#6d6d6d; font-size:1.28rem; line-height:1.68em;}
.event-noti ul li:after {content:' '; display:block; position:absolute; top:.8rem; left:0; width:.6rem; height:2px; background-color:#6d6d6d;}
</style>
<script type="text/javascript">
<!--
	function fnGoEnter(){
		<% If TotalPrice>99999 Then %>
			<% If now() > #12/27/2017 00:00:00# and now() < #12/31/2017 23:59:59# then %>
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/doEventSubscript83156.asp",
					data: "mode=add&eCode=<%=eCode%>",
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("|")
				if (str1[0] == "11"){
					alert('2017년 텐바이텐과 함께해주셔서\n감사합니다.\n당첨자 발표일을 기다려주세요.');
					$(".submit").empty().html("<div class='comp'><img src='http://webimage.10x10.co.kr/eventIMG/2017/83156/m/txt_submit_comp.jpg' alt='응모완료' /></div>");
					return false;
				}else if (str1[0] == "12"){
					alert('이벤트 기간이 아닙니다.');
					return false;
				}else if (str1[0] == "13"){
					alert('이미 이벤트에 응모하셨습니다.');
					return false;
				}else if (str1[0] == "02"){
					alert('로그인 후 참여 가능합니다.');
					return false;
				}else if (str1[0] == "01"){
					alert('잘못된 접속입니다.');
					return false;
				}else if (str1[0] == "00"){
					alert('정상적인 경로가 아닙니다.');
					return false;
				}else{
					alert('오류가 발생했습니다.');
					return false;
				}
			<% Else %>
				alert("이벤트 기간이 아닙니다.");
				return;
			<% End If %>
		<% Else %>
			alert("고객님, 올해 누적 구매 금액이 10만원이\n넘지 않아 응모할 수 없습니다.\n기간 내에 다시 도전해주세요.");
			return false;
		<% End If %>
	}
	function fnlogin(){
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
		return false;
	<% end if %>	
	}
//-->
</script>
			<div class="mEvt83156 thnx-prj">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/83156/m/tit_thx_prj.jpg" alt="텐바이텐 감사 프로젝트 올해 10만원 이상 구매하신 분 들 중 추첨을 통해 텐바이텐 기프트카드 1만원권을 100분께 선물 드립니다." /></h2>
				<div class="thx-cont">
				<% If userid<>"" Then %>
					<% If TotalPrice>99999 Then %>
					<div class="price1">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/83156/m/txt_price_1.jpg" alt="2017년 총 누적 구매 금액" />
						<p><span><%=FormatNumber(TotalPrice,0)%></span>원</p>
					</div>
					<div class="price2">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/83156/m/txt_price_2.jpg" alt="응모까지 필요한 구매 금액" />
						<p><span>0</span>원</p>
					</div>
					<% Else %>
					<div class="price1">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/83156/m/txt_price_1.jpg" alt="2017년 총 누적 구매 금액" />
						<p><span><%=FormatNumber(TotalPrice,0)%></span>원</p>
					</div>
					<div class="price2">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/83156/m/txt_price_2.jpg" alt="응모까지 필요한 구매 금액" />
						<p><span><%=FormatNumber(100000-TotalPrice,0)%></span>원</p>
						<em><img src="http://webimage.10x10.co.kr/eventIMG/2017/83156/m/txt_go_shopping.png" alt="구매 금액 채우러 가기" /></em>
						<a href="/award/awarditem.asp" class="mWeb"></a>
						<a href="" onclick="fnAPPpopupBest_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/award/awarditem.asp');return false;" class="mApp" style="display: none;"></a>
					</div>
					<% End If %>
				<% Else %>
					<div class="price1">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/83156/m/txt_price_1.jpg" alt="2017년 총 누적 구매 금액" />
						<p><span>? </span>원</p>
					</div>
					<div class="price2">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/83156/m/txt_price_2.jpg" alt="응모까지 필요한 구매 금액" />
						<p><span>? </span>원</p>
					</div>
				<% End If %>
				</div>
				<div class="submit">
				<% If userid<>"" Then %>
					<% If signUpCheck>0 Then %>
					<div class="comp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/83156/m/txt_submit_comp.jpg" alt="응모완료" /></div>
					<% Else %>
					<button onClick="fnGoEnter();"><img src="http://webimage.10x10.co.kr/eventIMG/2017/83156/m/btn_submit.jpg" alt="응모하기" /></button>
					<% End If %>
				<% Else %>
				<button onClick="fnlogin();"><img src="http://webimage.10x10.co.kr/eventIMG/2017/83156/m/btn_check_mine.jpg" alt="나의 누적 금액 확인하기" /></button>
				<% End If %>
				</div>
				<div class="event-noti">
					<div class="inner">
						<h3>이벤트 유의사항</h3>
						<ul>
							<li>본 이벤트는 기간 동안 ID 당 1회 응모하실 수 있습니다.</li>
							<li>구매 횟수와는 상관없이 결제 완료 기준으로 2017년 텐바이텐 누적 구매 금액이 10만원 이상일 때 응모 가능합니다.</li>
							<li>당첨자 발표는 2018년 1월 4일 사이트 내 공지사항에 게시될 예정입니다.</li>
						</ul  >
					</div>
				</div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->