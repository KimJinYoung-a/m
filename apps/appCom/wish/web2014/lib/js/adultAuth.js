function confirmAdultAuth(cPath, isLogedIn){		
    var url = 'http://m.10x10.co.kr/login/login_adult.asp?backpath='+ cPath;    
    var goAdultAuth = function(){			
        location.href = url;
    };		
    if(confirm('이 상품은 성인 인증이 필요한 상품입니다. 성인 확인을 위해 성인 인증을 진행합니다.')){
        if(!isLogedIn){
            url = btoa(url);				
             callNativeFunction('popupLogin', {
                "openType": OpenType.FROM_BOTTOM,
                "ltbs": [],
                "title": "로그인",
                "rtbs": [],
                "backpath": url
             });
        }else{
            goAdultAuth();
        }
    }
}
function getParameterByName(name, url) {		
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);			
    return Array.isArray(results) ? results[2] : "" ;
}	

function chkAdultCbPage(){    
    var currentUrl = location.href
    console.log(currentUrl)
    var adultPdtId = getParameterByName("adtpdtid", currentUrl)    
    // alert(currentUrl);	            
    if(adultPdtId){			                    
        $(document).ready(function(){              
            setTimeout(function(){                
                fnAPPpopupProduct(adultPdtId);
            }, 1)            
        })
    }		
}
chkAdultCbPage();