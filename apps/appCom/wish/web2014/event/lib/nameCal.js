let name1, name2;
var _name1arr = [];
var _name2arr = [];

function btnClick() {
    var tempname1, tempname2
    tempname1 = $("#name1").val().replace(/ /g,'');
    tempname2 = document.getElementById("name2").value;

    var name = $("#name1").val();
    var re = /^[가-힣]{2,3}$/;
 	if (name == '' || !re.test(name)) {
		alert("올바른 이름의 형식을 입력하세요");
		return false;
	}

    if(GetByteLength($("#name1").val()) < 3){
        alert("이름은 2~3글자만 입력해주세요.");
        return false;
    }
    else if(GetByteLength($("#name1").val()) > 6){
        alert("이름은 2~3글자만 입력해주세요.");
        return false;
    }

    if($("#tPoint").val() != ""){
        alert("오늘은 이미 이벤트 참여가 완료되었어요! 내일 또 참여해 주세요! :)");
        return false;
    }

    //길이 체크 후 변수 선언(긴 이름 앞으로)
    if(tempname1.length >= tempname2.length){
        name1 = tempname1;
        name2 = tempname2;
    }else{
        name1 = tempname2;
        name2 = tempname1;
    }

    for(let ix = 0; ix < name1.length; ix++){
        _name1arr[ix] = name1.charAt(ix);
    }
    for(let iy = 0; iy < name2.length; iy++){
        _name2arr[iy] = name2.charAt(iy);
    }

    const korean = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;

    if(tempname1==""){
        alert("이름을 입력해주세요.");
        return;
    }
    // 한글인지 체크
    if (!korean.test(name1) || !korean.test(name2)) {
        alert("한글만 입력할 수 있습니다.");
        return;
    }
    calculate();
}

function calculate() {
    let numArr = new Array();
    let pos = 0;
    var loop1 = 0;
    var loop2 = 0;
    var ix = 0;
    var sumname = 0;

    let max = name1.length > name2.length ? name1.length : name2.length;
    sumname = name1.length+name2.length;

    for (let i = 0; i < max; i++) {
        for (let j = 1; j <= 2; j++) {
            numArr[pos++] = getInitSound(j, i) + getMiddleSound(j, i) + getFinalSound(j, i)
            if(isNaN(getInitSound(j, i) + getMiddleSound(j, i) + getFinalSound(j, i))){
                break;
            }
            //console.log(getInitSound(j, i) + getMiddleSound(j, i) + getFinalSound(j, i) + "/" + pos);
            //console.log(i);
        }
        //이름 표기 적용
        if(sumname==4){
            $("#name1_" + (i+1)).html(_name1arr[i]);
            $("#name2_" + (i+1)).html(_name2arr[i]);
        }
        else if(sumname==5){
            $("#name3_" + (i+1)).html(_name1arr[i]);
            if(i<name2.length){
                $("#name4_" + (i+1)).html(_name2arr[i]);
            }
        }
        else if(sumname==6){
            $("#name5_" + (i+1)).html(_name1arr[i]);
            $("#name6_" + (i+1)).html(_name2arr[i]);
        }
    }
    // 이름별 포인트 표기
    numArr.forEach(function(val){
        if(sumname==4){
            $("#namePoint1_"+(ix+1)).html(val);
        }
        else if(sumname==5){
            $("#namePoint2_"+(ix+1)).html(val);
        }
        else if(sumname==6){
            $("#namePoint3_"+(ix+1)).html(val);
        }
        ix+=1;
    });

    //글자 수에 맞춰 루프 횟수 변경
    if(sumname == 5){
        loop1 = 3;
        loop2 = 2;
    }else{
        loop1 = 2;
        loop2 = 1;
    }

    for (let i = 0; i < pos - loop1; i++) {
        for (let j = 0; j < pos - i - loop2; j++) {
            numArr[j] = (numArr[j] + numArr[j + 1]) % 10;
            //console.log(i + "/" + j + "/" + pos + "//" + numArr[j]);
            //이름 합계 포인트 표기
            if(sumname==4){
                $("#sumPoint1" + i + "_" + j).html(numArr[j]);
            }
            else if(sumname==5){
                $("#sumPoint2" + i + "_" + j).html(numArr[j]);
            }
            else if(sumname==6){
                $("#sumPoint3" + i + "_" + j).html(numArr[j]);
            }
        }
    }
    const result = numArr[0] * 10 + numArr[1];

    eventTry(result,sumname);
    if(result>=50){
        $("#vName1").html(name1);
        $("#vName2").html(name2);
        $("#vPoint1").html(result+"점");
    }else{
        $("#vName3").html(name1);
        $("#vName4").html(name2);
        $("#vPoint2").html(result+"점");
    }
    $("#tPoint").val(result);
    
}

