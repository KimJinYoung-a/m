<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  BML에서 진행하는 모바일 QR 이벤트
' History : 2015.04.28 원승현 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->

<%
	Dim nowdate, LoginUserid, sqlstr, result1, result2, eCode

	nowdate = now()
'	nowdate = "2015-05-02 10:00:00"
	LoginUserid = getLoginUserid()


	IF application("Svr_Info") = "Dev" THEN
		eCode   =  61768
	Else
		eCode   =  61909
	End If


	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
	rsget.Open sqlstr, dbget, 1
	If Not(rsget.bof Or rsget.Eof) Then
		'// 기존에 응모 했을때 값
		result1 = rsget(0) '//응모여부(1-응모)
		result2 = rsget(1) '//당첨여부(lg스마트빔 미니 프로젝터(projector), 아이리버 블루투스 스피커(speaker), 장미 리본 꽃팔찌(band), 텐바이텐 할인쿠폰(coupon))
	Else
		'// 최초응모
		result1 = ""
		result2 = ""
	End IF
	rsget.close
%>

<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
.mEvt61909 img {vertical-align:top;}
.presentTenten {position:relative; padding:0 3%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/61909/bg_flower.gif) left top repeat-y; background-size:100% auto;}
.presentTenten .applyEvt {padding:6% 0; border:1px solid #dccea0; background-color:#fff; border-radius:3.5%;}
.presentTenten .applyEvt h3 {width:84%; margin:0 auto;}
.presentTenten .selectPeak {overflow:hidden; padding:6.5% 2.5% 5%;}
.presentTenten .selectPeak li {float:left; width:33.33333%; padding:0 1.5%; text-align:center;}
.presentTenten .selectPeak li label {display:inline-block; padding-bottom:9%;}
.presentTenten .btnSubmit {display:block; width:86%; margin:0 auto;}
.presentTenten .applyResult {position:absolute; left:2.5%; top:0; width:95%;}
.noti {padding:15px 15px 0;}
.noti h2 {color:#222; font-size:14px;}
.noti h2 strong {border-bottom:2px solid #000;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:6px; left:0; width:4px; height:1px; background-color:#444;}
@media all and (min-width:480px){
	.noti {padding:23px 23px 0;}
	.noti h2 {font-size:21px;}
	.noti ul {margin-top:20px;}
	.noti ul li {padding-left:15px; font-size:17px;}
	.noti ul li:after {top:9px; width:6px;}
}
</style>
<script type="text/javascript">


function goPeakSc()
{

	<% If left(nowdate,10)>="2015-05-02" and left(nowdate,10)<"2015-05-04" Then %>
	<% else %>
		alert("이벤트 기간이 아닙니다.");
		return false;
	<% end if %>


	<% If not(IsUserLoginOK) Then %>
		parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
		return false;
	<% end if %>

	if ($('input:radio[name="SelectPeak"]:checked').val()!="on")
	{
		alert("마음에 드는 기타피크를 선택해 주세요.");
		return false;
	}

	<% If IsUserLoginOK Then %>
		<% If left(nowdate,10)>="2015-05-02" and left(nowdate,10)<"2015-05-04" Then %>
			$.ajax({
				type:"POST",
				url:"doEventSubscript61909.asp",
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
									$("#rtp").empty().html(res[1]);
								}
								else
								{
									errorMsg = res[1].replace(">?n", "\n");
									alert(errorMsg );
									$(".mask").hide();
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
					var str;
					for(var i in jqXHR)
					{
						 if(jqXHR.hasOwnProperty(i))
						{
							str += jqXHR[i];
						}
					}
					alert("잘못된 접근 입니다.");
					document.location.reload();
					return false;
				}
			});
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
		return false;
	<% End If %>
}



</script>
</head>
<body>
<div class="mEvt61909">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/61909/tit_present_tenten.gif" alt ="선물충전소 텐바이텐 - 텐바이텐 부스에서 봄 충전 잘 하셨나요? 고객님께 고마운 마음을 담아 선물도 충전 해드립니다." /></h2>
	<div class="presentTenten">
		<%' 이벤트 응모 %>
		<div class="applyEvt">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/61909/tit_select_peak.gif" alt ="응모만 하면 100% 선물 증정! 아래의 기타 피크 중에 마음에 드는 디자인을 골라보세요. 당신에게 특별한 선물이 주어집니다!" /></h3>
			<ul class="selectPeak">
				<li>
					<label for="peak01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61909/img_peak01.gif" alt ="피크1" /></label>
					<input type="radio" id="peak01" name="SelectPeak" />
				</li>
				<li>
					<label for="peak02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61909/img_peak02.gif" alt ="피크2" /></label>
					<input type="radio" id="peak02" name="SelectPeak" />
				</li>
				<li>
					<label for="peak03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61909/img_peak03.gif" alt ="피크3" /></label>
					<input type="radio" id="peak03" name="SelectPeak" />
				</li>
			</ul>
			<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/61909/btn_apply.gif" alt="응모하기" class="btnSubmit" onclick="goPeakSc();return false;"/>
		</div>
		<%'// 이벤트 응모 %>

		<%' 응모 결과 %>
		<%
			'// 만약 이미 참여한 회원이라면 당첨된 이미지를 계속 보여줌
			sqlstr = "select sub_opt3 From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt3 in ('projector','speaker','band','coupon') And userid='"&LoginUserid&"' And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				If Trim(rsget(0))="project" Then
					response.write "<div class='applyResult' style='display:block;'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61909/img_win01.png' alt ='LG 스마트빔 미니 프로젝터 당첨' /></p></div>"
				ElseIf Trim(rsget(0))="speaker" Then
					response.write "<div class='applyResult' style='display:block;'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61909/img_win02.png' alt ='아이리버 휴대용 블루투스 스피커 당첨' /></p></div>"
				ElseIf Trim(rsget(0))="band" Then
					response.write "<div class='applyResult' style='display:block;'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61909/img_win03.png' alt ='장미 리본 꽃 팔찌 당첨' /></p></div>"
				ElseIf Trim(rsget(0))="coupon" Then
					response.write "<div class='applyResult' style='display:block;'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61909/img_win04.png' alt ='텐바이텐 15% 할인쿠폰 당첨' /></p></div>"
				End If
			Else
				response.write "<div id='rtp'></div>"
			End If
			rsget.close
		%>
		<%'// 응모 결과 %>
	</div>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/61909/img_present_preview02.jpg" alt ="선물 미리보기" /></div>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/61909/txt_with_fujifilm_.jpg" alt ="BML2015 현장에서 텐바이텐과 함께 한 순간을 찍어주세요!" /></div>
	<div class="noti">
		<h2><strong>이벤트 주의사항</strong></h2>
		<ul>
			<li>텐바이텐 로그인 후 참여할 수 있습니다.</li>
			<li>이벤트는 매일 한 ID당 한 번만 응모할 수 있습니다.</li>
			<li>본 이벤트 상품은 BML 2015 페스티벌 현장에서만 수령하실 수 있습니다.</li>
			<li>BML 2015 페스티벌 기간 이후에는 경품 수령이 불가합니다.</li>
			<li>텐바이텐 할인쿠폰은 당첨즉시 발급됩니다.</li>
			<li>텐바이텐 할인쿠폰 유효기간은 2015년 5월 31일까지입니다.</li>
			<li>본 이벤트의 경품수령 시, 개인정보를 요청하게 됩니다.</li>
		</ul>
	</div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->