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

'###########################################################
' Description : 주말데이트(앨리스:원더랜드에서 온 소녀)
' History : 2015.11.26 원승현
'###########################################################

dim eCode, cnt, sqlStr, couponkey, regdate, gubun, arrList, i, totalsum, linkeCode, imgLoop, imgLoopVal, irdsite20, arrRdSite, vUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "65962"
	Else
		eCode 		= "67657"
	End If

	vUserID = GetEncLoginUserID

	If IsUserLoginOK Then
		'// 응모여부 가져옴
		sqlstr = "Select count(sub_idx) as cnt" &_
				" From db_event.dbo.tbl_event_subscript" &_
				" WHERE evt_code='" & eCode & "' and userid='" & vUserID & "'"
				'response.write sqlstr
		rsget.Open sqlStr,dbget,1
			totalsum = rsget(0)
		rsget.Close
	End If
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt66424 .photo figcaption {visibility:hidden; width:0; height:0;}
.mEvt66424 .intro {position:relative;}
.movie {padding:0 4%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67567/bg_movie.png) 0 0 no-repeat; background-size:100% 100%;}
.movie .youtube {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#000;}
.movie .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%}
.btnApply {width:100%; vertical-align:top;}
.evtNoti {padding:7% 4.3% 6%; text-align:left; background:#f7f7f7;}
.evtNoti h3 {display:inline-block; font-size:15px; padding-bottom:2px; border-bottom:2px solid #000; font-weight:bold; color:#000; margin:0 0 12px 8px;}
.evtNoti li {position:relative; font-size:11px; line-height:1.4; padding:0 0 3px 8px; color:#444; }
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:4px; width:3px; height:3px; background:#000; border-radius:50%;}
@media all and (min-width:480px){
	.evtNoti h3 {font-size:23px; padding-bottom:3px; margin:0 0 18px 12px;}
	.evtNoti li {font-size:17px; padding:0 0 4px 12px;}
	.evtNoti li:after {top:6px; width:4px; height:4px;}
}
</style>


<script type="text/javascript">

	function checkform(){
		<% If vUserID = "" Then %>
			if ("<%=IsUserLoginOK%>"=="False") {
				<% if isApp=1 then %>
					parent.calllogin();
					return false;
				<% else %>
					parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
					return false;
				<% end if %>
				return false;
			}
		<% End If %>
		<% If vUserID <> "" Then %>
			// 오픈시 바꿔야됨
			<% If Now() >= #11/26/2015 10:00:00# And now() < #11/30/2015 00:00:00# Then %>
				$.ajax({
					type:"GET",
					url:"/event/etc/doEventSubscript67657.asp",
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
										okMsg = res[1].replace(">?n", "\n");
										alert(okMsg);
										return false;
									}
									else
									{
										errorMsg = res[1].replace(">?n", "\n");
										alert(errorMsg);
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
						//var str;
						//for(var i in jqXHR)
						//{
						//	 if(jqXHR.hasOwnProperty(i))
						//	{
						//		str += jqXHR[i];
						//	}
						//}
						//alert(str);
						document.location.reload();
						return false;
					}
				});
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;				
			<% end if %>
		<% End If %>
	}

</script>
<%' 주말데이트:앨리스 %>
<div class="mEvt67349">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/67567/tit_weekend_date.png" alt ="주말데이트 - 외로운 주말, 집에만 있지 말고 텐바이텐과 함께 문화데이트를 즐기세요!" /></h2>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/67567/img_poster.jpg" alt ="영화:앨리스, 원더랜드에서 온 소년" /></div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67567/txt_invite.png" alt ="추첨을 통해 150분(1인2매)에게 영화 '도리화가' 전용 예매권을 드립니다!" /></p>
	<%' 응모하기 %>
	<input type="image" class="btnApply" src="http://webimage.10x10.co.kr/eventIMG/2015/67567/btn_apply.png" alt ="응모하기" onclick="checkform();return false;" />
	<%'// 응모하기 %>
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/67567/tit_synopsis.png" alt ="시놉시스&amp;예고편" /></h3>
	<div class="movie">
		<div class="youtube"><iframe src='http://serviceapi.rmcnmv.naver.com/flash/outKeyPlayer.nhn?vid=27A8D463BFD3F1F021C7CD062F02396D2ED7&outKey=V1212e6f5a462136034db57aa820458275cd77f5573647b91a0c857aa820458275cd7&controlBarMovable=true&jsCallable=true&skinName=default' frameborder='no' scrolling='no' marginwidth='0' marginheight='0' allowfullscreen></iframe></div>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67567/txt_story.png" alt ="현실과 꿈, 과거와 현재가 공준하는 공간 '원더랜드'" /></p>
	<div class="evtNoti">
		<h3>이벤트 안내</h3>
		<ul>
			<li>텐바이텐 고객님을 위한 이벤트 입니다. 비회원이신 경우 회원가입 후 참여해 주세요.</li>
			<li>본 이벤트는 텐바이텐 모바일에서만 참여 가능합니다.</li>
			<li>본 이벤트는 ID당 1회만 응모가능 합니다.</li>
			<li>당첨자는 11월 30일 공지사항을 통해 확인 할 수 있습니다.</li>
			<li>당첨 시 개인정보에 있는 이메일 주소로 관람권이 발송 됩니다.<br />마이텐바이텐에서 이메일 주소를 확인해 주세요!</li>
		</ul>
	</div>
	<p><a href="eventmain.asp?eventid=67585"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67567/bnr_hot_item.jpg" alt ="방한용품 사 볼까요?'" /></a></p>
</div>
<%'// 주말데이트:앨리스 %>