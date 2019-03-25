package com.kizsoft.commons.mxworkflow.bean;

import java.io.Serializable;
import java.util.Date;

public class FlowAttribute implements Serializable {
	private static final long serialVersionUID = -4227523957874641251L;
	private String flowId;
	private String flowName;
	private String moduleId;
	private String applicationId;
	private String administrator;
	private String description;
	private String creator;
	private Date createTime;
	private String flowActor;
	private String flowType;
	private Long flowOrder;
	private String flowStatus;
	private String flowRangeName;
	private String flowRange;
	private String delete_flag = "0";

	public String getAdministrator() {
		return this.administrator;
	}

	public void setAdministrator(String administrator) {
		this.administrator = administrator;
	}

	public Date getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getCreator() {
		return this.creator;
	}

	public void setCreator(String creator) {
		this.creator = creator;
	}

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getFlowActor() {
		return this.flowActor;
	}

	public void setFlowActor(String flowActor) {
		this.flowActor = flowActor;
	}

	public String getFlowId() {
		return this.flowId;
	}

	public void setFlowId(String flowId) {
		this.flowId = flowId;
	}

	public String getFlowName() {
		return this.flowName;
	}

	public void setFlowName(String flowName) {
		this.flowName = flowName;
	}

	public Long getFlowOrder() {
		return this.flowOrder;
	}

	public void setFlowOrder(Long flowOrder) {
		this.flowOrder = flowOrder;
	}

	public String getFlowStatus() {
		return this.flowStatus;
	}

	public void setFlowStatus(String flowStatus) {
		this.flowStatus = flowStatus;
	}

	public String getFlowType() {
		return this.flowType;
	}

	public void setFlowType(String flowType) {
		this.flowType = flowType;
	}

	public String getModuleId() {
		return this.moduleId;
	}

	public void setModuleId(String moduleId) {
		this.moduleId = moduleId;
	}

	public String getApplicationId() {
		return this.applicationId;
	}

	public void setApplicationId(String appId) {
		this.applicationId = appId;
	}

	public String getFlowRangeName() {
		return this.flowRangeName;
	}

	public void setFlowRangeName(String rangeName) {
		this.flowRangeName = rangeName;
	}

	public String getFlowRange() {
		return this.flowRange;
	}

	public void setFlowRange(String flowRange) {
		this.flowRange = flowRange;
	}

	public String getDelete_flag() {
		return this.delete_flag;
	}

	public void setDelete_flag(String delete_flag) {
		this.delete_flag = delete_flag;
	}
}