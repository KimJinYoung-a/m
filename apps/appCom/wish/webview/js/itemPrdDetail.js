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
			calllogin();
			//alert("로그인을 하셔야 쿠폰을 다운받으실수 있습니다.");
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
			calllogin();
			//alert("로그인을 하셔야 쿠폰을 다운받으실수 있습니다.");
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
			PreSelObj.focus();
			return;
		}

		// 최 하위만 품절 세팅
		var found = false;
		var issoldout = false;


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
					ReDrawObj.options[i].text = ReDrawObj.options[i].value.substr(2,255) + " (품절)";
					ReDrawObj.options[i].id = "S";
					ReDrawObj.options[i].style.color= "#DD8888";
				}else{
					if (Mopt_S[j]==true){
						ReDrawObj.options[i].text = ReDrawObj.options[i].value.substr(2,255) + " (품절)";
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
			}
		}
	}