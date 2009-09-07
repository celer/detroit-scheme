// Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

package nativehttp;

import java.net.*;
import java.io.*;
import javax.net.ssl.*;

public class NativeHttpConnection {
	public static char[] request(String method, String request, String data, String contentType) throws Exception
	{
		HttpURLConnection connect = null;
		PrintWriter pw = null;
		BufferedReader rd  = null;
		String result = new String(); 
		String line = null;


		try {
			URL url = new URL(request);
			if(url.getProtocol().equalsIgnoreCase("https"))
			{
				TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
					public java.security.cert.X509Certificate[] getAcceptedIssuers() {
						return null;
					}

					public void checkClientTrusted(
							java.security.cert.X509Certificate[] certs, String authType) {
							}

					public void checkServerTrusted(
							java.security.cert.X509Certificate[] certs, String authType) {
							}
				} };


				HostnameVerifier hv = new HostnameVerifier() {
					public boolean verify(String urlHostName, SSLSession session) {
						return true;
					}
				};
				HttpsURLConnection.setDefaultHostnameVerifier(hv);

				SSLContext sc = SSLContext.getInstance("SSL");
				sc.init(null,trustAllCerts, new java.security.SecureRandom());
				HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
				connect=(HttpsURLConnection)url.openConnection();
			}
			else
			{
				connect = (HttpURLConnection)url.openConnection();
			}
			connect.setRequestMethod(method);
			connect.setDoOutput(true);

			if(data.length() > 0 && contentType.length() > 0)
			{
				connect.setRequestProperty("ContentType", contentType);
				pw = new PrintWriter(connect.getOutputStream());
				pw.print(data);
				pw.flush();
				pw.close();
			}
			connect.connect();

			rd = new BufferedReader(new InputStreamReader(connect.getInputStream()));
			while ((line = rd.readLine()) != null)
				result += line;

		} catch (Exception e) {
			e.printStackTrace();
		}
		finally
		{
			connect.disconnect();
			return result.toCharArray();
		}
	}
}
