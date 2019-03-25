package com.kizsoft.oa.wcoa.util;
import com.kizsoft.commons.acl.ACLManagerFactory;
import com.kizsoft.commons.uum.pojo.Owner;
import com.kizsoft.commons.uum.utils.UUMContend;
import com.kizsoft.commons.util.UUIDGenerator;

public class GetZwdb{
	 private void insertZwdbAcl(String unid, String managedepid,String copytoid,String leaderid,String sourceid)
	  {
		ACLManagerFactory.getACLManager().appendACLRange(unid, leaderid);
	    ACLManagerFactory.getACLManager().appendACLRange(unid, managedepid);
	    ACLManagerFactory.getACLManager().appendACLRange(unid, copytoid);
	    ACLManagerFactory.getACLManager().appendACLRange(unid, sourceid);
	    SimpleORMUtils instance = SimpleORMUtils.getInstance();
	    if (managedepid == null)
	      return;
	    managedepid=managedepid+","+copytoid;
	    String[] depids = managedepid.split(",");
	    for (String depid : depids) {
	      Owner o = UUMContend.getUUMService().getOwnerByOwnerid(depid);
	      if (o == null)
	        continue;
	      String depname = o.getOwnername();
	      instance.executeUpdate("insert into zwdbacl(unid,dbid,fkr,fkrid,nextsj,endsj) values(?,?,?,?,sysdate,get_nextsj(?,sysdate))", new Object[] { UUIDGenerator.getUUID(), unid, depname, depid, unid });
	    }
	  }
}