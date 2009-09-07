// Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

package nativehttp;

import static java.net.HttpURLConnection.HTTP_OK;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.util.List;
import java.net.URLDecoder;

import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import detroit.*;

public class NativeHttpHandler implements HttpHandler {
	protected Interpreter interpreter;
	protected Object thunk;

	public NativeHttpHandler(Interpreter interpreter, Object thunk)
	{
		this.interpreter = interpreter;
		this.thunk=thunk;
	}

	public void handle(HttpExchange t) throws IOException {
		final InputStream is;
		final OutputStream os;
		StringBuilder buf;
		int b;
		final String request;
		String response = new String();

		buf = new StringBuilder();

		is = t.getRequestBody();

		while ((b = is.read()) != -1) {
			buf.append((char) b);
		}

		is.close();

		if (buf.length() > 0) {
			request = URLDecoder.decode(buf.toString(), "UTF-8");
		} else {
			request = ""; 
		}

		try
		{

			response = new String((char[])interpreter.apply(thunk, new Pair(t.getRequestMethod().toCharArray(),
							new Pair(t.getRequestURI().toString().toCharArray(),
								new Pair(t.getProtocol().toCharArray(),
									new Pair(request.toCharArray(), null))))));
			response.intern();
		} catch(Exception e) {
		}

		t.sendResponseHeaders(HTTP_OK, response.length());
		os = t.getResponseBody();
		os.write(response.getBytes());
		os.close();
		t.close();
	}
}
