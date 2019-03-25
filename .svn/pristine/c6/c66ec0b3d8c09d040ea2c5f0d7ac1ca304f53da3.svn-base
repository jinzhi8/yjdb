package com.kizsoft.commons.common.util;


import java.io.IOException;  
import java.net.Socket;  
import java.net.UnknownHostException;  
import java.security.KeyManagementException;  
import java.security.KeyStore;  
import java.security.KeyStoreException;  
import java.security.NoSuchAlgorithmException;  
import java.security.UnrecoverableKeyException;  
import java.security.cert.CertificateException;  
import java.security.cert.X509Certificate;  
import javax.net.ssl.SSLContext;  
import javax.net.ssl.TrustManager;  
import javax.net.ssl.X509TrustManager;  

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.HttpVersion;  
import org.apache.http.client.HttpClient;  
import org.apache.http.client.methods.HttpGet;
import org.apache.http.conn.ClientConnectionManager;  
import org.apache.http.conn.scheme.PlainSocketFactory;  
import org.apache.http.conn.scheme.Scheme;  
import org.apache.http.conn.scheme.SchemeRegistry;  
import org.apache.http.conn.ssl.SSLSocketFactory;  
import org.apache.http.impl.client.DefaultHttpClient;  
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;  
import org.apache.http.params.BasicHttpParams;  
import org.apache.http.params.HttpParams;  
import org.apache.http.params.HttpProtocolParams;  
import org.apache.http.protocol.HTTP;  
import org.apache.http.util.EntityUtils;
/** 
 * https SSL证锟斤拷锟斤拷锟斤拷锟街わ拷锟斤拷锟�(注锟斤拷舜锟酵拷锟斤拷锟斤拷掳姹撅拷锟絊SL锟斤拷锟解方式) 
 * @author yzs 
 * 
 */  
public class MySSLSocketFactory extends SSLSocketFactory {  
      
    SSLContext sslContext = SSLContext.getInstance("TLS");  
      
    /** 
     *  
     * @param truststore 
     * @throws NoSuchAlgorithmException 
     * @throws KeyManagementException 
     * @throws KeyStoreException 
     * @throws UnrecoverableKeyException 
     */  
    public MySSLSocketFactory(KeyStore truststore) throws NoSuchAlgorithmException, KeyManagementException, KeyStoreException, UnrecoverableKeyException {  
        super(truststore);  
  
        TrustManager tm = new X509TrustManager() {  
            public void checkClientTrusted(X509Certificate[] chain, String authType) throws CertificateException {  
            }  
  
            public void checkServerTrusted(X509Certificate[] chain, String authType) throws CertificateException {  
            }  
  
            public X509Certificate[] getAcceptedIssuers() {  
                return null;  
            }  
        };  
        sslContext.init(null, new TrustManager[] { tm }, null);  
    }  
    @Override  
    public Socket createSocket(Socket socket, String host, int port, boolean autoClose) throws IOException, UnknownHostException {  
        return sslContext.getSocketFactory().createSocket(socket, host, port, autoClose);  
    }  
    @Override  
    public Socket createSocket() throws IOException {  
        return sslContext.getSocketFactory().createSocket();  
    }  
      
    /** 
     * 锟斤拷使锟斤拷时直锟接碉拷锟斤拷锟斤拷锟�,,, 直锟接碉拷锟皆癸拷https锟斤拷ssl锟斤拷证锟斤拷锟�  
     * @return 
     */  
    public static HttpClient getNewHttpClient() {  
        try {  
            KeyStore trustStore = KeyStore.getInstance(KeyStore.getDefaultType());  
            trustStore.load(null, null);  
  
            SSLSocketFactory sf = new MySSLSocketFactory(trustStore);  
            sf.setHostnameVerifier(SSLSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);  
  
            HttpParams params = new BasicHttpParams();  
            HttpProtocolParams.setVersion(params, HttpVersion.HTTP_1_1);  
            HttpProtocolParams.setContentCharset(params, HTTP.UTF_8);  
  
            SchemeRegistry registry = new SchemeRegistry();  
            registry.register(new Scheme("http", PlainSocketFactory.getSocketFactory(), 80));  
            registry.register(new Scheme("https", sf, 443));  
  
            ClientConnectionManager ccm = new ThreadSafeClientConnManager(params, registry);  
  
            return new DefaultHttpClient(ccm, params);  
        } catch (Exception e) {  
            return new DefaultHttpClient();  
        }  
    }  
    
    public static void main(String[] args) {
    	
    	try {  
            HttpClient client = MySSLSocketFactory.getNewHttpClient();
            //锟斤拷锟斤拷get锟斤拷锟斤拷  
            HttpGet request = new HttpGet("https://59.202.29.46:8004/oapi/getToken");  
            HttpResponse response = client.execute(request);  
   
            /**锟斤拷锟斤拷锟酵成癸拷锟斤拷锟斤拷锟矫碉拷锟斤拷应**/  
            if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {  
                /**锟斤拷取锟斤拷锟斤拷锟斤拷锟斤拷锟截癸拷锟斤拷锟斤拷json锟街凤拷锟斤拷锟�*/  
                String strResult = EntityUtils.toString(response.getEntity());  
                  
                System.out.println(strResult);
            }  
        }   
        catch (IOException e) {  
            e.printStackTrace();  
        }  
    	
	}
}  
