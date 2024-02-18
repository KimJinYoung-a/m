	var EvalShowingID=''; //현재 보이는 상품 후기 정렬 번호

	//상품 후기 펼치기 & 접기
	function ShowHideEvaluate(inum,itotal,iid){
			for (var i=0;i<itotal;i++){
					divFrm = document.getElementById("evaldiv" + i);
					if (i==inum&&EvalShowingID!=inum){
							EvalShowingID=i;
							startAjaxCatePrd(divFrm.id,iid);
							divFrm.style.display='block';
					} else if(i==inum&&EvalShowingID==inum){
							EvalShowingID='';
							divFrm.innerHTML ='';
							divFrm.style.display='none';
					} else {
							divFrm.innerHTML ='';
							divFrm.style.display='none';
					}
			}
	}

	//상품 문의 펼치기 & 접기
	function ShowHideQna(inum,itotal){

			for (var i=0;i<itotal;i++){
					divFrm = document.getElementById('Qnablock' + i);

					if (inum==i ) {
							if (divFrm.style.display=="block"){
									divFrm.style.display="none";
							}	else 	{
									divFrm.style.display="block";
							}
				  	}	else {
						divFrm.style.display="none";
					}
			}
	}

	// 상품 문의 삭제
	function delItemQna(iid){
		if(confirm("상품문의를 삭제 하시겠습니까?")){
			qnaform.id.value = iid;
			qnaform.mode.value = "del";
			qnaform.submit();
		}
	}

	// 추가 이미지 변경
	function TnSwitchImageBG(imagesrc){
		$("#IimageMain").attr('src',imagesrc);
	}

	// 쿠폰 받기
	function jsDownCoupon(stype,idx){
		if (islogin()=="False"){
			alert("로그인을 하셔야 쿠폰을 다운받으실수 있습니다.");
			return;
		 }
	
		if(confirm('쿠폰을 받으시겠습니까?'))
		{
			var frm;
			frm = document.frmC;
			frm.stype.value = stype;
			frm.idx.value = idx;	
			frm.submit();
		}
	}

	
	// 쿠폰 받기
	function jsDownCouponShoppingbag(stype,idx,v){
		if (islogin()=="False"){
			alert("로그인을 하셔야 쿠폰을 다운받으실수 있습니다.");
			return;
		 }
	
		if(confirm('쿠폰을 받으시겠습니까?'))
		{
			var frm;
			frm = document.frmC;
			frm.stype.value = stype;
			frm.idx.value = idx;	
			frm.reval.value = v;
			frm.submit();
		}
	}

	///////////////////////////////////////////////////////
	// 검색
	///////////////////////////////////////////////////////
	function delMyKeyword(kwd) {
		//내 검색어 선택 삭제
		$.ajax({
			url: "act_mySearchKeyword.asp?mode=del&kwd="+kwd,
			cache: false,
			async: false,
			success: function(message) {
				if(message!="") {
					$("#lyrMyKeyword").empty().html(message);	
				} else {
					$("#lyrMyKeyword").empty();
				}
			}
			,error: function(err) {
				alert(err.responseText);
			}
		});
	}

	//이중 옵션 인경우 필요
	function CheckMultiOption(comp){
		var frm = comp.form;
		var compid = comp.id;
		var compvalue = comp.value;
		var compname  = comp.name;

		//var optSelObj = eval(frm.name + "." + compname);
		var optSelObj = $(".itemoption select[name='" + compname + "']");

		var PreSelObj = null;
		var NextSelObj = null;
		var ReDrawObj = null;

		if (!optSelObj.length){
			return;
		}

		if ((compid==0)&&(optSelObj.length>1)) {
			NextSelObj = optSelObj[1];
			if (optSelObj.length>2) {
				ReDrawObj = optSelObj[2];
			}else{
				ReDrawObj = optSelObj[1];
			}
		}

		if ((compid==1)&&(optSelObj.length>2)) {
			PreSelObj  = optSelObj[0];
			NextSelObj = optSelObj[2];
			ReDrawObj = optSelObj[2];
		}

		if (compid==2) {
			PreSelObj  = optSelObj[1];
		}

		if ((PreSelObj!=null)&&(PreSelObj.value.length<1)){
			alert('상위 옵션을 먼저 선택 하세요.');
			comp.value = '';
			setTimeout(function(){
				$('#'+compid+' option:selected').prop('selected', false);
			}, 0);
			PreSelObj.focus();
			return;
		}
		
		function getRequest(param){
			if(param = (new RegExp('[?&]'+encodeURIComponent(param.toLowerCase()))+'=([^&]*)').exec(location.href.toLowerCase())){
				return decodeURIComponent(param[1])
			}else{
				return "";
			}
		}

		// 최 하위만 품절 세팅
		var found = false;
		var issoldout = false;
		var itemId = getRequest('itemid');

		if ( (compvalue.length>0) && (( (ReDrawObj!=null)&&(optSelObj.length-compid==2) )||( (ReDrawObj!=null)&&(optSelObj.length-compid==3)&&(NextSelObj.value.length>0) ))) {
			for (var i=0; i<NextSelObj.length; i++){
				if (NextSelObj.options[i].value.length<1) continue;

				found = false;
				issoldout = false;
				for (var j=0;j<Mopt_Code.length;j++){
					// Box2Ea, Select1-Change
					if ((compid==0)&&(optSelObj.length==2)){
						if (Mopt_Code[j].substr(1,1)==compvalue.substr(1,1)&&(Mopt_Code[j].substr(2,1)==ReDrawObj.options[i].value.substr(1,1))){
							found = true;
							ReDrawObj.options[i].style.color= "#888888";
							break;
						}
					}

					// Box3Ea, Select2-Change
					else if ((compid==1)&&(optSelObj.length==3)) {
						if ((Mopt_Code[j].substr(1,1)==PreSelObj.value.substr(1,1))&&(Mopt_Code[j].substr(2,1)==comp.value.substr(1,1))&&(Mopt_Code[j].substr(3,1)==ReDrawObj.options[i].value.substr(1,1))){
							found = true;
							ReDrawObj.options[i].style.color= "#888888";
							break;
						}
					}

					// Box3Ea, Select2 Value Exists, Select1-Change
					else if ((compid==0)&&(optSelObj.length==3)&&(NextSelObj.value.length>0)){
						if ((Mopt_Code[j].substr(1,1)==compvalue.substr(1,1))&&(Mopt_Code[j].substr(2,1)==NextSelObj.value.substr(1,1))&&(Mopt_Code[j].substr(3,1)==ReDrawObj.options[i].value.substr(1,1))){
							found = true;
							ReDrawObj.options[i].style.color= "#888888";
							break;
						}
					}
				}


				if (!found){
					ReDrawObj.options[i].className = "soldout reIn";
					ReDrawObj.options[i].text = "<div class='option'  onclick=\"alert('품절된 옵션은 선택하실 수 없습니다.');return false;\">"+ReDrawObj.options[i].value.substr(2,255) + " (품절)</div>"+ GetItemResaleNoticeButton( itemId,  true);
					ReDrawObj.options[i].id = "S";
					ReDrawObj.options[i].style.color= "#DD8888";
				}else{
					if (Mopt_S[j]==true){
						ReDrawObj.options[i].className = "soldout reIn";
						ReDrawObj.options[i].text = "<div class='option' onclick=\"alert('품절된 옵션은 선택하실 수 없습니다.');return false;\">" + ReDrawObj.options[i].value.substr(2,255) + " (품절)</div>"+GetItemResaleNoticeButton( itemId,  true);
						ReDrawObj.options[i].id = "S";
						ReDrawObj.options[i].style.color= "#DD8888";
					}else{
						if ( Mopt_LimitEa[j].length>0){
							ReDrawObj.options[i].text = ReDrawObj.options[i].value.substr(2,255) + " (한정 " + Mopt_LimitEa[j] + " 개)";
						}else{
							ReDrawObj.options[i].text = ReDrawObj.options[i].value.substr(2,255);
						}
						ReDrawObj.options[i].style.color= "#888888";
						ReDrawObj.options[i].id = "";
					}
				}
				
				if (!found){
					ReDrawObj.getElementsByTagName("li")[i].className = "soldout reIn";
					ReDrawObj.getElementsByTagName("li")[i].innerHTML = "<div class='option'  onclick=\"alert('품절된 옵션은 선택하실 수 없습니다.');return false;\">" + ReDrawObj.getElementsByTagName("li")[i].getAttribute("value2").substr(2,255) + " (품절)</div>"+ GetItemResaleNoticeButton( itemId,  true);
					ReDrawObj.getElementsByTagName("li")[i].id = "S";
				}else{
					if (Mopt_S[j]==true){
						ReDrawObj.getElementsByTagName("li")[i].className = "soldout reIn";
						ReDrawObj.getElementsByTagName("li")[i].innerHTML = "<div class='option'  onclick=\"alert('품절된 옵션은 선택하실 수 없습니다.');return false;\">" + ReDrawObj.getElementsByTagName("li")[i].getAttribute("value2").substr(2,255) + " (품절)</div>"+GetItemResaleNoticeButton( itemId,  true);
						ReDrawObj.getElementsByTagName("li")[i].id = "S";
					}else{
						if ( Mopt_LimitEa[j].length>0){
							ReDrawObj.getElementsByTagName("li")[i].className = "";
							ReDrawObj.getElementsByTagName("li")[i].innerHTML = "<div class='option'>" + ReDrawObj.getElementsByTagName("li")[i].getAttribute("value2").substr(2,255) + " (한정 " + Mopt_LimitEa[j] + " 개)</div>";
						}else{
							ReDrawObj.getElementsByTagName("li")[i].className = "";
							ReDrawObj.getElementsByTagName("li")[i].innerHTML = "<div class='option'>" + ReDrawObj.getElementsByTagName("li")[i].getAttribute("value2").substr(2,255);
						}
						ReDrawObj.getElementsByTagName("li")[i].id = "";
					}
				}
			}
		}
	}

	function GetItemResaleNoticeButton( itemId,  isSoldOut){
		//var chkapp = document.location.href.toLowerCase().indexOf('apps/appcom');
		var chkapp = navigator.userAgent.match("tenapp");
		//console.log(chkapp);
		if (isSoldOut){
			if (islogin() !== "False"){
				if(chkapp)
					return "<button type='button' class='btnV16a btn-line-blue' onclick=fnAPPpopupBrowserURL('입고알림신청','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/pop_stock.asp?itemid="+itemId+"');return false;>입고알림</button>";
				else
					return "<button type='button' class='btnV16a btn-line-blue' onclick=fnOpenModal('/category/pop_stock.asp?itemid="+itemId+"');return false;>입고알림</button>";
					
			}else{
				return "<button type='button' class='btnV16a btn-line-blue' onclick=\"alert('로그인 후 재입고 알림 신청이 가능합니다.');location.href='/login/login.asp?backpath="+escape(document.location.href.substring(document.location.href.indexOf('.kr')+3))+"';\">입고알림</button>";
			}
			
		}else{
			return "";
		}
	}

	//이중 옵션 품절 체크 - 2017 신버전
	function CheckMultiOption2017(comp){
		var compid = comp;
		var compvalue;

		var $item_opt = $('#opttag input[name="item_option"]'); //옵션
		var optlength = $item_opt.length; 

		//옵션값 넣기
		$item_opt.each(function(index){
			if (compid+optlength == $(this).index()){
				//값을 집어 넣는다
				compvalue = $(this).val();
			}
		});

		var optSelObj = $(".dropBox ul");

		var PreSelObj = null;
		var NextSelObj = null;
		var ReDrawObj = null;

		var PrevalObj = null;
		var NextvalObj = null;
		var ReDrawvalObj = null;

		if (!optSelObj.length){
			return;
		}

		if ((compid==0)&&(optSelObj.length>1)) {
			NextSelObj = optSelObj[1]; //a-tag
			NextvalObj = $item_opt[1]; //input
			if (optSelObj.length>2) {
				ReDrawObj = optSelObj[2];
				ReDrawvalObj = $item_opt[2];
			}else{
				ReDrawObj = optSelObj[1];
				ReDrawvalObj = $item_opt[1];
			}
		}

		if ((compid==1)&&(optSelObj.length>1)) {
			PreSelObj  = optSelObj[0];
			NextSelObj = optSelObj[2];
			ReDrawObj = optSelObj[2];
			
			PrevalObj	= $item_opt[0];
			NextvalObj	= $item_opt[2];
			ReDrawvalObj= $item_opt[2];
		}

		if (compid==2) {
			PreSelObj  = optSelObj[1];
			PrevalObj  = $item_opt[1];
		}

		// 최 하위만 품절 세팅
		var found = false;
		var issoldout = false;

		//
		if ( (compvalue.length>0) && (( (ReDrawObj!=null)&&(optSelObj.length-compid==2) )||( (ReDrawObj!=null)&&(optSelObj.length-compid==3) &&(NextvalObj.getAttribute("value").length>0) ))) {
			for (var i=0; i<NextSelObj.getElementsByTagName("li").length; i++){
				if (NextSelObj.getElementsByTagName("li")[i].getAttribute("value2").length<1) continue;

				found = false;
				issoldout = false;
				for (var j=0;j<Mopt_Code.length;j++){
					// Box2Ea, Select1-Change
					if ((compid==0)&&(optSelObj.length==2)){
						if (Mopt_Code[j].substr(1,1)==compvalue.substr(1,1)&&(Mopt_Code[j].substr(2,1)==ReDrawObj.getElementsByTagName("li")[i].getAttribute("value2").substr(1,1))){
							found = true;
							break;
						}
					}

					// Box3Ea, Select2-Change
					else if ((compid==1)&&(optSelObj.length==3)) {
						if ((Mopt_Code[j].substr(1,1)==PrevalObj.getAttribute("value").substr(1,1))&&(Mopt_Code[j].substr(2,1)==compvalue.substr(1,1))&&(Mopt_Code[j].substr(3,1)==ReDrawObj.getElementsByTagName("li")[i].getAttribute("value2").substr(1,1))){
							found = true;
							break;
						}
					}

					// Box3Ea, Select2 Value Exists, Select1-Change
					else if ((compid==0)&&(optSelObj.length==3)&&(NextvalObj.getAttribute("value").length>0)){
						if ((Mopt_Code[j].substr(1,1)==compvalue.substr(1,1))&&(Mopt_Code[j].substr(2,1)==NextvalObj.getAttribute("value").substr(1,1))&&(Mopt_Code[j].substr(3,1)==ReDrawObj.getElementsByTagName("li")[i].getAttribute("value2").substr(1,1))){
							found = true;
							break;
						}
					}
				}

				var itemId = getParameteritems('itemid');
				if (!found){
					ReDrawObj.getElementsByTagName("li")[i].className = "soldout reIn";
					ReDrawObj.getElementsByTagName("li")[i].innerHTML = "<div class='option' onclick=\"alert('품절된 옵션은 선택하실 수 없습니다.');return false;\">" + ReDrawObj.getElementsByTagName("li")[i].getAttribute("value2").substr(2,255) + " (품절)</div>"+ GetItemResaleNoticeButton( itemId,  true);
					ReDrawObj.getElementsByTagName("li")[i].id = "S";
				}else{
					if (Mopt_S[j]==true){
						ReDrawObj.getElementsByTagName("li")[i].className = "soldout reIn";
						ReDrawObj.getElementsByTagName("li")[i].innerHTML = "<div class='option' onclick=\"alert('품절된 옵션은 선택하실 수 없습니다.');return false;\">" + ReDrawObj.getElementsByTagName("li")[i].getAttribute("value2").substr(2,255) + " (품절)</div>"+GetItemResaleNoticeButton( itemId,  true);
						ReDrawObj.getElementsByTagName("li")[i].id = "S";
					}else{
						if ( Mopt_LimitEa[j].length>0){
							ReDrawObj.getElementsByTagName("li")[i].className = "";
							ReDrawObj.getElementsByTagName("li")[i].innerHTML = "<div class='option'>" + ReDrawObj.getElementsByTagName("li")[i].getAttribute("value2").substr(2,255) + " (한정 " + Mopt_LimitEa[j] + " 개)</div>";
						}else{
							ReDrawObj.getElementsByTagName("li")[i].className = "";
							ReDrawObj.getElementsByTagName("li")[i].innerHTML = "<div class='option'>" + ReDrawObj.getElementsByTagName("li")[i].getAttribute("value2").substr(2,255);
						}
						ReDrawObj.getElementsByTagName("li")[i].id = "";
					}
				}
			}
		}
	}

	var getParameteritems = function(name){
		name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
		var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
	    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
	}

	function plusComma(num){
    	if (num < 0) { num *= -1; var minus = true}
    	else var minus = false

    	var dotPos = (num+"").split(".")
    	var dotU = dotPos[0]
    	var dotD = dotPos[1]
    	var commaFlag = dotU.length%3

    	if(commaFlag) {
    		var out = dotU.substring(0, commaFlag)
    		if (dotU.length > 3) out += ","
    	}
    	else var out = ""

    	for (var i=commaFlag; i < dotU.length; i+=3) {
    		out += dotU.substring(i, i+3)
    		if( i < dotU.length-3) out += ","
    	}

    	if(minus) out = "-" + out
    	if(dotD) return out + "." + dotD
    	else return out
    }