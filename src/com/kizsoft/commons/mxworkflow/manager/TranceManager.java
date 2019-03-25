package com.kizsoft.commons.mxworkflow.manager;


import java.util.List;
import java.util.Map;

import com.kizsoft.commons.mxworkflow.bean.Point;
import com.kizsoft.commons.mxworkflow.bean.TranceAttribute;
import com.kizsoft.commons.mxworkflow.dao.TranceDAO;

public class TranceManager {
	public static TranceDAO dao=new TranceDAO();
	public String addTrance(TranceAttribute trance){
		return dao.addTransitionInfo(trance);
	}
	public String updateTrance(TranceAttribute trance){
		return dao.updateTransitionInfo(trance);
	}
	public void deleteTrance(String tranceid){
		dao.deleteTransition(tranceid);
	}
	public void deleteTrances(String flowid){
		dao.deleteTransitions(flowid);
	}
	public void addTrances(List<TranceAttribute> lines,Map<String,String> map,Map<String,Point> points) {
		for(TranceAttribute line:lines){
			String fromid=line.getFromActivId();
			String newfromid=map.get(fromid);
			if(newfromid!=null&&!"".equals(newfromid)){
				line.setFromActivId(newfromid);
			}
			String toid=line.getToActivId();
			String newtoid=map.get(toid);
			if(newtoid!=null&&!"".equals(newtoid)){
				line.setToActivId(newtoid);
			}
			Point p=points.get(fromid);
			if(p!=null){
				line.setStartX(p.getPX());
				line.setStartY(p.getPY());
			}
			p=points.get(toid);
			if(p!=null){
				line.setEndX(p.getX());
				line.setEndY(p.getPY());
			}
			String lineid=line.getTransId();
			if(lineid!=null&&!"".equals(lineid)){
				dao.updateTransitionInfo(line);
			}else{
				dao.addTransitionInfo(line);
			}
			
			
		}
		
	}

}
