function checkFields() {
    var meeting_Name = document.all.meeting_Name;		//会议名称
    var meeting_Title = document.all.meeting_Title;		//会议议题
    var meeting_Start_Time = document.all.meeting_Start_Time;		//开始时间
    var meeting_End_Time = document.all.meeting_End_Time;		//结束时间
    if (isNull(meeting_Name)) {
        alert("请填写会议名称");
        return false;
    }
    if (isNull(meeting_Title)) {
        alert("请填写会议议题");
        return false;
    }
    if (isNull(meeting_Start_Time)) {
        alert("请填写开始时间");
        return false;
    }
    if (isNull(meeting_End_Time)) {
        alert("请填写结束时间");
        return false;
    }

    return true;
}

function isNull(obj) {
    if (obj == null || obj.value == "")
        return true; else
        return false;
}