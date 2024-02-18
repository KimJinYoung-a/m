/*
- 2017 서울 가요 대상 파라메터 처리
- 생성 : 2017.12.07 허진원
- 세션 스토리지에 해당 파라메터를 저장 및 취합

	// 값 받기
	var oRst = getSMAParam();
	if(typeof(oRst)=="object") {
		// 처리
	}
*/

// 객체 생성
var SMAParam = new function() {

	// 넘어온 파라메터 저장 (in category_itemPrd.asp)
	this.setParam = function() {
		var urlParam = this.getUrlParams();

		if(typeof(Storage) !== "undefined") {
			if(typeof(urlParam.transactionId) !== "undefined") {
				var oParam = new Array;	// 배열 선언

				// 저장된 내용에서 중복값 정리
				this.delParam(urlParam.itemid);

				// 저장값 확인
				var smaPrm = this.getParam();
				if(smaPrm) {
					oParam = smaPrm;
				}

				//파라메터 추가
				var oPm = new Object;
				oPm.transactionId = urlParam.transactionId;
				oPm.mediaCode = urlParam.mediaCode;
				oPm.adCode = urlParam.adCode;
				oPm.gadid = urlParam.gadid;
				oPm.itemid = urlParam.itemid;

				oParam.push(oPm); //결과 추가
				
				// 세션저장소에 저장
				sessionStorage.setItem("SMAInfo",JSON.stringify(oParam));
			}
		}
	},

	// 저장된 파라메터 반환
	this.getParam = function() {
		if(typeof(Storage) !== "undefined") {
			if(sessionStorage.getItem("SMAInfo")) {
				var oParam = JSON.parse(sessionStorage.getItem("SMAInfo"));
				return oParam;
			}
		}
	},

	// 저장된 파라메터 삭제
	this.delParam = function(iid) {
		if(typeof(Storage) !== "undefined") {
			// 저장된 내용이 있는지 확인
			var smaPrm = this.getParam();
			if(smaPrm) {
				//저장된 내용이 있으면 초기화
				if(smaPrm.length>0) {
					for(var i in smaPrm) {
						var oPm = smaPrm[i];
						// 상품코드로 매칭
						if(oPm.itemid==iid) {
							smaPrm.splice(i,1);
						}
					}

					if(smaPrm.length==0) {
						//삭제
						sessionStorage.removeItem("SMAInfo");					
					} else {
						// 정리값 저장
						sessionStorage.setItem("SMAInfo",JSON.stringify(smaPrm));
					}
				}
			}
		}
	},

	// 주문완료에서 처리 (in displayOrder.asp)
	this.saveParam = function(ordsn,ordItm) {
		// 저장된 파라메터 접수
		var smaPrm = this.getParam();

		if(smaPrm) {
			if(smaPrm.length>0) {
				for(var i in smaPrm) {
					var oPm = smaPrm[i];

					// 주문중 행사상품 수량 접수
					var itmNo = 0, iid="";
					if(ordItm.length){
						for(var i in ordItm) {
							if(ordItm[i].itemid==oPm.itemid) {
								itmNo += ordItm[i].itemno;
								iid = ordItm[i].itemid;

								// 주문번호 추가
								oPm.orderserial=ordsn;
								oPm.numOfItem=itmNo;
							}
	                    }

						// DB에 저장
						$.ajax({
							type: "post",
							url: "/event/etc/focusm/act_saveorderparam.asp",
							data: $.param(oPm),
							success: function(message) {
								SMAParam.delParam(iid);
							},
							error: function(err) {
								console.log(err.responseText);
							}
						});
					}

				}
			}
		}
	},

	// url parameter parsing
	this.getUrlParams = function() {
	    var params = {};
	    window.location.search.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(str, key, value) { params[key] = value; });
	    return params;
	}

}