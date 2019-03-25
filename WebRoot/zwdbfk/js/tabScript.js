
function resetTabs(obj) {
	$(obj).parent().parent().next("div").find("div").hide();
	$(obj).parent().parent().find("a").removeClass("wcoa_dcb_tabscurrent");
}
function loadTab() {
	$(".wcoa_dcb_tabs_content > div").hide();
	$(".wcoa_dcb_tabs").each(function () {
		//$(this).find("li:first a").addClass("wcoa_dcb_tabscurrent");
	});
	$(".wcoa_dcb_tabs_content").each(function () {
		$(this).find("div:first").fadeIn();
	});
	$(".wcoa_dcb_tabs a").on("click", function (e) {
		e.preventDefault();
		if ($(this).attr("class") == "wcoa_dcb_tabscurrent") {
			return;
		} else {
			resetTabs(this);
			$(this).addClass("wcoa_dcb_tabscurrent");
			$($(this).attr("name")).fadeIn();
		}
	});
}