function calculateView() {
    var tempname1, tempname2
    tempname1 = document.getElementById("name1").value;
    tempname2 = document.getElementById("name2").value;
    //길이 체크 후 변수 선언(긴 이름 앞으로)
    if(tempname1.length >= tempname2.length){
        name1 = tempname1;
        name2 = tempname2;
    }else{
        name1 = tempname2;
        name2 = tempname1;
    }

    for(let ix = 0; ix < name1.length; ix++){
        _name1arr[ix] = name1.charAt(ix);
    }
    for(let iy = 0; iy < name2.length; iy++){
        _name2arr[iy] = name2.charAt(iy);
    }
    
    let numArr = new Array();
    let pos = 0;
    var loop1 = 0;
    var loop2 = 0;
    var ix = 0;
    var sumname = 0;

    let max = name1.length > name2.length ? name1.length : name2.length;
    sumname = name1.length+name2.length;

    for (let i = 0; i < max; i++) {
        for (let j = 1; j <= 2; j++) {
            numArr[pos++] = getInitSound(j, i) + getMiddleSound(j, i) + getFinalSound(j, i)
            if(isNaN(getInitSound(j, i) + getMiddleSound(j, i) + getFinalSound(j, i))){
                break;
            }
            //console.log(getInitSound(j, i) + getMiddleSound(j, i) + getFinalSound(j, i) + "/" + pos);
            //console.log(i);
        }
        //이름 표기 적용
        if(sumname==4){
            $("#name1_" + (i+1)).html(_name1arr[i]);
            $("#name2_" + (i+1)).html(_name2arr[i]);
        }
        else if(sumname==5){
            $("#name3_" + (i+1)).html(_name1arr[i]);
            if(i<name2.length){
                $("#name4_" + (i+1)).html(_name2arr[i]);
            }
        }
        else if(sumname==6){
            $("#name5_" + (i+1)).html(_name1arr[i]);
            $("#name6_" + (i+1)).html(_name2arr[i]);
        }
    }
    // 이름별 포인트 표기
    numArr.forEach(function(val){
        if(sumname==4){
            $("#namePoint1_"+(ix+1)).html(val);
        }
        else if(sumname==5){
            $("#namePoint2_"+(ix+1)).html(val);
        }
        else if(sumname==6){
            $("#namePoint3_"+(ix+1)).html(val);
        }
        ix+=1;
    });

    //글자 수에 맞춰 루프 횟수 변경
    if(sumname == 5){
        loop1 = 3;
        loop2 = 2;
    }else{
        loop1 = 2;
        loop2 = 1;
    }

    for (let i = 0; i < pos - loop1; i++) {
        for (let j = 0; j < pos - i - loop2; j++) {
            numArr[j] = (numArr[j] + numArr[j + 1]) % 10;
            //console.log(i + "/" + j + "/" + pos + "//" + numArr[j]);
            //이름 합계 포인트 표기
            if(sumname==4){
                $("#sumPoint1" + i + "_" + j).html(numArr[j]);
            }
            else if(sumname==5){
                $("#sumPoint2" + i + "_" + j).html(numArr[j]);
            }
            else if(sumname==6){
                $("#sumPoint3" + i + "_" + j).html(numArr[j]);
            }
        }
    }
    const result = numArr[0] * 10 + numArr[1];

    if(sumname==4){
        $("#type01").show();
    }
    else if(sumname==5){
        $("#type02").show();
    }
    else if(sumname==6){
        $("#type03").show();
    }
    if(result>=50){
        $("#vName1").html(name1);
        $("#vName2").html(name2);
        $("#vPoint1").html(result+"점");
        $("#winPop").show();
    }else{
        $("#vName3").html(name1);
        $("#vName4").html(name2);
        $("#vPoint2").html(result+"점");
        $("#failPop").show();
    }
}

// 초성
//          ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"];
const cho = [2, 4, 2, 3, 6, 5, 4, 4, 8, 2, 4, 1, 3, 6, 4, 3, 4, 4, 3];
function getInitSound(tmp, i) {
    if (tmp === 1) {
        return cho[Math.floor(((name1.charCodeAt(i) - 44032) /28) / 21)];
    } else if (tmp === 2) {
        return cho[Math.floor(((name2.charCodeAt(i) - 44032) /28) / 21)];
    }
}
// 중성
//          ['ㅏ','ㅐ','ㅑ','ㅒ','ㅓ','ㅔ','ㅕ','ㅖ','ㅗ','ㅘ','ㅙ','ㅚ','ㅛ','ㅜ','ㅝ','ㅞ','ㅟ','ㅠ','ㅡ','ㅢ','ㅣ'];
const mid = [2, 3, 3, 4, 2, 3, 3, 4, 2, 4, 5, 3, 3, 2, 4, 5, 3, 3, 1, 2, 1];
function getMiddleSound(tmp, i) {
    if (tmp === 1) {
        return mid[Math.floor(((name1.charCodeAt(i) - 44032) / 28) % 21)];
    } else if (tmp === 2) {
        return mid[Math.floor(((name2.charCodeAt(i) - 44032) / 28) % 21)];
    }
}
// 종성
//            ['','ㄱ','ㄲ','ㄳ','ㄴ','ㄵ','ㄶ','ㄷ','ㄹ','ㄺ','ㄻ','ㄼ','ㄽ','ㄾ','ㄿ','ㅀ','ㅁ','ㅂ','ㅄ','ㅅ','ㅆ','ㅇ','ㅈ','ㅊ','ㅋ','ㅌ','ㅍ','ㅎ'];
const final = [0, 2, 4, 4, 2, 5, 5, 3, 5, 0, 0, 0, 0, 0, 0, 0, 4, 4, 6, 2, 4, 1, 3, 4, 3, 4, 4, 3];
function getFinalSound(tmp, i) {
    if (tmp === 1) {
        return final[(name1.charCodeAt(i) - 44032) % 28];
    } else if (tmp === 2) {
        return final[(name2.charCodeAt(i) - 44032) % 28];
    }
}