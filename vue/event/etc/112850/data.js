const eventDevelop = function() {
    return unescape(location.href).includes('//localhost') || unescape(location.href).includes('//testm') || unescape(location.href).includes('//localm');
}();
const eventStaging = function() {
    return unescape(location.href).includes('//stgm');
}();

let eventData;
if( eventDevelop ) {
    eventData = {
        // 배너
        "banners" : [
            {
                "image" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/event_list0727_01.jpg",
                "eventId" : 113007
            },
            {
                "image" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/event_list0727_02.jpg",
                "eventId" : 113008
            },
            {
                "image" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/event_list0727_03.jpg",
                "eventId" : 113009
            }
        ],
        // Top 7
        "top7Item1" : {
            "titleImage" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/img_tit01_0727.jpg",
            "itemIds" : [
                2147023, 2147051, 2147067, 2147275, 1202098, 2147303, 1202102
            ]
        },
        "top7Item2" : {
            "titleImage" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/img_tit02_0727.jpg",
            "itemIds" : [
                2445377, 3140159, 3256902, 2365294, 2785591, 2445376, 3279814
            ]
        }
    };
} else {
    const now = new Date();

    if( eventStaging ) { // staging에선 다음날 것 보여줌
        now.setDate(now.getDate() + 1);
    }

    const nowStr = (now.getMonth() + 1) + '/' + now.getDate();

    // 29일까지
    if( nowStr < '7/30' ) {
        eventData = {
            // 배너
            "banners" : [
                {
                    "image" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/event_list0729_01.jpg",
                    "eventId" : 113083
                },
                {
                    "image" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/event_list0729_02.jpg",
                    "eventId" : 113084
                },
                {
                    "image" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/event_list0729_03.jpg",
                    "eventId" : 112949
                }
            ],
            // Top 7
            "top7Item1" : {
                "titleImage" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/img_tit01_0729.jpg",
                "itemIds" : [
                    3811441, 2843719, 3942785, 3801530, 3592347, 3527498, 3746444
                ]
            },
            "top7Item2" : {
                "titleImage" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/img_tit02_0729.jpg",
                "itemIds" : [
                    3811442, 3256902, 3513471, 3668316, 3942783, 3697778, 3866299
                ]
            }
        };
    }

    // 30일까지
    else if( nowStr < '7/31' ) {
        eventData = {
            // 배너
            "banners" : [
                {
                    "image" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/event_list0730_01.jpg",
                    "eventId" : 113085
                },
                {
                    "image" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/event_list0730_02.jpg",
                    "eventId" : 112970
                },
                {
                    "image" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/event_list0730_03.jpg",
                    "eventId" : 112624
                }
            ],
            // Top 7
            "top7Item1" : {
                "titleImage" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/img_tit01_0730.jpg",
                "itemIds" : [
                    3687737, 3109375, 3787840, 3725065, 2868933, 3527455, 3826609
                ]
            },
            "top7Item2" : {
                "titleImage" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/img_tit02_0730.jpg",
                "itemIds" : [
                    3852437, 3724811, 3911350, 3884509, 3911371, 3811316, 3930516
                ]
            }
        };
    }

    else {
        eventData = {
            // 배너
            "banners" : [
                {
                    "image" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/event_list0731_01.jpg",
                    "eventId" : 112854
                },
                {
                    "image" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/event_list0731_02.jpg",
                    "eventId" : 112855
                },
                {
                    "image" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/event_list0731_03.jpg",
                    "eventId" : 113007
                }
            ],
            // Top 7
            "top7Item1" : {
                "titleImage" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/img_tit01_0731.jpg",
                "itemIds" : [
                    3958139, 3602937, 3332369, 3955067, 3785302, 3461785, 3687737

                ]
            },
            "top7Item2" : {
                "titleImage" : "//webimage.10x10.co.kr/fixevent/event/2021/112850/m/img_tit02_0731.jpg",
                "itemIds" : [
                    3696783, 3957925, 3958138, 2104155, 3312981, 3922264, 3852437

                ]
            }
        };
    }
}