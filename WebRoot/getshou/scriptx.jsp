<% String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();%>
//<script>
//<!--
//document.write("<style media=\"print\">.noprint{display:none}</style>");
//document.write("<object id=\"printerobject\" viewastext style=\"display:none\" classid=\"clsid:1663ed61-23eb-11d2-b92f-008048fdd814\" codebase=\"<%=contextPath%>/resources/js/print/smsx.cab#Version=6,6,440,26\"></object>");
//document.write("<object id=printerobject style='display:none' classid='clsid:1663ed61-23eb-11d2-b92f-008048fdd814' codebase='<%=contextPath%>/print/smsx.cab#Version=6,3,435,20'></object>");
function getprintbar(){
  document.write("<style media=\"print\">.noprint{display:none}</style>");
  document.write("<object id=\"printerobject\" viewastext style=\"display:none\" classid=\"clsid:1663ed61-23eb-11d2-b92f-008048fdd814\" codebase=\"<%=  contextPath%>/resources/js/print/smsx.cab#Version=6,6,440,26\"></object>");
  document.write("<input type=\"button\" class=\"noprint\" value=\"ֱ�Ӵ�ӡ\" onclick=\"doprintnow()\" style=\"width:90px\"><input type=\"button\" class=\"noprint\" value=\"��ӡ\" onclick=\"doprint(true)\" style=\"width:90px\"><input type=\"button\" class=\"noprint\" value=\"��ӡԤ��\" onclick=\"dopreview()\" style=\"width:90px\"><input type=\"button\" class=\"noprint\" value=\"��ӡ����\" onclick=\"doprintsetup()\" style=\"width:90px\"><input type=\"button\" class=\"noprint\" value=\"���ش�ӡ�ؼ�\" title=\"����޷���ӡ,�������ؿؼ���\" onclick=\"location.href='<%=contextPath%>/resources/js/print/smsx.exe'\" style=\"width:90px\">");
}
function doprintinit() {
  if ( !document.getElementById("printerobject").object ) {
  alert("��ӡ�ؼ�δ��װ!�����ز���װ�ؼ���\n�����ز���װ�����Ĵ�ӡ�ؼ���װ���򣬲������£�\n1�����ش��ڵ�������Уݻ�۱���ݱ��غ������С�\n2��������IE��ȫ���棬��������Уݡ�\n3��Do you want to install ScriptX? ������ǣݡ�\n4����װ��Ȩ��ʾ�������Yes��\n5��ScriptX was sccuessfully installed,�����ȷ���ݡ�\n6��Do you want to restart your computer now? ����۷�ݡ�\n7����ˢ�´�ӡ��ҳ���ٵ����ӡ�������ʾ��ӡ�ؼ�δ��װ�������������ԡ�");
  //navigate("scriptx.htm");
  location.href="<%=contextPath%>/resources/js/print/smsx.exe"
  return;
  }
  var p = document.getElementById("printerobject");
  try{
    // -- advanced features
    //p.printing.SetMarginMeasure(2); // measure margins in inches
    //p.printing.printer = "HP DeskJet 870C";
    //p.printing.paperSize = "A4";
    //p.printing.paperSource = "Manual feed";
    //p.printing.collate = true;
    //p.printing.copies = 2;
    //p.printing.SetPageRange(false, 1, 3); // need pages from 1 to 3
    //p.printing.printBackground = true;

    // -- basic features
    p.printing.header = "";
    p.printing.footer = "";
    p.printing.leftMargin = 3.81;
    p.printing.rightMargin = 4.36;
    p.printing.topMargin = 14.19;
    p.printing.bottomMargin = 7.24;
    //portrait:trueΪ����falseΪ����
    p.printing.portrait = true;
  }catch(e){
    alert("�Ҳ�����ӡ��,����ӻ�װ��ӡ����\n����������ܻ��Ҳ�����ӡ���޷���ӡ:\n1��������δ���Ӵ�ӡ����\n2��������δ��װ��ӡ����\n3��������δ��ȷ��װ��ӡ����\n4�������ӡ��δ�����ϡ�\n5��ʹ��Զ���ն˵�ʱ��δ���ر��ش�ӡ����\n6���뵽�ۿ�ʼ�ݣ����ãݣۿ������ݣ۴�ӡ���ʹ���ݲ鿴�Ƿ����������õĴ�ӡ����");
    return;
  }
}
window.onload = function(){
  doprintinit();
};
function doprintsetup() {
  if ( !document.getElementById("printerobject").object ) {
    alert("��ӡ�ؼ�δ��װ!�����ز���װ�ؼ���\n�����ز���װ�����Ĵ�ӡ�ؼ���װ���򣬲������£�\n1�����ش��ڵ�������Уݻ�۱���ݱ��غ������С�\n2��������IE��ȫ���棬��������Уݡ�\n3��Do you want to install ScriptX? ������ǣݡ�\n4����װ��Ȩ��ʾ�������Yes��\n5��ScriptX was sccuessfully installed,�����ȷ���ݡ�\n6��Do you want to restart your computer now? ����۷�ݡ�\n7����ˢ�´�ӡ��ҳ���ٵ����ӡ�������ʾ��ӡ�ؼ�δ��װ�������������ԡ�");
    //navigate("scriptx.htm");
    location.href="<%=contextPath%>/resources/js/print/smsx.exe"
    return;
  }
  var p = document.getElementById("printerobject");
  try{
    p.printing.PageSetup();
  }catch(e){
    alert("�Ҳ�����ӡ��,����ӻ�װ��ӡ����\n����������ܻ��Ҳ�����ӡ���޷���ӡ:\n1��������δ���Ӵ�ӡ����\n2��������δ��װ��ӡ����\n3��������δ��ȷ��װ��ӡ����\n4�������ӡ��δ�����ϡ�\n5��ʹ��Զ���ն˵�ʱ��δ���ر��ش�ӡ����\n6���뵽�ۿ�ʼ�ݣ����ãݣۿ������ݣ۴�ӡ���ʹ���ݲ鿴�Ƿ����������õĴ�ӡ����");
    return;
  }
}
function dopreview(){
  if ( !document.getElementById("printerobject").object ) {
    alert("��ӡ�ؼ�δ��װ!�����ز���װ�ؼ���\n�����ز���װ�����Ĵ�ӡ�ؼ���װ���򣬲������£�\n1�����ش��ڵ�������Уݻ�۱���ݱ��غ������С�\n2��������IE��ȫ���棬��������Уݡ�\n3��Do you want to install ScriptX? ������ǣݡ�\n4����װ��Ȩ��ʾ�������Yes��\n5��ScriptX was sccuessfully installed,�����ȷ���ݡ�\n6��Do you want to restart your computer now? ����۷�ݡ�\n7����ˢ�´�ӡ��ҳ���ٵ����ӡ�������ʾ��ӡ�ؼ�δ��װ�������������ԡ�");
    //navigate("scriptx.htm");
    location.href="<%=contextPath%>/resources/js/print/smsx.exe"
    return;
  }
  var p = document.getElementById("printerobject");
  try{
    p.printing.Preview();
  }catch(e){
    alert("�Ҳ�����ӡ��,����ӻ�װ��ӡ����\n����������ܻ��Ҳ�����ӡ���޷���ӡ:\n1��������δ���Ӵ�ӡ����\n2��������δ��װ��ӡ����\n3��������δ��ȷ��װ��ӡ����\n4�������ӡ��δ�����ϡ�\n5��ʹ��Զ���ն˵�ʱ��δ���ر��ش�ӡ����\n6���뵽�ۿ�ʼ�ݣ����ãݣۿ������ݣ۴�ӡ���ʹ���ݲ鿴�Ƿ����������õĴ�ӡ����");
    window.status = "�Ҳ�����ӡ��,����ӻ�װ��ӡ����";
    return;
  }
}
function doprintnow(){
  if ( !document.getElementById("printerobject").object ) {
    alert("��ӡ�ؼ�δ��װ!�����ز���װ�ؼ���\n�����ز���װ�����Ĵ�ӡ�ؼ���װ���򣬲������£�\n1�����ش��ڵ�������Уݻ�۱���ݱ��غ������С�\n2��������IE��ȫ���棬��������Уݡ�\n3��Do you want to install ScriptX? ������ǣݡ�\n4����װ��Ȩ��ʾ�������Yes��\n5��ScriptX was sccuessfully installed,�����ȷ���ݡ�\n6��Do you want to restart your computer now? ����۷�ݡ�\n7����ˢ�´�ӡ��ҳ���ٵ����ӡ�������ʾ��ӡ�ؼ�δ��װ�������������ԡ�");
    location.href="<%=contextPath%>/resources/js/print/smsx.exe"
    return;
  }
  var p = document.getElementById("printerobject");
  try{
    
  }catch(e){
    alert("�Ҳ�����ӡ��,����ӻ�װ��ӡ����\n����������ܻ��Ҳ�����ӡ���޷���ӡ:\n1��������δ���Ӵ�ӡ����\n2��������δ��װ��ӡ����\n3��������δ��ȷ��װ��ӡ����\n4�������ӡ��δ�����ϡ�\n5��ʹ��Զ���ն˵�ʱ��δ���ر��ش�ӡ����\n6���뵽�ۿ�ʼ�ݣ����ãݣۿ������ݣ۴�ӡ���ʹ���ݲ鿴�Ƿ����������õĴ�ӡ����");
    return;
  }
  try{
    window.status = "׼����ӡ...";
    p.printing.Print(false);
    //p.printing.Print(true);
    window.status = "���ڴ�ӡ...";
  }catch(e){
    alert("��ӡ����,��ǰҳ���Ѿ��ڴ�ӡ���ӡ��æ��");
    window.status = "��ӡ����,��ǰҳ���Ѿ��ڴ�ӡ���ӡ��æ��";
    return;
  }
  window.status = "��ӡ��ɣ�";
}
function doprint(obj){
  if ( !document.getElementById("printerobject").object ) {
    alert("��ӡ�ؼ�δ��װ!�����ز���װ�ؼ���\n�����ز���װ�����Ĵ�ӡ�ؼ���װ���򣬲������£�\n1�����ش��ڵ�������Уݻ�۱���ݱ��غ������С�\n2��������IE��ȫ���棬��������Уݡ�\n3��Do you want to install ScriptX? ������ǣݡ�\n4����װ��Ȩ��ʾ�������Yes��\n5��ScriptX was sccuessfully installed,�����ȷ���ݡ�\n6��Do you want to restart your computer now? ����۷�ݡ�\n7����ˢ�´�ӡ��ҳ���ٵ����ӡ�������ʾ��ӡ�ؼ�δ��װ�������������ԡ�");
    location.href="<%=contextPath%>/resources/js/print/smsx.exe"
    return;
  }
  var p = document.getElementById("printerobject");
  try{
    
  }catch(e){
    alert("�Ҳ�����ӡ��,����ӻ�װ��ӡ����\n����������ܻ��Ҳ�����ӡ���޷���ӡ:\n1��������δ���Ӵ�ӡ����\n2��������δ��װ��ӡ����\n3��������δ��ȷ��װ��ӡ����\n4�������ӡ��δ�����ϡ�\n5��ʹ��Զ���ն˵�ʱ��δ���ر��ش�ӡ����\n6���뵽�ۿ�ʼ�ݣ����ãݣۿ������ݣ۴�ӡ���ʹ���ݲ鿴�Ƿ����������õĴ�ӡ����");
    return;
  }
  try{
    window.status = "׼����ӡ...";
    //p.printing.Print(false);
    p.printing.Print(obj);
    window.status = "���ڴ�ӡ...";
  }catch(e){
    alert("��ӡ����,��ǰҳ���Ѿ��ڴ�ӡ���ӡ��æ��");
    window.status = "��ӡ����,��ǰҳ���Ѿ��ڴ�ӡ���ӡ��æ��";
    return;
  }
  window.status = "��ӡ��ɣ�";
}
//--></script><!--�������ǰ�Ȩ����-->