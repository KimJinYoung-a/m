<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 별 세는 밤 - for app
' History : 2015-06-24 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<%
Dim eCode , userid
Dim strSql , totcnt , todaycnt
Dim prize1 : prize1 = 0
Dim prize2 : prize2 = 0 
Dim prize3 : prize3 = 0 
Dim prize4 : prize4 = 0 
Dim prize5 : prize5 = 0 
Dim prize6 : prize6 = 0
Dim win1 , win2 , win3 , win4 , win5 , win6
	
	userid = getloginuserid()

IF application("Svr_Info") = "Dev" THEN
	eCode   =  63799
Else
	eCode   =  64101
End If

	If IsUserLoginOK Then 
		'// 출석 여부
		strSql = "select "
		strSql = strSql & " isnull(sum(case when convert(varchar(10),t.regdate,120) = '"& Date() &"' then 1 else 0 end ),0) as todaycnt "
		strSql = strSql & " , count(*) as totcnt "
		strSql = strSql & " from db_temp.[dbo].[tbl_event_attendance] as t "
		strSql = strSql & " inner join db_event.dbo.tbl_event as e "
		strSql = strSql & " on t.evt_code = e.evt_code and convert(varchar(10),t.regdate,120) between convert(varchar(10),e.evt_startdate,120) and convert(varchar(10),e.evt_enddate,120) "
		strSql = strSql & "	where t.userid = '"& userid &"' and t.evt_code = '"& eCode &"' " 
		rsget.Open strSql,dbget,1
		IF Not rsget.Eof Then
			todaycnt = rsget("todaycnt") '// 오늘 출석 여부 1-ture 0-false
			totcnt = rsget("totcnt") '// 전체 응모수
		End IF
		rsget.close()

		'// 응모 여부
		strSql = " select "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 1 then 1 else 0 end),0) as prize1 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 1 and sub_opt2 = 1 then 1 else 0 end),0) as win1 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 2 then 1 else 0 end),0) as prize2 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 2 and sub_opt2 = 1 then 1 else 0 end),0) as win2 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 3 then 1 else 0 end),0) as prize3 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 3 and sub_opt2 = 1 then 1 else 0 end),0) as win3 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 4 then 1 else 0 end),0) as prize4 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 4 and sub_opt2 = 1 then 1 else 0 end),0) as win4 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 5 then 1 else 0 end),0) as prize5 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 5 and sub_opt2 = 1 then 1 else 0 end),0) as win5 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 6 then 1 else 0 end),0) as prize6 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 6 and sub_opt2 = 1 then 1 else 0 end),0) as win6  "
		strSql = strSql & "	from db_event.dbo.tbl_event_subscript "
		strSql = strSql & "	where evt_code = '"& eCode &"' and userid = '"& userid &"' "
		rsget.Open strSql,dbget,1
		IF Not rsget.Eof Then
			prize1	= rsget("prize1")	'// 3일차 응모 - 마일리지 500point - 전원지급
			win1	= rsget("win1")		'// 당첨여부
			prize2	= rsget("prize2")	'//	5일차 응모 - 미니무드등 - 200명 - 5%
			win2	= rsget("win2")		'// 당첨여부
			prize3	= rsget("prize3")	'//	7일차 응모 - 마일리지 1,000point - 전원지급
			win3	= rsget("win3")		'// 당첨여부
			prize4	= rsget("prize4")	'//	10일차 응모 - 에코백 - 100명 - 5%
			win4	= rsget("win4")		'// 당첨여부
			prize5	= rsget("prize5")	'//	11일차 응모 - 마일리지 1,000point -  전원지급
			win5	= rsget("win5")		'// 당첨여부
			prize6	= rsget("prize6")	'//	12일차 응모 - THE LAMP - 10명 - 1%
			win6	= rsget("win6")		'// 당첨여부
		End IF
		rsget.close()
	End If 

	'//js , class 구분
	Dim scnum
	Dim arrcnt : arrcnt = array(3,5,7,10,11,12) '//필요 별 포인트 배열
	Dim prizenum : prizenum = array(prize1,prize2,prize3,prize4,prize5,prize6) '//상품 응모여부 배열
	ReDim strScript(6) , strClass(6)
	For scnum = 1 To 6 '//응모 가짓수
		If totcnt >= arrcnt(scnum-1) Then
			If prizenum(scnum-1) = 0 then
				strScript(scnum) = "jsloststars("& arrcnt(scnum-1) &");"
				strClass(scnum) = "class=""type01"""
			Else
				strScript(scnum) = "alert('이미 응모 하셨습니다.');"
				strClass(scnum) = "class=""type02"""
			End If 
		Else
			strScript(scnum) = "alert('별을 더 켜주세요.');"
			strClass(scnum) = ""
		End If
	Next 
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.mEvt64101 {position:relative;}
.countingStars .sky {position:relative;}
.countingStars .sky span {display:block; position:absolute; left:0; top:0; width:100%; height:100%; background-position:0 0; background-repeat:no-repeat; background-size:100% 100%; cursor:pointer;}
.countingStars .star01 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64101/bg_star01.png);}
.countingStars .star02 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64101/bg_star02.png);}
.countingStars .star03 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64101/bg_star03.png);}
.countingStars .star04 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64101/bg_star04.png);}
.countingStars .star05 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64101/bg_star05.png);}
.countingStars .star06 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64101/bg_star06.png);}
.countingStars .star07 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64101/bg_star07.png);}
.countingStars .star08 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64101/bg_star08.png);}
.countingStars .star09 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64101/bg_star09.png);}
.countingStars .star10 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64101/bg_star10.png);}
.countingStars .star11 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64101/bg_star11.png);}
.countingStars .star12 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64101/bg_star12.png);}
.countingStars .total {position:relative;}
.countingStars .total p {position:absolute; left:0; bottom:40%; width:100%; color:#fff; font-weight:bold; text-align:center;}
.countingStars .total p span {display:inline-block; padding:5px 8px; font-size:16px; background:#000;}
.countingStars .total p strong {color:#fff332; padding:0 2px; text-decoration:underline;}
.starGift {position:relative;}
.starGift ul {overflow:hidden; position:absolute; left:2%; top:17%; width:96%; height:78.5%;}
.starGift li {position:relative; float:left; width:33.33333%; height:50%;}
.starGift li strong {display:none;}
.starGift li span {display:block; position:absolute; left:8%; top:74%; width:84%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64101/btn_wait.png) 0 0 no-repeat; background-size:100% 100%; cursor:pointer;}
.starGift li.type01 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64101/btn_apply.png);}
.starGift li.type02 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64101/btn_finish.png);}
.winLayer {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.7); z-index:50;}
.winLayer .viewResult {padding-top:40px;}
.winLayer .viewResult p {width:84%; margin:0 auto;}
.winLayer .btnClose {display:block; position:absolute; right:4px; top:20px; width:14%;}
.evtNoti {padding:21px 17px;}
.evtNoti h3 strong {display:inline-block; padding:6px 10px 4px; color:#222; font-size:14px; line-height:0.9; background:#dee6e6; border-radius:12px;}
.evtNoti ul {padding-top:12px;}
.evtNoti li {position:relative; font-size:11px; line-height:1.1; padding:0 0 5px 10px; color:#444;}
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:1px; top:4px; width:3.5px; height:3.5px; background:#8c9ace; border-radius:50%;}
@media all and (min-width:480px){
	.countingStars .total p span {padding:7px 12px; font-size:24px;}
	.countingStars .total p strong {padding:0 3px;}
	.evtNoti {padding:31px 26px;}
	.evtNoti h3 strong {padding:9px 15px 6px; font-size:21px; border-radius:18px;}
	.evtNoti ul {padding-top:18px;}
	.evtNoti li {font-size:17px; padding:0 0 7px 15px;}
	.evtNoti li:after {top:6px; width:5px; height:5px;}
}
</style>
<script>
$(function(){
	$(".btnClose").click(function(){
		$(".winLayer").hide();
	});
});

<%' 출석체크 %>
function jsdailychk(){
	<% if Date() < "2015-06-29" or Date() > "2015-07-10" then %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% else %>
	var result;
		$.ajax({
			type:"GET",
			url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript64101.asp",
			data: "mode=daily",
			dataType: "text",
			async:false,
			cache:false,
			success : function(Data){
				result = jQuery.parseJSON(Data);
				if (result.resultcode=="22")
				{
					alert('매일 한 번 별을 켜두실 수 있어요!');
					return;
				}
				else if (result.resultcode=="44")
				{
					alert('로그인이 필요한 서비스 입니다.');
					calllogin();
					return;
				}
				else if (result.resultcode=="11")
				{
					alert('오늘의 별이 떴어요.');
					location.reload();
					return;
				}
			}
		});
	<% end if %>
	}
<%' 응모 %>
function jsloststars(v){
	<% if date() < "2015-06-29" or date() > "2015-07-10" then %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% else %>
	var result;
		$.ajax({
			type:"GET",
			url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript64101.asp",
			data: "mode=stars&loststars="+v,
			dataType: "text",
			async:false,
			cache:false,
			success : function(Data){
				result = jQuery.parseJSON(Data);
				if (result.resultcode=="11")
				{
					if (result.Lcode == 1 || result.Lcode == 3 || result.Lcode == 5){
						alert('응모 완료 되었습니다.');
						$( ".starGift li" ).each( function(index,item){
							if (index == (result.Lcode-1)){
								$(this).addClass("type02");
							}
						});
						return;
					}else{
						$(".winLayer").show();
						$("#prize img").attr("src",result.imgsrc);
						$("#prize img").attr("alt",result.imgalt);
						window.parent.$('html,body').animate({scrollTop:70}, 300);
						$( ".starGift li" ).each( function(index,item){
							if (index == (result.Lcode-1)){
								$(this).addClass("type02");
							}
						});
						return;
					}

				}
				else if (result.resultcode=="22")
				{
					$(".winLayer").show();
					$("#prize img").attr("src",result.imgsrc);
					$("#prize img").attr("alt",result.imgalt);
					window.parent.$('html,body').animate({scrollTop:70}, 300);
					$( ".starGift li" ).each( function(index,item){
						if (index == (result.Lcode-1)){
							$(this).addClass("type02");
						}
					});
					return;
				}
				else if (result.resultcode=="33")
				{
					alert('별을 더 켜주세요.');
					return;
				}

				else if (result.resultcode=="88")
				{
					alert('이벤트 응모 기간이 아닙니다.');
					return;
				}

				else if (result.resultcode=="99")
				{
					alert('이미 응모 하셨습니다.');
					return;
				}
			}
		});
	<% end if %>
	}
</script>
</head>
<body>
<!--별 세는 밤 -->
<div class="mEvt64101">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/64101/tit_count_stars.gif" alt="초능력자들을 기다립니다! 별 세는 밤" /></h2>
	<div class="countingStars">
		<div class="sky <% If totcnt > 0 Then %>star<%=chkiif(totcnt < 10 ,"0"&totcnt,totcnt)%><% End If %>" id="skyclass">
			<span onclick="jsdailychk();"></span>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/64101/bg_sky.gif" alt="" /></div>
		</div>
		<div class="total">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/64101/txt_click_sky.gif" alt="매일 한 번씩 밤하늘을 클릭해주세요!" /></div>
			<% If IsUserLoginOK Then %>
			<p><span><strong><%=userid%></strong>님은 총 <strong id="starcnt"><%=totcnt%></strong>개의 별을 켰습니다.</span></p>
			<% End If %>
		</div>
	</div>
	<div class="starGift">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64101/img_star_gift.gif" alt="별 세고 선물 받기 - 별의 개수에 따라서 응모하실 수 있어요!" /></p>
		<ul>
			<li <%=strClass(1)%>>
				<strong>별 3개:500마일리지 전원증정</strong>
				<span onclick="<%=strScript(1)%>"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64101/btn_blank.png" alt="응모하기" /></span>
			</li>
			<li <%=strClass(2)%>>
				<strong>별 5개:우주인 무드등 200명</strong>
				<span onclick="<%=strScript(2)%>"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64101/btn_blank.png" alt="응모하기" /></span>
			</li>
			<li <%=strClass(3)%>>
				<strong>별 7개:1000마일리지 전원증정</strong>
				<span onclick="<%=strScript(3)%>"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64101/btn_blank.png" alt="응모하기" /></span>
			</li>
			<li <%=strClass(4)%>>
				<strong>별 10개:우주패턴 에코백 100명</strong>
				<span onclick="<%=strScript(4)%>"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64101/btn_blank.png" alt="응모하기" /></span>
			</li>
			<li <%=strClass(5)%>>
				<strong>별 11개:1000마일리지 전원증정</strong>
				<span onclick="<%=strScript(5)%>"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64101/btn_blank.png" alt="응모하기" /></span>
			</li>
			<li <%=strClass(6)%>>
				<strong>별 12개:THE LAMP 10명</strong>
				<span onclick="<%=strScript(6)%>"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64101/btn_blank.png" alt="응모하기" /></span>
			</li>
		</ul>
	</div>
	<div class="winLayer">
		<div class="viewResult">
			<p id="prize"><img src="" alt="" /></p><%'이미지 URL , ALT 처리페이지에서 불러옴%>
			<span class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64101/btn_layer_close.png" alt="" /></span>
		</div>
	</div>
	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>텐바이텐 고객님을 위한 이벤트 입니다.</li>
			<li>텐바이텐 APP에서만 참여할 수 있습니다.</li>
			<li>하루 한 개의 별만 켤 수 있습니다.</li>
			<li>별을 쌓은 개수에 따라서 각 미션에 응모할 수 있습니다.</li>
			<li>이벤트 기간 후에 응모하실 수 없습니다.</li>
			<li>이벤트를 통해 받으실 마일리지는 2015년 7월 15일(수)에 일괄 지급됩니다.</li>
			<li>이벤트 경품에 당첨되신 고객님은 2015년 7월 15일(수)에 배송지 주소를 입력해주세요.</li>
			<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
		</ul>
	</div>
</div>
<!--// 별 세는 밤 -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->