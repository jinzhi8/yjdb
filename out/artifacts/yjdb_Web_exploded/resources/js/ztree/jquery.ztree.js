//ztree 必须要引入

var webPath = "lsga";

var _ztree ="<link rel='stylesheet' href='/"+webPath+"/resources/js/ztree/css/demo.css' type='text/css'></link>"
+"<link rel='stylesheet' type='text/css' href='/"+webPath+"/resources/js/ztree/css/zTreeStyle/zTreeStyle.css' >"
+"<script type='text/javascript' src='/"+webPath+"/resources/js/ztree/js/jquery.ztree.core.js'></script>"
+"<script type='text/javascript' src='/"+webPath+"/resources/js/ztree/js/jquery.ztree.excheck.js'></script>"
+"<script type='text/javascript' src='/"+webPath+"/resources/js/ztree/js/jquery.ztree.exedit.js'></script>";

var _javascript = _ztree;
document.write(_javascript);