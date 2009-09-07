// Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

package nativehttp;

import static java.net.HttpURLConnection.HTTP_OK;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.FileInputStream;
import java.net.InetSocketAddress;
import java.util.List;
import java.net.URLDecoder;

import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpsServer;
import com.sun.net.httpserver.HttpContext;
import com.sun.net.httpserver.HttpsConfigurator;
import com.sun.net.httpserver.HttpsParameters;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.security.*;
import javax.net.ssl.*;

import detroit.*;

public class NativeHttp {
	public static HttpServer createServer(String path, int port, boolean ssl, Interpreter interpreter, Object thunk, String keystore, char[] password)
	{
		HttpServer server = null;
		try
		{
			InetSocketAddress inetAddress = new InetSocketAddress(port);
			if(ssl == true)
			{
				server = HttpsServer.create(inetAddress, 0);
				SSLContext sc = SSLContext.getInstance("TLS");

				KeyStore ks = KeyStore.getInstance("JKS");
				FileInputStream fis = new FileInputStream(keystore);
				ks.load(fis,password);

				KeyManagerFactory kmf = KeyManagerFactory.getInstance("SunX509");
				kmf.init(ks,password);

				TrustManagerFactory tmf = TrustManagerFactory.getInstance("SunX509");
				tmf.init(ks);

				sc.init(kmf.getKeyManagers(), tmf.getTrustManagers(), null);
				final SSLEngine engine = sc.createSSLEngine();
				((HttpsServer)server).setHttpsConfigurator(new HttpsConfigurator(sc) {
					public void configure(HttpsParameters params) {
						params.setCipherSuites(engine.getEnabledCipherSuites());
						params.setProtocols(engine.getEnabledProtocols());
					}
				});
			}
			else
			{
				server = HttpServer.create(inetAddress, 0);
			}

			NativeHttpHandler handler = new NativeHttpHandler(interpreter, thunk);
			HttpContext context = server.createContext(path,handler);
			server.setExecutor(Executors.newCachedThreadPool());
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			return server;
		}
	}
}
