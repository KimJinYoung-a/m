const create_search_parameter = function (parameter, page) { // 검색API 파라미터 생성
    let api_parameter = '?keywords=' + parameter.keyword + '&page=' + page;

    if( parameter.deliType.length > 0 ) { // 배송/기타
        for( let i=0 ; i<parameter.deliType.length ; i++ ) {
            api_parameter += '&deliType=' + parameter.deliType[i];
        }
    }
    if( parameter.dispCategories.length > 0 ) { // 카테고리
        for( let i=0 ; i<parameter.dispCategories.length ; i++ ) {
            api_parameter += '&dispCategories=' + parameter.dispCategories[i];
        }
    }
    if( parameter.makerIds.length > 0 ) { // 브랜드
        for( let i=0 ; i<parameter.makerIds.length ; i++ ) {
            api_parameter += '&makerIds=' + parameter.makerIds[i];
        }
    }
    if( parameter.minPrice !== '' ) { // 최저가
        api_parameter += '&minPrice=' + parameter.minPrice;
    }
    if( parameter.maxPrice !== '' ) { // 최고가
        api_parameter += '&maxPrice=' + parameter.maxPrice;
    }

    return api_parameter;
}

const get_parameter_array = function(value) {
    if( value !== undefined && value !== null && value !== '' ) {
        return value.split(', ');
    } else {
        return [];
    }
}