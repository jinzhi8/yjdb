package com.kizsoft.commons.mxworkflow.bean;

import java.io.Serializable;

public class TranceAttribute implements Serializable {
	private static final long serialVersionUID = -2659542958264480349L;
	private String transId;
	private String flowId;
	private String fromActivId;
	private String toActivId;
	private String transName;
	private String transFlag;
	private String transType;
	private String description;
	private Long startX;
	private Long startY;
	private Long endX;
	private Long endY;
	private Long mxEdgeX=0l;
	private Long mxEdgeY=0l;
	private String delete_flag = "0";

	private String double_flag = "0";

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Long getEndX() {
		return this.endX;
	}

	public void setEndX(Long endX) {
		this.endX = endX;
	}

	public Long getEndY() {
		return this.endY;
	}

	public void setEndY(Long endY) {
		this.endY = endY;
	}

	public String getFlowId() {
		return this.flowId;
	}

	public void setFlowId(String flowId) {
		this.flowId = flowId;
	}

	public Long getStartX() {
		return this.startX;
	}

	public void setStartX(Long startX) {
		this.startX = startX;
	}

	public Long getStartY() {
		return this.startY;
	}

	public void setStartY(Long startY) {
		this.startY = startY;
	}

	public String getTransFlag() {
		return this.transFlag;
	}

	public void setTransFlag(String transFlag) {
		this.transFlag = transFlag;
	}

	public String getTransId() {
		return this.transId;
	}

	public void setTransId(String transId) {
		this.transId = transId;
	}

	public String getTransName() {
		return this.transName;
	}

	public void setTransName(String transName) {
		this.transName = transName;
	}

	public String getTransType() {
		return this.transType;
	}

	public void setTransType(String transType) {
		this.transType = transType;
	}

	public String getFromActivId() {
		return this.fromActivId;
	}

	public void setFromActivId(String fromActivId) {
		this.fromActivId = fromActivId;
	}

	public String getToActivId() {
		return this.toActivId;
	}

	public void setToActivId(String toActivId) {
		this.toActivId = toActivId;
	}

	public String getDelete_flag() {
		return this.delete_flag;
	}

	public void setDelete_flag(String delete_flag) {
		this.delete_flag = delete_flag;
	}

	public String getDouble_flag() {
		return this.double_flag;
	}

	public void setDouble_flag(String double_flag) {
		this.double_flag = double_flag;
	}
	
	
	public Long getMxEdgeX() {
		return mxEdgeX;
	}

	public void setMxEdgeX(Long mxEdgeX) {
		this.mxEdgeX = mxEdgeX;
	}

	public Long getMxEdgeY() {
		return mxEdgeY;
	}

	public void setMxEdgeY(Long mxEdgeY) {
		this.mxEdgeY = mxEdgeY;
	}

	@Override
	public String toString() {
		StringBuffer sb=new StringBuffer();
		sb.append("<Line label=\""+this.transName+"\" transName=\""+this.transName+"\" transTransId=\""+this.transId+"\" transFlag=\""+(this.transFlag==null||"".equals(this.transFlag)?"0":this.transFlag)+"\" transType=\""+(this.transType==null||"".equals(this.transType)?"half":this.transType)+"\" transDescription=\""+(this.description==null||"".equals(this.description)?"":this.description)+"\" id=\""+this.transId+"\">");
		sb.append("<mxCell edge=\"1\" parent=\"1\" source=\""+this.fromActivId+"\" target=\""+this.toActivId+"\">");        
		sb.append("<mxGeometry relative=\"1\" as=\"geometry\">"); 
		if((mxEdgeX!=null&&0!=mxEdgeX)||(mxEdgeY!=null&&0!=mxEdgeY)){
			sb.append( "<Array as=\"points\"><mxPoint x=\""+mxEdgeX+"\" y=\""+mxEdgeY+"\"/></Array>");
		}
		sb.append("</mxGeometry>");
		sb.append("</mxCell>");
		sb.append("</Line>");
//		System.out.println(sb.toString());
		return sb.toString();
	}
	
}