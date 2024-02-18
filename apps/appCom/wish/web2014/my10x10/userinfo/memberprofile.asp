<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 나의정보
'	History	:  2014.09.18 한용민 생성
'#######################################################
%>
<!-- #include virtual="/apps/appcom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/commlib.asp" -->

<%
dim i, iMyProfileNum

if GetLoginUserICon="" or GetLoginUserICon=0 then
	iMyProfileNum = getDefaultProfileImgNo(getEncLoginUserID)
else
	iMyProfileNum = GetLoginUserICon
end if
%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type='text/javascript'>

//$(function(){
//	$('.profileList li').click(function(){
//		$('.profileList li').find('em').hide();
//		$(this).find('em').show();
//	});
//});

$(function(){
	// Top버튼 위치 이동
	//$(".goTop").addClass("topHigh");

	// 기본 프로필 이미지 선택
	imgchange('<%= iMyProfileNum %>');
});


function imgchange(imgid){
	var Pbnum = imgid;

	$('.profileList li').find('em').hide();
	$("#img"+Pbnum).find('em').show();
	$("#usericonno").val(Pbnum);
	//$('.profileList li').find('em').hide();
}

function imgreg(){
	var ret = confirm('정보를 수정 하시겠습니까?');
	if (ret){
		var rstStr = $.ajax({
			type: "POST",
			url: "/apps/appcom/wish/web2014/my10x10/userinfo/memberprofile_process.asp",
			data: "mode=usericonnoreg&usericonno="+$("#usericonno").val(),
			dataType: "text",
			async: false
		}).responseText;

		if (rstStr == "2"){
			alert('로그인을 해주세요.');
			return false;
		}else if (rstStr == "3"){
			alert('프로필 이미지를 선택해 주세요.');
			return false;
		}else if (rstStr == "1"){
			//alert('프로필 이미지가 저장 되었습니다.');
			//location.reload();
			fnAPPsetMyIcon($("#usericonno").val());
			setTimeout(function(){fnAPPopenerJsCallClose("window.location.reload()");}, 100);
		}else{
			alert('오류가 발생했습니다.');
			return false;
		}
	}
}

</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
			<input type="hidden" name="usericonno" id="usericonno">
			<div class="profileImage">
				<p class="tip">원하는 프로필 이미지를 선택해 주세요.<br />프로필 이미지는 언제든지 변경이 가능합니다.</p>
				<ul class="profileList">
					<% for i = 1 to 30 %>
						<li id="img<%= i %>">
							<p>
								<em></em>
								<img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member<%= Format00(2,i) %>.png" onclick="imgchange('<%= i %>');" alt="" />
							</p>
						</li>
					<% next %>
				</ul>
			</div>
		</div>
		<div class="floatingBar">
			<div class="btnWrap">
				<div class="ftBtn"><span class="button btB1 btRed cWh1 w100p"><input type="submit" onclick="imgreg();" value="저장" /></span></div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->