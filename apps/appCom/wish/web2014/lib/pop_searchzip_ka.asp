<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
%>
<%
'###########################################################
' Description :  app 우편번호 찾기
' History : 2016.06.16 원승현 생성
'			2020.01.16 원승현 수정(팝업 형태)
'###########################################################
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
	Dim strTarget
	Dim strMode, protocolAddr
	Dim gubun

	strTarget	= requestCheckVar(Request("target"),32)
	strMode     = requestCheckVar(Request("strMode"),32)
	gubun		= requestCheckVar(Request("gb"),10)
%>
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.500"></script>
<script>    
    $(function(){
		searchZipKakaoLocalApp();
	});

	function detailInputAddress() {
		//document.tranFrmApi.action="pop_searchzipdetail_ka.asp";
		//document.tranFrmApi.submit();
		$("#basicAddrInputArea").empty().html($("#taddr1").val()+$("#taddr2").val()+$("#extraAddr").val());
		$("#searchZipWrap").hide();
		$("#content").show();
		$('body').css('background-color', '#FFFFFF'); 		
		//$("#extraAddr2").focus();
	}

	function returnAddressSearch() {
		$("#content").hide();
		$("#searchZipWrap").show();
		searchZipKakaoLocalApp();
	}	

	<%'// 모창에 값 던져줌 %>
	function CopyZipAPI()	{
		var frm = eval("document.<%=strTarget%>");
		var basicAddr;
		var basicAddr2;
		basicAddr = "";
		basicAddr2 = "";		
		basicAddr = $("#taddr1").val()+$("#taddr2").val()+$("#extraAddr").val();
		basicAddr2 = $("#extraAddr2").val();
		basicAddr  = basicAddr.replace(/・/g,"/").replace(/'/g,"\\'");
		basicAddr2 = basicAddr2.replace(/・/g,"/").replace(/'/g,"\\'");

		// 부모창에 스크립트 전달 후 APP창 닫기
		fnAPPopenerJsCallClose("FnInputZipAddrNew('<%=strTarget%>','"+$("#tzip").val()+"','"+basicAddr+"','"+basicAddr2+"','<%=gubun%>')");
	}

    function searchZipKakaoLocalApp() {
        // 현재 scroll 위치를 저장해놓는다.
        var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
        // 우편번호 찾기 찾기 화면을 넣을 element
        var element_wrap = document.getElementById('searchZipWrap');
		daum.postcode.load(function(){
			new daum.Postcode({
				oncomplete: function(data) {
					var addr = ''; // 주소 변수
					var extraAddr = ''; // 참고항목 변수

					<%'//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.%>
					if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
						addr = data.roadAddress;
					} else { // 사용자가 지번 주소를 선택했을 경우(J)
						addr = data.jibunAddress;
					}

					<%'// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.%>
					if(data.userSelectedType === 'R'){
						<%'// 법정동명이 있을 경우 추가한다. (법정리는 제외)%>
						<%'// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.%>
						if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
							extraAddr += data.bname;
						}
						<%'// 건물명이 있고, 공동주택일 경우 추가한다.%>
						if(data.buildingName !== '' && data.apartment === 'Y'){
							extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
						}
						<%'// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.%>
						if(extraAddr !== ''){
							extraAddr = ' (' + extraAddr + ')';
						}
						<%'// 조합된 참고항목을 해당 필드에 넣는다.%>
						$("#extraAddr").val(extraAddr);
					} else {
						$("#extraAddr").val("");
					}

					<%'// 우편번호와 주소 정보를 해당 필드에 넣는다.%>
					$("#tzip").val(data.zonecode);
					$("#taddr1").val(addr);

					<%'// iframe을 넣은 element를 안보이게 한다.%>
					<%'// (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)%>
					element_wrap.style.display = 'none';

					<%'// 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌린다.%>
					document.body.scrollTop = currentScroll;
				},
				<%'// 사용자가 주소를 클릭했을때%>
				onclose : function(state) {
					if(state === 'COMPLETE_CLOSE'){
						detailInputAddress();
					}
                },
				onresize : function(size) {
					//for (var key in this) {
					//	console.log("attributes : " + key + ", value : " + this[key]);
                    //}
                    //document.getElementById("__daum__layer_"+this.viewerNo).style.height = size.height+"px";
                    //parent.self.scrollTo(0, 0);
                    element_wrap.style.height = size.height + 'px';
                    parent.self.scrollTo(0, 0);
				},
				width : '100%',
				height : '100%',
				hideMapBtn : true,
				hideEngBtn : true,
                shorthand : false,
                maxSuggestItems : 5
			}).embed(element_wrap);
	    });
        <%'// iframe을 넣은 element를 보이게 한다.%>
        element_wrap.style.display = 'block';
        initLayerPosition(element_wrap);
    }

    function initLayerPosition(ele){
        var width = (window.innerWidth || document.documentElement.clientWidth);
        var height = (window.innerHeight || document.documentElement.clientHeight);
        ele.style.width = width-15 + 'px';
        ele.style.height = height + 'px';
    }
</script>
</head>
<body style="background-color:#ececec;" class="default-font body-popup">
<div id="searchZipWrap" style="display:none;border:0px solid;left:7px;width:100%;height:650px;margin:5px 0;position:absolute;overflow:auto;"></div>
<div id="content" class="content addr-detail" style="display:none;">
	<p class="comment">나머지 주소를<br />입력해주세요</p>
	<a href="" onclick="returnAddressSearch();" class="btn-search">주소 다시 검색</a>
	<div class="form-group">
		<p id="basicAddrInputArea"></p>
		<input type="text" name="extraAddr2" id="extraAddr2" placeholder="상세주소 입력" />
	</div>
	<div class="floatingBar">
		<button type="button" class="btn btn-xlarge btn-red btn-block" onclick="CopyZipAPI();">입력하기</button>
	</div>
</div>
<form name="tranFrmApi" id="tranFrmApi" method="post">
	<input type="hidden" name="tzip" id="tzip">
	<input type="hidden" name="taddr1" id="taddr1">
	<input type="hidden" name="taddr2" id="taddr2">
	<input type="hidden" name="extraAddr" id="extraAddr">
	<input type="hidden" name="target" id="target" value="<%=strTarget%>">
	<input type="hidden" name="strMode" id="strMode" value="<%=strMode%>">	
	<input type="hidden" name="gubun" id="gubun" value="<%=gubun%>">		
</form>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
</body>
</html>