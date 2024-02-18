<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/header.asp" -->
<%
	'로그인 상태 체크
	if Not(IsUserLoginOK) then
		Call Alert_close("로그인이 필요합니다.")
		response.end
	end if

	dim refer
	refer = request.ServerVariables("HTTP_REFERER")

	'회원 기본정보 접수
	dim sqlStr, username, jumin1, realnamecheck
	sqlStr = " select username, jumin1, realnamecheck "
	sqlStr = sqlStr + " from [db_user].[dbo].tbl_user_n "
	sqlStr = sqlStr + "	Where userid='" + GetLoginUserID + "' "
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		username = rsget("username")
		jumin1 = rsget("jumin1")
		realnamecheck = rsget("realnamecheck")
	end if
	rsget.close

	'실명확인 상태 체크
	if realnamecheck="Y" then
		Call Alert_Return("이미 실명확인을 하셨습니다.\n\n※반복적으로 실명확인 메시지가 나타나면 로그아웃 후 다시 로그인을 해주세요.")
		response.end
	end if
%>
<!--	==========================================================	-->
<!--	한국신용정보주식회사 처리 모듈                            	-->
<!--	==========================================================	-->
<script type="text/javascript" src="http://secure.nuguya.com/nuguya/nice.nuguya.oivs.crypto.js"></script>
<script type="text/javascript" src="http://secure.nuguya.com/nuguya/nice.nuguya.oivs.msg.js"></script>
<script type="text/javascript" src="http://secure.nuguya.com/nuguya/nice.nuguya.oivs.util.js"></script>
<!--	==========================================================	-->
<script type="application/x-javascript" src="/lib/js/iui_clickEffect.js"></script>
<script language="javascript">
<!--
	// 전송폼 확인
	function jsSumitForm() {
	    if (frmsocno.socno1.value.length != 6) {
	            alert("등록번호 앞자리를 입력하세요.");
	            frmsocno.socno1.focus();
	            return false;
	    }
	    else
	    {
	        if (!isNumeric(frmsocno.socno1.value)) {
	                alert("등록번호 앞자리를 숫자로 입력하세요.");
	                frmsocno.socno1.focus();
	                return false;
	        }
	    }
	
	    if (frmsocno.socno2.value.length != 7) {
	            alert("등록번호 뒷자리를 입력하세요.");
	            frmsocno.socno2.focus();
	            return false;
	    }
	
	    if (!isNumeric(frmsocno.socno2.value)) {
	            alert("등록번호 뒷자리를 숫자로 입력하세요.");
	            frmsocno.socno2.focus();
	            return false;
	    }

	    if (frmsocno.username.value == "") {
	            alert("이름을 입력하세요.");
	            frmsocno.username.focus();
	            return false;
	    }

		if ( validate() == true )
		{
			var strNm = document.frmsocno.username.value;
			var strNo = document.frmsocno.socno1.value + document.frmsocno.socno2.value;
			var strRsn = document.frmsocno.inqRsn.value;
			var strForeigner = document.frmsocno.foreigner.value;
			document.inputForm.SendInfo.value = makeSendInfo( strNm, strNo, strRsn, strForeigner );
	
			var form = document.inputForm;
			form.action="<%=m_SSLUrl%>/login/doNameCheck.asp";
			form.submit();
		}
		return false;
	}

	// 숫자입력 확인
	function isNumeric(s) {
	        for (i=0; i<s.length; i++) {
	                c = s.substr(i, 1);
	                if (c < "0" || c > "9") return false;
	        }
	        return true;
	}

	// 칸이동
	function TnNextTab(thisComp,targetComp,num) {
	    if (thisComp.value.length==num){
	        targetComp.focus();
	    }
	}

	// 실명인증 Script
	function validate()
	{
		var userNm = document.frmsocno.username;
		var userNo1 = document.frmsocno.socno1;
		var userNo2 = document.frmsocno.socno2;
		var foreigner = document.frmsocno.foreigner;
		var userNo = document.frmsocno.socno1.value + document.frmsocno.socno2.value;
	
		if ( document.frmsocno.username.value == "" )
		{
			//alert( getCheckMessage( "S23" ) );
			document.frmsocno.username.focus();
			return false;
		}
	
		if ( document.frmsocno.socno1.value == "" )
		{
			if ( document.frmsocno.foreigner.value == "2" )
				alert( getCheckMessage( "S27" ) );
			else
				alert( getCheckMessage( "S21" ) );
			document.frmsocno.socno1.value = "";
			document.frmsocno.socno1.focus();
			return false;
		}
	
		if ( document.frmsocno.socno2.value == "" )
		{
			if ( document.frmsocno.foreigner.value == "2" )
				alert( getCheckMessage( "S27" ) );
			else
				alert( getCheckMessage( "S21" ) );
			document.frmsocno.socno2.value = "";
			document.frmsocno.socno2.focus();
			return false;
		}
	
		if ( document.frmsocno.foreigner.value == "2" )
		{
			if ( checkForeignNm( document.frmsocno.username.value ) == false )
			{
				alert( getCheckMessage( "S28" ) );
				document.frmsocno.username.focus();
				return false;
			}
	
			if ( checkForeignNo( userNo ) == false )
			{
				alert( getCheckMessage( "S26" ) );
				document.frmsocno.socno2.focus();
				return false;
			}
		}
		else
		{
			if ( checkString( document.frmsocno.username.value ) == false )
			{
				alert( getCheckMessage( "S24" ) );
				document.frmsocno.username.focus();
				return false;
			}
	
			if ( checkNumeric( userNo ) == false )
			{
				alert( getCheckMessage( "S25" ) );
				document.frmsocno.socno1.focus();
				return false;
			}
		}
	
		return true;
	}

	function selForeign(cFgn) {
		if(cFgn==1) {
			document.all.socImg.src="http://fiximage.10x10.co.kr/m/mytenten/txt_snum.png";
			document.frmsocno.foreigner.value="1";
			document.all.frgnNmInfo.style.display="none";
		} else {
			document.all.socImg.src="http://fiximage.10x10.co.kr/m/mytenten/txt_fsnum.png";
			document.frmsocno.foreigner.value="2";
			document.all.frgnNmInfo.style.display="";
		}
	}
