$(function(){
	try{
		recoPick('fetchUID', function (uid) {
			if(uid.split(".")[0]%2==0) {
				// 기존 추천 방식 (5:5)
				//	getRecoListCheck("O",uid);
					getRecoListCheck("N",uid);
			} else {
				// RecoPick 추천
				getRecoListCheck("N",uid);
			}
		});
	} catch(e){
		// 기존 추천 방식
		// getRecoListCheck("O","");
		getRecoListCheck("N","");
	}
});
function CallHappyTogether(vChkHT,vRuid, vPrdList, vMtdList) {
	$.ajax({
		url: "act_happyTogether_complete.asp?itemid="+vIId+"&disp="+vDisp+"&chk="+vChkHT+"&ruid="+vRuid+"&prdlist="+vPrdList+"&MtdList="+vMtdList,
		cache: false,
		async: false,
		success: function(vRst) {
			if(vRst!="") {
				$("#lyrHPTgr").empty().html(vRst);
//				if($(".collection").length<=0) $("#detail06_Best").show();
				$('#lyrHPTgr .pdtPhoto').hover(function() {
					$(this).children('.pdtAction').toggle();
				});
		    }
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}

function getRecoListCheck(vCHkHT, vRuid)
{
	var vIIdValue='';
	var vMethodValue='';
	if (vCHkHT=="N")
	{
		$.getJSON("https://api.recopick.com/v1/recommendations/user/131/"+vRuid+"?limit=9&channel=recopick_c&type=realtime&callback=?",
			function(data, status)
			{
				if (status=="success")
				{
					for (it=0;it < data.length;it++)
					{
						vIIdValue += data[it].id+",";
						vMethodValue += data[it].method+",";
					}
					vIIdValue = vIIdValue.substring(0, (vIIdValue.length-1));
					vMethodValue = vMethodValue.substring(0, (vMethodValue.length-1));
					if (vIIdValue=="")
					{
						getRecoListCheckView(vCHkHT, vRuid)
						return;
					}
					else
					{
						CallHappyTogether(vCHkHT, vRuid, vIIdValue, vMethodValue);
						return;
					}
				}
				else
				{
					vIIdValue='';
				}
			}
		);
	}
	else
	{
		CallHappyTogether(vCHkHT, vRuid, '', '');
	}
}



function getRecoListCheckView(vCHkHT, vRuid)
{
	var vIIdValue='';
	var vMethodValue='';
	if (vCHkHT=="N")
	{
		$.getJSON("https://api.recopick.com/v1/recommendations/user/131/"+vRuid+"?limit=9&channel=recopick_c&type=basic&callback=?",
			function(data, status)
			{
				if (status=="success")
				{
					$.each(data, function(header, value) {
						for (it=0;it < value.length;it++)
						{
							vIIdValue += value[it].id+",";
							vMethodValue += value[it].method+",";
						}
							vIIdValue = vIIdValue.substring(0, (vIIdValue.length-1));
						vMethodValue = vMethodValue.substring(0, (vMethodValue.length-1));
					});
					CallHappyTogether(vCHkHT, vRuid, vIIdValue, vMethodValue);
				}
				else
				{
					vIIdValue='';
				}
			}
		);
	}
	else
	{
		CallHappyTogether(vCHkHT, vRuid, '', '');
	}
}


function FnGoProdItem(vi,oi,mt,dv,uid,lnk,chn){
	//if(dv=="T") {
	//	location.href = "/shopping/category_prd.asp?itemid="+vi;
	//} else {
		if(lnk!="") {
			location.href = lnk;
			//alert(lnk);
		} else {
			//location.href = "https://api.recopick.com/1/banner/131/pick?source=" + oi + "&pick=" + vi + "&method=" + mt + "&url=" + encodeURIComponent("http://www.10x10.co.kr/shopping/category_prd.asp?itemid="+vi+"&channel="+chn) +"&reco_type=item-item";
			location.href = "https://api.recopick.com/1/banner/131/pick?source=" + oi + "&pick=" + vi + "&uid=" + uid + "&method=" + mt + "&channel=recopick_c&reco_type=item-item";
			//alert("https://api.recopick.com/1/banner/131/pick?source=" + oi + "&pick=" + vi + "&uid=" + uid + "&method=" + mt + "&channel="+ chn +"&reco_type=item-item");
		}
	//}
}

