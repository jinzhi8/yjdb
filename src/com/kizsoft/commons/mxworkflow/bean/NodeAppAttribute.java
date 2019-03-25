package com.kizsoft.commons.mxworkflow.bean;

import java.io.Serializable;

public class NodeAppAttribute implements Serializable {
	private static final long serialVersionUID = 6460864300592880237L;
	private String activId;
	private String itemId;
	private String itemName;
	private String status;
	private String nullable;
	private String dataType;
	
	private String dataPattern;
	private String appdescription;
	private String delete_flag = "0";
	
	
	public String getActivId() {
		return activId;
	}

	public void setActivId(String activId) {
		this.activId = activId;
	}


	public String getAppdescription() {
		return this.appdescription;
	}

	public void setAppdescription(String appdescription) {
		this.appdescription = appdescription;
	}

	public String getDataPattern() {
		return this.dataPattern;
	}

	public void setDataPattern(String dataPattern) {
		this.dataPattern = dataPattern;
	}

	public String getDataType() {
		return this.dataType;
	}

	public void setDataType(String dataType) {
		this.dataType = dataType;
	}

	public String getItemId() {
		return this.itemId;
	}

	public void setItemId(String itemId) {
		this.itemId = itemId;
	}

	public String getItemName() {
		return this.itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public String getNullable() {
		return this.nullable;
	}

	public void setNullable(String nullable) {
		this.nullable = nullable;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getDelete_flag() {
		return this.delete_flag;
	}

	public void setDelete_flag(String delete_flag) {
		this.delete_flag = delete_flag;
	}

	@Override
	public String toString() {
		return "{itemId:&apos;"+this.itemId+"&apos;,itemName:&apos;"+this.itemName
		+"&apos;,itemStatus:&apos;"+this.status+"&apos;,nullable:&apos;"+this.nullable+"&apos;,dataType:&apos;"+this.dataType+"&apos;}";
	}
}