//-->
</script>
<div class="toolbar">
	<!-- INCLUDE Virtual="/lib/inc_topMenu.asp" -->
</div>
<div id="home" selected="true">
	<!--네비게이션바-->
	<div id="history" selected="true"><a href="javascript:history.back();"><img src="http://fiximage.10x10.co.kr/m/common/btn_prev.png" width="82" height="30" class="btnprev"></a></div>
	<!-- 실명확인폼 -->
	<div id="my2">
		<div id="my2Tit">
			<p><img src="http://fiximage.10x10.co.kr/m/mytenten/tit_chkname.png" /></p>
			<p class="tm15"><span class="vipTit">인터넷 게시판 이용자의 본인 확인제 실시</span></p>
			<p class="tm10">정보통신망 법 제 44조의 5및 동법 시행령 제30조에 근거하여 이용자가 게시판에 정보를 게시하려고 할 경우, 해당 게시판 관리•운영자가 게시판 이용자의 본인여부를 확인하는 제도입니다. 2009년 4월 1일부터 공공기관등과 일일 평균 이용자 수 10만 명 이상의 정보통신 서비스 제공자를 대상으로 하고 있으며 이 기준에 따라 텐바이텐은 아래와 같이 본인 확인을 시행하고자 합니다.</p>
			<p class="tm10"><span class="chkRead">실명확인은 한번만 하시면 됩니다.</span></p>
			<p>이후에는 텐바이텐 내의 상품후기 글을 포함, 여러 게시판을 이용할 수 있습니다.</p>
		</div>
		<!--본인확인-->
		<div id="chkname">
		<form name="frmsocno" method="post" action="" onsubmit="return jsSumitForm();">
		<input type="hidden" id="foreigner" name="foreigner" value="1">
		<input type="hidden" id="inqRsn" name="inqRsn" value="20">
			<div id="chkSelect">
				<table>
				<tr>
					<td style="padding-right:30px;"><input type="radio" name="frgn" id="frgn" value="1" checked onClick="selForeign(this.value)" /> 일반회원</td>
					<td><input type="radio" name="frgn" id="frgn" value="2" onClick="selForeign(this.value)" /> 외국인회원</td>
				</tr>
				</table>
			</div>
			<!-- 입력폼 -->
			<div id="checkName">
				<dl>
					<dt><img id="socImg" name="socImg" src="http://fiximage.10x10.co.kr/m/mytenten/txt_snum.png" /></dt>
					<dd><input name="socno1" type="text" class="snuminput" value="<%=jumin1%>" readonly>
						- <input name="socno2" type="password" class="snuminput" maxlength="7"></dd>
					<dt><img src="http://fiximage.10x10.co.kr/m/mytenten/txt_name02.png" /></dt>
					<dd><input name="username" value="<%=username%>" type="text" class="addinput" maxlength="32" style="width:197px;"></dd>
					<dd id="frgnNmInfo" style="display:none"><span class="teltxt">외국인등록증, 외국국적동포: 영문 대문자, 재외국인: 한글</span></dd>
				</dl>
			</div>
			<div id="bigBtnArea" align="center" style="padding-bottom:12px;">
				<input type="image" src="http://fiximage.10x10.co.kr/m/common/btn_ok02.png" />
				<a href="javascript:history.back();"><img src="http://fiximage.10x10.co.kr/m/common/btn_cancel_01.png" /></a>
			</div>
		</form>
		</div>
		<FORM name="inputForm" method="POST" action="">
		<input type="hidden" id="SendInfo" name="SendInfo">
		<input type="hidden" name="backUrl" value="<%=refer%>">
		</FORM>
	</div>
	<!--푸터영역-->
</div>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->