<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #INCLUDE virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/header.asp" -->
<!-- #INCLUDE virtual="/lib/classes/facebook/facebookApplyCls.asp" -->
<%
	'//Mobile 접속용 페이지
	Dim iCTotCnt , iCCurrpage , iCPageSize ,iCPerCnt
	dim oFace , i
	Dim code : code = request("code")

	iCCurrpage = RequestCheckVar(request("iCC"),10)
	if iCCurrpage="" then iCCurrpage = 1
	iCPageSize = 6
	iCPerCnt = 3

	set oFace = new CFacebookEvent
	
	oFace.FPageSize = iCPageSize
	oFace.FCurrpage = iCCurrpage
	oFace.FRectIdx = "1"
	
	oFace.GetEventCommentList

	iCTotCnt = oFace.FTotalCount

Function fnDisplayPaging_facebook(strCurrentPage, intTotalRecord, intRecordPerPage, intBlockPerPage, strJsFuncName)
	'변수 선언
	Dim intCurrentPage, strCurrentPath, vPageBody
	Dim intStartBlock, intEndBlock, intTotalPage
	Dim strParamName, intLoop
	'현재 페이지 설정
	intCurrentPage = strCurrentPage		'현재 페이지 값
	'해당페이지에 표시되는 시작페이지와 마지막페이지 설정
	intStartBlock = Int((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + 1
	intEndBlock = Int((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + intBlockPerPage
	'총 페이지 수 설정
	intTotalPage =   int((intTotalRecord-1)/intRecordPerPage) +1 
	''eastone 추가
	if (intTotalPage<1) then intTotalPage=1 
	
	vPageBody = ""
	vPageBody = vPageBody & "<p class=""page"">" & vbCrLf
	'## 첫 페이지
	vPageBody = vPageBody & "			<a href=""javascript:"& strJsFuncName & "(1)"" class=""start"" >맨 앞페이지로 이동</a>" & vbCrLf
	'## 이전 페이지
	If intStartBlock > 1 Then
		vPageBody = vPageBody & "			<a href=""javascript:"& strJsFuncName & "(" & intStartBlock -1 & ")"" class=""prev"" >이전 페이지로 이동</a>" & vbCrLf
	Else
		vPageBody = vPageBody & "			<a href=""javascript:void(0);"" class=""prev"">이전 페이지로 이동</a>" & vbCrLf
	End If
	'## 현재 페이지
	If intTotalPage > 1 Then
		For intLoop = intStartBlock To intEndBlock
			If intLoop > intTotalPage Then Exit For
			If Int(intLoop) = Int(intCurrentPage) Then
				vPageBody = vPageBody & "			<a href=""javascript:void(0);"" class=""current"">" & intLoop & "</a>" & vbCrLf
			Else
				vPageBody = vPageBody & "			<a href=""javascript:" & strJsFuncName & "(" & intLoop & ")"" title=""" & intLoop & " 페이지"">" & intLoop & "</a>" & vbCrLf
			End If
		Next
	Else
		vPageBody = vPageBody & "			<a href=""javascript:" & strJsFuncName & "(1)""  class=""current"">1</a>" & vbCrLf
	End If
	'## 다음 페이지
	If Int(intEndBlock) < Int(intTotalPage) Then	'####### 다음페이지
		vPageBody = vPageBody & "			<a href=""javascript:"& strJsFuncName & "(" & intEndBlock+1 & ")"" class=""next"" >다음 페이지로 이동</a>" & vbCrLf
	Else
		vPageBody = vPageBody & "			<a href=""javascript:void(0);"" class=""next"">다음 페이지로 이동</a>" & vbCrLf
	End If
	'## 마지막 페이지
	vPageBody = vPageBody & "			<a href=""javascript:"& strJsFuncName & "(" & intTotalPage & ")"" class=""end""  >마지막</a>" & vbCrLf
	vPageBody = vPageBody & "</p>" & vbCrLf
	fnDisplayPaging_Facebook = vPageBody
	
End Function
%>
<style type="text/css">
	.fbSpring .ct {text-align:center;}
	.fbSpring .giftList {overflow:hidden;}
	.fbSpring .giftList li {float:left; width:50%;}
	.fbSpring .step02 {background:url(http://fiximage.10x10.co.kr/m/event/facebook/facebook_step2.png) left top no-repeat; padding:25px 0; background-size:16.09375%;}
	.fbSpring .cmtWrite {background:url(http://fiximage.10x10.co.kr/m/event/facebook/facebook_txt2.png) left top no-repeat; margin:0 auto; width:261px; background-size:100%; padding:39px 0 4px 9px;}
	.fbSpring .step02 input[type=text] {padding:3px 5px; -webkit-appearance:none; -webkit-border-radius:0; border:1px solid #c5c5c5;}
	.fbSpring .cmtWrite input[type=text] {background:#fbfd82; border:none;}
	.fbSpring .cmtInfo {border-top:1px solid #e5e5e5; margin:5%; padding-top:5%;}
	.fbSpring .infoWrite {width:70%; margin:5% auto;}
	.fbSpring .infoWrite label {font-size:1.1em; font-weight:bold; display:inline-block; width:55px;}
	.fbSpring .agree {text-align:center;}
	.fbSpring .agree input[type=checkbox] {width:12px; height:12px; -webkit-border-radius:0;}
	.fbSpring .agree span {letter-spacing:-0.02em; padding:0 9px; font-size:0.85em;}
	.fbSpring .cmtList {background:url(http://fiximage.10x10.co.kr/m/event/facebook/facebook_bg.png) left top repeat-y; padding:0.75em; text-align:center;}
	.fbSpring .cmtList li {border-radius:8px; padding:1em; margin:0.5em 0;}
	.fbSpring .cmtList li.boxY {background:#fdff9e;}
	.fbSpring .cmtList li.boxP {background:#ffebec;}
	.fbSpring .cmtList li.boxG {background:#e6ffca;}
	.fbSpring .cmtList li dl {background-repeat:no-repeat; background-position:right bottom; background-size:24px; padding:0 3em 0 5.75em; position:relative; font-size:0.75em; min-height:55px; text-align:left;}
	.fbSpring .cmtList li dl dt {font-weight:bold; color:#5aab02; padding-bottom:5px;}
	.fbSpring .cmtList li dl dt a {color:#5aab02; text-decoration:none;}
	.fbSpring .cmtList li dl dt a:hover {text-decoration:underline;}
	.fbSpring .cmtList li dl dd {letter-spacing:-1px; line-height:1.4;}
	.fbSpring .cmtList li dl .pic {position:absolute; left:0; top:0;}
	.fbSpring .cmtList li.boxY dl {background-image:url("http://fiximage.10x10.co.kr/m/event/facebook/facebook_deco1.png");}
	.fbSpring .cmtList li.boxP dl {background-image:url("http://fiximage.10x10.co.kr/m/event/facebook/facebook_deco2.png");}
	.fbSpring .cmtList li.boxG dl {background-image:url("http://fiximage.10x10.co.kr/m/event/facebook/facebook_deco3.png");}
	.fbSpring .page {text-align:center; padding-bottom:50px;}
	.fbSpring .page a {display:inline-block; width:25px; height:28px; text-align:center; background-image:url("http://fiximage.10x10.co.kr/web2012/event/facebook/facebook_spring_paging.png"); background-repeat:no-repeat; background-position:-150px top; font-size:11px; font-weight:bold; color:#707070; font-family:dotum, '돋움', sans-serif; text-decoration:none; line-height:28px; vertical-align:top;}
	.fbSpring .page a.current {background-position:-95px top; color:#fff;}
	.fbSpring .page a.start {background-position:7px top; text-indent:-9999px; overflow:hidden;}
	.fbSpring .page a.prev {background-position:-35px top; text-indent:-9999px; overflow:hidden;}
	.fbSpring .page a.next {background-position:-198px top; text-indent:-9999px; overflow:hidden;}
	.fbSpring .page a.end {background-position:-238px top; text-indent:-9999px; overflow:hidden;}
</style>
<div id="fb-root"></div>
<script type="text/javascript">
	window.fbAsyncInit = function() {
	    FB.init({
	        appId : '173472042802461',
	        status : true,
	        cookie : true,
	        xfbml : true,
	        oauth  : true
	    });

		// Additional initialization code here
		FB.getLoginStatus(function(response) {
			if (response.status === 'connected') {

				var uid = response.authResponse.userID;
				var accessToken = response.authResponse.accessToken;

				FB.api({
				  method:     "pages.isFan",
				  page_id:    "181120081908512",
				},  function(response) {
					if(response){
						$(".fbSpring").css("display","");
						$(".fbSpringno").css("display","none");
					} else {
					  //alert("없긔");
					}
				  }
				);

       // facebook 회원 정보 조회
        getinfo();

			} else if (response.status === 'not_authorized') {
        // facebook 회원 정보 조회
        getinfo();

			} else {
        // facebook 회원 정보 조회
        getinfo();
		
			}
		});

	FB.Event.subscribe('edge.create', function(href, widget) {
	   location.href="http://apps.facebook.com/tenten_spring";
	});

	FB.Event.subscribe('edge.remove', function(href, widget) {
	   location.href="http://apps.facebook.com/tenten_spring";
	});
	    // facebook height auto resize
	    FB.Canvas.setAutoGrow();
	};

  function getinfo() {
	//사용자 정보 받아오시오
    FB.api('me/',
    function(response) {
         fbuid = response.id;
         fbname = response.name;
         fbemail = response.email;
		 fbuphoto = "https://graph.facebook.com/"+response.id+"/picture";
 		 document.frm.fbuname.value=fbname;
 		 document.frm.fbuphoto.value=fbuphoto;
 		 document.frm.fbuid.value=fbuid;

         },{scope: 'publish_stream,read_stream,user_likes'}
    );
  }

	function sizeChangeCallback() {
		FB.Canvas.setSize();
	}

	//자동 포스팅
	function autoPublish(){

			var params = {};
				
				  params['method'] = 'feed';
				  params['name'] = '텐바이텐에서 봄을 타자 \n\n';
  				  params['link'] = 'http://apps.facebook.com/tenten_spring';
				  params['caption'] = 'http://apps.facebook.com/tenten_spring';
				  params['description'] = '봄타는 내마음을 달래줄 텐바이텐의 선물을 받아가세요!\n\n자전거부터 신상백, 폴라로이드까지 선물이 가~득!';
  				  params['message'] = '올봄에 꼭  '+document.frm.txtcomm.value+' 할 거에요!:)\n\n 이벤트 참여하기 :  http://apps.facebook.com/tenten_spring';
				
			  FB.api('/me/feed', 'post', params, function(response) {
				if (!response || response.error) {
				  alert("잠시 후에 다시 시도해주세요.");
				} else {
					console.log(response);
					var frm = document.frm;
					var eventid = frm.eventid.value;
					var fbuname = frm.fbuname.value;
					var fbuphoto = frm.fbuphoto.value;
					var spoint = frm.spoint.value;
					var txtcomm = frm.txtcomm.value;
					var uname = frm.uname.value;
					var uphone = frm.uphone.value;

					$.ajax({
						url: "/apps/facebook/chungchun/index_proc.asp?eventid="+eventid+"&fbuname="+fbuname+"&fbuphoto="+fbuphoto+"&spoint="+spoint+"&txtcomm="+txtcomm+"&uname="+uname+"&uphone="+uphone, 
						cache: false,
						success: function(message) 
						{			
							$("#tempdiv").empty().append(message);
						}
					});	
				 }
			  });
		}

	//Load the SDK Asynchronously
	(function(d){
		var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
		if (d.getElementById(id)) {return;}
		js = d.createElement('script'); js.id = id; js.async = true;
		js.src = "//connect.facebook.net/ko_KR/all.js";
		ref.parentNode.insertBefore(js, ref);
	}(document));
</script>
<script type="text/javascript">
<!--
 	function jsGoComPage(iP){
		document.frm.iCC.value = iP;
		document.frm.iCTot.value = "<%=iCTotCnt%>";
		//document.frm.submit();	
		location.href= "index_mobile.asp?iCC="+iP;
	}

	$(function() {
		//step01 click
		$(".step01").each(function(){
			$(".step01 li").click(function(){

				alert("이벤트가 종료 되었습니다. ^^");
				return false;

				$('.step01').css("display","none");
				$('.step02').css("display","");
				document.frm.spoint.value = $(this).attr("rel"); //form 값으로 넣기
			});
		});

		$("#backstep").click(function(){
			$('.step02').css("display","none");
			$('.step01').css("display","");
			document.frm.spoint.value = "";
		});

		$("#submit").click(function(){
			var frm = document.frm;

			if(frm.txtcomm.value == ""){
				alert("코멘트를 입력해주세요");
				frm.txtcomm.focus();
				return false;
			}

			if(frm.uname.value == ""){
				alert("이름을 입력해주세요");
				frm.uname.focus();
				return false;
			}

			if(frm.uphone.value == ""){
				alert("연락처를 입력해주세요");
				frm.uphone.focus();
				return false;
			}

			if(!(frm.agree.checked)){
				alert("개인정보 수집 정책에 동의 해주세요.");
				frm.agree.focus();
				return false;
			}

		    //페북 자동 글 등록 
			autoPublish();
		});

	});
//-->
</script>
<!-- 헤더영역 -->
<div selected="true">
	<div style="padding:5px; overflow:hidden;">
		<div class="fb-like" style="float:right;" data-href="http://www.facebook.com/your10x10" data-send="false" data-layout="button_count" data-width="450" data-show-faces="false"></div>
	</div>
	<div class="fbSpringno"><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_first_m.jpg" alt="텐바이텐에서 봄을 타자" style="width:100%;" /></div>
	<div class="fbSpring" style="display:none;">
		<form name="frm" method="POST" style="margin:0px;">
		<input type="hidden" name="eventid" value="1"> 
		<input type="hidden" name="iCC" value="<%=iCCurrpage%>"> 
		<input type="hidden" name="iCTot" value=""> 
		<input type="hidden" name="spoint" value="">
		<input type="hidden" name="fbuname" value="">
		<input type="hidden" name="fbuphoto" value="">
		<input type="hidden" name="fbuid" value="">
		<input type="hidden" name="code">
		<p><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_head.png" alt="텐바이텐에서 봄을 타자" style="width:100%;" /></p>
		<div class="step01">
			<ul class="giftList">
				<li rel="1"><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_gift1.png" alt="접이식 미니벨로 자전거" style="width:100%;" /></li>
				<li rel="2"><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_gift2.png" alt="레더사첼 가방" style="width:100%;" /></li>
				<li rel="3"><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_gift3.png" alt="인스탁스 폴라로이드" style="width:100%;" /></li>
				<li rel="4"><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_gift4.png" alt="타이맥스 시계" style="width:100%;" /></li>
			</ul>
			<p><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_txt.png" alt="당첨자 발표 후, 재고수량에 따라서 상품이 변경될 수 있습니다. 상품의 옵션 및 컬러는 랜덤으로 발송됩니다." style="width:100%;" /></p>
		</div>
		<div class="step02" style="display:none;">
			<p class="cmtWrite"><input type="text" name="txtcomm" style="width:123px" maxlength="30"/></p>
			<div class="cmtInfo">
				<p style="letter-spacing:-0.05em; font-weight:bold; text-align:center;">이벤트 당첨자 선정을 위해 개인 정보를 입력해 주세요.</p>
				<div class="infoWrite">
					<p><label for="name">이&nbsp;&nbsp;&nbsp;름 :</label> <input type="text" id="name" style="width:65%;"  name="uname" value="" maxlength="20"/></p>
					<p style="padding-top:0.5em;"><label for="tel">연락처 :</label> <input type="text" id="tel" style="width:65%;" name="uphone" value=""  maxlength="13"/></p>
				</div>
				<p class="agree">
					<span><input type="checkbox" id="agree" /> <label for="agree">개인정보 수집 정책에 동의</label></span>
					<span><a href="https://www.facebook.com/notes/%ED%85%90%EB%B0%94%EC%9D%B4%ED%85%90/%ED%85%90%EB%B0%94%EC%9D%B4%ED%85%90-%EA%B0%9C%EC%9D%B8-%EC%A0%95%EB%B3%B4-%EB%B3%B4%ED%98%B8-%EC%A0%95%EC%B1%85/519605374758605" target="_blank">[개인정보수집정책 보기]</a></span>
				</p>
			</div>
			<p><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_txt3.png" alt="입력된 개인 정보는 경품 배송을 위한 목적으로만 사용되며, 배송완료 후 삭제 됩니다." style="width:100%;" /></p>
			<p class="ct">
				<img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_btn_ok.png" alt="응모완료" style="width:126px;" id="submit" />
				<img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_btn_cancel.png" alt="응모취소" style="width:126px;" id="backstep"/>
			</p>
		</div>
		<% if oFace.FResultCount > 0 then %>
		<div class="cmtList">
			<ul>
				<% for i = 0 to oFace.FResultCount - 1 %>
				<li class="box<% If i = 0 Or i = 3 Then response.write "Y" Else If  i = 1 Or i = 4 Then response.write "P" Else If  i = 2 Or i = 5 Then response.write "G" End If  %>">
					<dl>
						<dt><%=oFace.FItemList(i).Ffbuname%>님은</dt>
						<dd>올 봄에 꼭&nbsp;&nbsp;<strong><%=oFace.FItemList(i).Ffbsubopt2%></strong>&nbsp;&nbsp;할 거예요! : )</dd>
						<dd class="pic"><img src="<%=oFace.FItemList(i).Ffbuphoto%>" style="width:50px; height:50px;"/></dd>
					</dl>
				</li>
				<% Next %>
			</ul>
		</div>
		<%= fnDisplayPaging_Facebook(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
		<% End If %>
		</form>
	</div>
</div>
<div id="tempdiv" style="display:none;"></div>
<!-- 푸터영역 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->