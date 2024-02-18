	<script>
	var ChkErrMsg;
	var Totalitemcount = <%= oshoppingbag.FShoppingBagItemCount %>;

	function DelItem(idx){
		var frm = document.baguniFrm;
		var reloadfrm = document.reloadFrm;

		if (!frm.itemkey.length){
			reloadfrm.mode.value    = "edit";
			reloadfrm.itemid.value	= frm.itemid.value;
			reloadfrm.itemoption.value = frm.itemoption.value;
			reloadfrm.itemea.value = 0;
		}else{
			reloadfrm.mode.value = "edit";
			reloadfrm.itemid.value	= frm.itemid[idx].value;
			reloadfrm.itemoption.value = frm.itemoption[idx].value;
			reloadfrm.itemea.value = 0;
		}

		if (confirm('상품을 장바구니에서 삭제 하시겠습니까?')){
			document.reloadFrm.submit();
		}
	}

	function EditItem(idx){

		var frm = document.baguniFrm;
		var reloadfrm = document.reloadFrm;
		var itemeacomp;
		var maxnoflag;
		var minnoflag;
		var soldoutflag;

		if (!frm.itemkey.length){
			reloadfrm.mode.value        = "edit";
			reloadfrm.itemid.value	    = frm.itemid.value;
			reloadfrm.itemoption.value  = frm.itemoption.value;
			reloadfrm.itemea.value      = frm.itemea.value;

			itemeacomp = frm.itemea;
			maxnoflag = frm.maxnoflag;
			minnoflag = frm.minnoflag;
			soldoutflag = frm.soldoutflag;
		}else{
			reloadfrm.mode.value        = "edit";
			reloadfrm.itemid.value	    = frm.itemid[idx].value;
			reloadfrm.itemoption.value  = frm.itemoption[idx].value;
			reloadfrm.itemea.value      = frm.itemea[idx].value;

			itemeacomp          = frm.itemea[idx];
			maxnoflag    = frm.maxnoflag[idx];
			minnoflag    = frm.minnoflag[idx];
			soldoutflag         = frm.soldoutflag[idx];
		}

		if (!IsDigit(itemeacomp.value)||(itemeacomp.value.length<1) ) {
		   alert("구매수량은 숫자로 넣으셔야 됩니다.");
		   itemeacomp.focus();
		   return;
		}

		//최대구매수량 체크
		if (itemeacomp.value*1>maxnoflag.value*1){
			alert('한정수량 또는 최대 구매수량 (' + maxnoflag.value + ')개를 초과하여 주문 하실 수 없습니다.');
			itemeacomp.focus();
			return;
		}
        //최소구매수량 체크
    	if (itemeacomp.value*1<minnoflag.value*1){
    		alert('최소 구매수량 (' + minnoflag.value + ')개를 이상 주문 하실 수 있습니다..');
    		itemeacomp.focus();
    		return;
    	}

		if (itemeacomp.value == "0"){
			if (confirm('상품을 장바구니에서 삭제 하시겠습니까?')){
				document.reloadFrm.submit();
			}
		}

		document.reloadFrm.submit();
	}

	function EditRequireDetail(iitemid,iitemoption){
		//var popwin = window.open('/apps/appCom/between/inipay/Pop_EditItemRequire.asp?itemid=' + iitemid + '&itemoption=' + iitemoption,'edititemrequire','width=300,height=300,scrollbars=yes,resizable=yes');
		//popwin.focus();
	}

	function PopMileageItemView(iitemid){
		var popwin = window.open('/apps/appCom/between/my10x10/Pop_mileageshop_itemview.asp?itemid=' + iitemid,'Pop_mileageshop_itemview','width=464,height=600,scrollbars=yes,resizable=yes');
		popwin.focus();
	}


	//마일리지샵 상품 추가
	function AddMileItem(iitemid,iitemoption,iitemea){
		var frm = document.reloadFrm;

		frm.mode.value      = "add";
		frm.itemid.value    =iitemid;
		frm.itemoption.value =iitemoption;
		frm.itemea.value    =iitemea;
		frm.submit();
	}

	function AddMileItem2(iitemid){
		var mfrm = document.mileForm;
		var frm = document.reloadFrm;
		var iitemoption="0000";
		//옵션 선택 추가..

		if (eval("mileForm.item_option_"+iitemid)){
			var comp = eval("mileForm.item_option_"+iitemid);
			if (comp[comp.selectedIndex].id == "S") { alert("품절된 옵션은 구매하실 수 없습니다."); return; }

			iitemoption=comp[comp.selectedIndex].value;

			if (iitemoption==""){
				alert('옵션을 선택 하세요.');
				comp.focus();
				return;
			}
		}

		frm.mode.value      = "add";
		frm.itemid.value    =iitemid;
		frm.itemoption.value=iitemoption;
		frm.itemea.value    ="1";
		frm.submit();
	}

	function GoShopping(){
		location.href="<%= LastShoppingUrl %>";
	}

	function PayNextSelected(jumundiv){
		var frm = document.baguniFrm;
		var nextfrm = document.NextFrm;
		var chkExists = false;
		var mitemExists = false;
		var oitemExists = false;
		var nitemExists = false;
		var d1typExists = false;
		var d2typExists = false;
		var d3typExists = false;
		var titemCount = 0;        //Ticket
		var rstemCount = 0;        //현장수령상품
		var pitemCount = 0;        //Present상품
		var mitemttl = 0;

		if (frm.chk_item){
			if (frm.chk_item.length){
				for(var i=0;i<frm.chk_item.length;i++){
					if (frm.chk_item[i].checked){
						chkExists = true;
						if (frm.mtypflag[i].value=="m"){
							mitemExists = true;
							mitemttl+=frm.isellprc[i].value*1;
						}else if(frm.mtypflag[i].value=="o"){
							oitemExists = true;
						}else if(frm.mtypflag[i].value=="t"){
							titemCount = titemCount+1;
						}else if(frm.mtypflag[i].value=="r"){
							rstemCount = rstemCount+1;
						}else if(frm.mtypflag[i].value=="p"){
							pitemCount = pitemCount+1;
						}else{
							nitemExists = true;
						}

						if ((frm.dtypflag[i].value=="1")&&(frm.mtypflag[i].value!="m")){
							d1typExists = true;
						}else if(frm.dtypflag[i].value=="2"){
							d2typExists = true;
						}else{
							d3typExists = true;
						}

						if (frm.soldoutflag[i].value == "Y"){
							alert('품절된 상품은 구매하실 수 없습니다.');
							frm.itemea[i].focus();
							return;
						}

						if (frm.nophothofileflag[i].value=="1"){
							alert('포토북 상품은 편집후 구매 가능합니다.');
							frm.itemea[i].focus();
							return;
						}

						if (frm.chkolditemea[i].value*1!=frm.itemea[i].value*1){
							alert('수량 조절후 수정 버튼을 누르셔야 저장됩니다.');
							frm.itemea[i].focus();
							return;
						}

						if (frm.chkolditemea[i].value*1>frm.maxnoflag[i].value*1){
							alert('한정수량 또는 최대 구매수량 (' + frm.maxnoflag[i].value + ')개를 초과하여 주문 하실 수 없습니다.');
							frm.itemea[i].focus();
							return;
						}
                        if (frm.chkolditemea[i].value*1<frm.minnoflag[i].value*1){
            				alert('최소 구매수량 (' + frm.minnoflag[i].value + ')개 이상 주문 하실 수 있습니다.');
            				frm.itemea[i].focus();
            				return;
            			}

						if ((jumundiv==2)&&(frm.foreignflag[i].value!='Y')){
							alert('해외 배송이 불가능한 상품이 포함 되어있습니다.');
							if (frm.itemea[i].type=='text'){
								frm.itemea[i].focus();
							}
							return;
						}

						if ((jumundiv==3)&&(frm.dtypflag[i].value!='1')){
							alert('군부대 배송이 불가능한 상품이 포함 되어있습니다.\n\n군부대 배송은 텐바이텐 배송상품만 가능합니다.');
							if (frm.itemea[i].type=='text'){
								frm.itemea[i].focus();
							}
							return;
						}

					}
				}
			}else{
				if (frm.chk_item.checked){
					chkExists = true;
					if (frm.mtypflag.value=="m"){
						mitemExists = true;
						mitemttl+=frm.isellprc.value*1;
					}

					if (frm.soldoutflag.value == "Y"){
						alert('품절된 상품은 구매하실 수 없습니다.');
						frm.itemea.focus();
						return;
					}

					if (frm.nophothofileflag.value=="1"){
						alert('포토북 상품은 편집후 구매 가능합니다.');
						frm.itemea.focus();
						return;
					}

					if (frm.chkolditemea.value*1!=frm.itemea.value*1){
						alert('수량 조절후 수정 버튼을 누르셔야 저장됩니다.');
						frm.itemea.focus();
						return;
					}

					if (frm.chkolditemea.value*1>frm.maxnoflag.value*1){
						alert('한정수량 또는 최대 구매수량 (' + frm.maxnoflag.value + ')개를 초과하여 주문 하실 수 없습니다.');
						frm.itemea.focus();
						return;
					}
                    if (frm.chkolditemea.value*1<frm.minnoflag.value*1){
            			alert('최소 구매수량 (' + frm.minnoflag.value + ')개 이상 주문 하실 수 있습니다.');
            			frm.itemea.focus();
            			return;
            		}

					if ((jumundiv==2)&&(frm.foreignflag.value!='Y')){
						alert('해외 배송이 불가능한 상품이 포함 되어있습니다.');
						if (frm.itemea.type=='text'){
							frm.itemea.focus();
						}
						return;
					}

					if ((jumundiv==3)&&(frm.dtypflag.value!='1')){
						alert('군부대 배송이 불가능한 상품이 포함 되어있습니다.');
						if (frm.itemea.type=='text'){
							frm.itemea.focus();
						}
						return;
					}
				}
			}
		}

		if (!chkExists){
			alert('선택된 상품이 없습니다. 주문 하실 상품을 선택후 진행해 주세요.');
			return;
		}

		if ((mitemExists)&&(!d1typExists)){
			alert('마일리지샾 상품은 텐바이텐 배송상품과 함께 하셔야 배송 가능 합니다.');
			return;
		}

		if ((oitemExists)&&(nitemExists)){
			alert('단독구매 상품과 및 예약판매 일반상품은 같이 구매하실 수 없습니다.\n\n단독구매 및 예약판매 상품은 별도로 장바구니에 담아주세요.');
			return;
		}

		if ((titemCount>0)&&(nitemExists)){
			alert('티켓 단독 상품과 일반상품은 같이 구매하실 수 없습니다.\n\티켓 단독 상품은 별도로 장바구니에 담아주세요.');
			return;
		}

		if (titemCount>1){
			alert('티켓 단독 상품은 개별상품으로만 주문 가능합니다.\n\티켓 단독 상품은 별도로 장바구니에 담아주세요.');
			return;
		}

		if ((rstemCount>0)&&(nitemExists)){
			alert('현장수령 상품과 일반상품은 같이 구매하실 수 없습니다.\n\현장수령 상품은 별도로 장바구니에 담아주세요.');
			return;
		}

		if ((pitemCount>0)&&(nitemExists)){
			alert('Present상품과 일반상품은 같이 구매하실 수 없습니다.\n\Present상품은 별도로 장바구니에 담아주세요.');
			return;
		}

		if (pitemCount>1){
			alert('Present 상품은 개별상품으로만 주문 가능합니다.\n\Present상품은 한번에 한 상품씩 구매 가능합니다.');
			return;
		}

		var currmileage = <%= availtotalMile %>;
		nextfrm.mileshopitemprice.value = mitemttl;

		if (nextfrm.mileshopitemprice.value*1>currmileage*1){
			alert('사용하실 수 있는 마일리지는 ' + currmileage + 'point 입니다. - 마일리지 상품 합계가 현재 마일리지보다 많습니다.');
			return;
		}

		frm.mode.value = "OCK";
		frm.jumundiv.value = jumundiv;
		frm.submit();

		//document.NextFrm.jumundiv.value=jumundiv;
		//document.NextFrm.submit();
	}

	function PayNext(frm, jumundiv, iErrMsg){
		var nextfrm = document.NextFrm;

		if (iErrMsg){
			alert(iErrMsg);
			return;
		}

		if (Totalitemcount==1){
			if (frm.soldoutflag.value == "Y"){
				alert('품절된 상품은 구매하실 수 없습니다.');
				frm.itemea.focus();
				return;
			}

			if (frm.chkolditemea.value*1!=frm.itemea.value*1){
				alert('수량 조절후 수정 버튼을 누르셔야 저장됩니다.');
				frm.itemea.focus();
				return;
			}

			if (frm.chkolditemea.value*1>frm.maxnoflag.value*1){
				alert('한정수량 또는 최대 구매수량 (' + frm.maxnoflag.value + ')개를 초과하여 주문 하실 수 없습니다.');
				frm.itemea.focus();
				return;
			}
            if (frm.chkolditemea.value*1<frm.minnoflag.value*1){
    			alert('최소 구매수량 (' + frm.minnoflag.value + ')개 이상 주문하실 수 있습니다.');
    			frm.itemea.focus();
    			return;
    		}

			if ((jumundiv==2)&&(frm.foreignflag.value!='Y')){
				alert('해외 배송이 불가능한 상품이 포함 되어있습니다.');
				if (frm.itemea.type=='text'){
					frm.itemea.focus();
				}
				return;
			}

		}else{
			for (i=0;i<Totalitemcount;i++){
				if (frm.soldoutflag[i].value == "Y"){
					alert('품절된 상품은 구매하실 수 없습니다.');
					frm.itemea[i].focus();
					return;
				}

				if (frm.chkolditemea[i].value*1!=frm.itemea[i].value*1){
					alert('수량 조절후 수정 버튼을 누르셔야 저장됩니다.');
					frm.itemea[i].focus();
					return;
				}

				if (frm.chkolditemea[i].value*1>frm.maxnoflag[i].value*1){
					alert('한정수량 또는 최대 구매수량 (' + frm.maxnoflag[i].value + ')개를 초과하여 주문 하실 수 없습니다.');
					frm.itemea[i].focus();
					return;
				}
				if (frm.chkolditemea[i].value*1<frm.minnoflag[i].value*1){
					alert('최소 구매수량 (' + frm.minnoflag[i].value + ')개 이상 주문하실 수 있습니다.');
					frm.itemea[i].focus();
					return;
				}

				if ((jumundiv==2)&&(frm.foreignflag[i].value!='Y')){
					alert('해외 배송이 불가능한 상품이 포함 되어있습니다.');
					if (frm.itemea[i].type=='text'){
						frm.itemea[i].focus();
					}
					return;
				}
			}
		}


		var currmileage = <%= availtotalMile %>;

		if (nextfrm.mileshopitemprice.value*1>currmileage*1){
			alert('사용하실 수 있는 마일리지는 ' + currmileage + 'point 입니다. - 마일리지 상품 합계가 현재 마일리지보다 많습니다.');
			return;
		}

		frm.mode.value = "ALK";
		frm.jumundiv.value = jumundiv;
		frm.submit();
		//document.NextFrm.jumundiv.value=jumundiv;
		//document.NextFrm.submit();

	}

	function TnShoppingBagForceAdd(){
		document.frmConfirm.submit();
	}

	function goSaveDvlPay(){
		location.href="/apps/appCom/between/event/eventmain.asp?eventid=14067";
	}

	function delSelected(){
		var frm = document.baguniFrm;
		var chkExists = false;

		if (frm.chk_item){
			if (frm.chk_item.length){
				for(var i=0;i<frm.chk_item.length;i++){
					if (frm.chk_item[i].checked){
						chkExists = true;
					}
				}
			}else{
				if (frm.chk_item.checked){
					chkExists = true;
				}
			}
		}

		if (!chkExists){
			alert('선택된 상품이 없습니다. 장바구니에서 삭제할 상품을 선택후 진행해 주세요.');
			return;
		}

		if (confirm('선택 상품을 장바구니에서 삭제하시겠습니까?')){
			frm.mode.value='DLARR';
			frm.submit();
		}
	}


	function DirectOrder(idx){
		var frm = document.baguniFrm;
		var reloadfrm = document.reloadFrm;

		if (!frm.itemkey.length){
			reloadfrm.mode.value    = "DO1";
			reloadfrm.itemid.value	= frm.itemid.value;
			reloadfrm.itemoption.value = frm.itemoption.value;
			reloadfrm.itemea.value = 0;

			if (frm.soldoutflag.value == "Y"){
				alert('품절된 상품은 구매하실 수 없습니다.');
				frm.itemea.focus();
				return;
			}

			if (frm.nophothofileflag.value == "1"){
				alert('포토북 상품은 편집후 구매 가능합니다.');
				frm.itemea.focus();
				return;
			}

			if (frm.chkolditemea.value*1>frm.maxnoflag.value*1){
				alert('한정수량 또는 최대 구매수량 (' + frm.maxnoflag.value + ')개를 초과하여 주문 하실 수 없습니다.');
				frm.itemea.focus();
				return;
			}
			if (frm.chkolditemea.value*1<frm.minnoflag.value*1){
				alert('최소 구매수량 (' + frm.minnoflag.value + ')개 이상 주문하실 수 있습니다.');
				frm.itemea.focus();
				return;
			}

			if (frm.chkolditemea.value*1!=frm.itemea.value*1){
				alert('수량 조절후 수정 버튼을 누르셔야 저장됩니다.');
				frm.itemea.focus();
				return;
			}

			<% if (Not IsUserLoginOK) then %>
			if (frm.mtypflag.value == "t"){
				alert('죄송합니다. 티켓 상품은 회원 구매만 가능합니다.');
				frm.itemea.focus();
				return;
			}
		    if (frm.mtypflag.value == "p"){
		        alert('죄송합니다. Present상품은 회원 구매만 가능합니다.');
				return;
		    }
			<% end if %>

		}else{
			reloadfrm.mode.value = "DO1";
			reloadfrm.itemid.value	= frm.itemid[idx].value;
			reloadfrm.itemoption.value = frm.itemoption[idx].value;
			reloadfrm.itemea.value = 0;

			if (frm.soldoutflag[idx].value == "Y"){
				alert('품절된 상품은 구매하실 수 없습니다.');
				frm.itemea[idx].focus();
				return;
			}

			if (frm.nophothofileflag[idx].value == "1"){
				alert('포토북 상품은 편집후 구매 가능합니다.');
				frm.itemea[idx].focus();
				return;
			}

			if (frm.chkolditemea[idx].value*1>frm.maxnoflag[idx].value*1){
				alert('한정수량 또는 최대 구매수량 (' + frm.maxnoflag[idx].value + ')개를 초과하여 주문 하실 수 없습니다.');
				frm.itemea[idx].focus();
				return;
			}
			if (frm.chkolditemea[idx].value*1<frm.minnoflag[idx].value*1){
				alert('최소 구매수량 (' + frm.minnoflag[idx].value + ')개 이상 주문하실 수 있습니다.');
				frm.itemea[idx].focus();
				return;
			}

			if (frm.chkolditemea[idx].value*1!=frm.itemea[idx].value*1){
				alert('수량 조절후 수정 버튼을 누르셔야 저장됩니다.');
				frm.itemea[idx].focus();
				return;
			}

			<% if (Not IsUserLoginOK) then %>
			if (frm.mtypflag[idx].value == "t"){
				alert('죄송합니다. 티켓 상품은 회원 구매만 가능합니다.');
				frm.itemea[idx].focus();
				return;
			}
		    if (frm.mtypflag[idx].value == "p"){
		        alert('죄송합니다. Present상품은 회원 구매만 가능합니다.');
				return;
		    }
			<% end if %>
		}

		document.reloadFrm.submit();
	}

	</script>
	<script>
	$(function(){
		var vSpos, vChk;
		$(window).on({
			'touchstart': function(e) {
				vSpos = $(window).scrollTop()
				vChk = false;
			}, 'touchmove': function(e) {
				if(vSpos!=$(window).scrollTop()) {
					$('.floatingBar').css('display','none');
					vChk = true;
				}
			}, 'touchend': function(e) {
				if(vChk) $('.floatingBar').fadeIn("fast");
			}
		});

	});
	</script>