// Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.


package detroit;

import java.io.*;

public class Reader
{
	protected BufferedReader stream;

	public int line = 1;
	public int column = 1;

	public Reader(java.io.Reader reader)
	{
		this.stream = new BufferedReader(reader);
	}

	public Reader(java.io.BufferedReader reader)
	{
		this.stream = reader;
	}

	public Object read() throws Exception
	{
		char c = peek();
		stream.skip(1);

		if (c == '#')
		{
			stream.mark(1);
			c = readChar();
			if (c == 't')
				return Boolean.TRUE;
			else if (c == 'f')
				return Boolean.FALSE;
			else if (c == '\\')
			{
				StringBuffer chars = new StringBuffer();
				chars.append(readChar());
				for (;;)
				{
					stream.mark(1);
					c = readChar();
					if (!Character.isLetter(c))
					{
						stream.reset();

						String charname = chars.toString();
						if (charname.equalsIgnoreCase("space"))
							c = ' ';
						else if (charname.equalsIgnoreCase("tab"))
							c = '\t';
						else if (charname.equalsIgnoreCase("newline") ||
								charname.equalsIgnoreCase("linefeed"))
							c = '\n';
						else if (charname.equalsIgnoreCase("return"))
							c = '\r';
						else c = charname.charAt(0);

						return new Character(c);
					}
					chars.append(c);
				}
			}
			else if (c == '(')
			{
				stream.reset();
				return Interpreter.makeArray(java.lang.Object.class, (Pair)read());
			}
			else if (c == 'x')
			{
				StringBuffer buf = new StringBuffer();
				for (;;)
				{
					stream.mark(1);
					c = readChar();
					if (Character.isWhitespace(c)) break;
					if (c == '(' || c == ')')
					{
						stream.reset();
						break;
					}
					buf.append(c);
				}

				return new Integer(Integer.parseInt(buf.toString(), 16));
			}
		}
		else if (c == '"')
		{
			StringBuffer buf = new StringBuffer();
			while ((c = readChar()) != '"')
			{
				if (c == '\\')
				{
					c = readChar();
					if (c == 'n') buf.append('\n');
					else buf.append(c);
				}
				else
					buf.append(c);
			}
			return buf.toString().toCharArray();
		}
		else if (c == '(')
		{
			int sline = line;
			int scol = column;
			try
			{
				if (peek() == ')')
				{
					stream.skip(1);
					return null;
				}

				Object atom = read();
				Pair list = new Pair(atom, null);
				Pair lastPair = list;

				while (peek() != ')')
				{
					atom = read();
					if (atom == ".")
						lastPair.cdr = read();
					else
					{
						lastPair.cdr = new Pair(atom, null);
						lastPair = (Pair)lastPair.cdr;
					}
				}
				stream.skip(1);

				return list;
			}
			catch (IOException e)
			{
				System.err.println("Unclosed list starting at line " + sline + " column " + scol);
				throw e;
			}
		}
		else if (c == '\'')
			return new Pair("quote", new Pair(read(), null));
		else if (c == '`')
			return new Pair("quasiquote", new Pair(read(), null));
		else if (c == ',')
		{
			if (peek() == '@')
			{
				readChar();
				return new Pair("unquote-splicing", new Pair(read(), null));
			}
			return new Pair("unquote", new Pair(read(), null));
		}
		else
		{
			StringBuffer buf = new StringBuffer();
			int b;
			for (;;)
			{
				buf.append(c);
				stream.mark(1);
				b = readByte();
				if (b == -1) break;
				c = (char)b;
				if (Character.isWhitespace(c)) break;
				if (c == '(' || c == ')')
				{
					stream.reset();
					break;
				}
			}

			try
			{
				return new Integer(buf.toString());
			}
			catch (NumberFormatException e)
			{
			}

			try
			{
				return new Double(buf.toString());
			}
			catch (NumberFormatException e)
			{
			}

			return buf.toString().intern();
		}

		throw new IOException();
	}

	public int readByte() throws IOException
	{
		int i = stream.read();
		if (i == '\n')
		{
			++line;
			column = 1;
		}
		else ++column;
		return i;
	}

	public char readChar() throws IOException
	{
		int i = stream.read();
		if (i == -1)
			throw new IOException();
		if (i == '\n')
		{
			++line;
			column = 1;
		}
		else ++column;
		return (char)i;
	}

	protected char peek() throws Exception
	{
		char c, t;

		for (;;)
		{
			stream.mark(2);
			c = readChar();

			if (Character.isWhitespace(c))
				continue;
			else if (c == ';')
				while (c != '\r' && c != '\n') c = readChar();
			else if (c == '#')
			{
				t = readChar();
				if (t == ';')
					read();
				else if (t == '|')
				{
					int depth = 1;
					while (depth > 0)
					{
						t = readChar();
						if (t == '#' && readChar() == '|') ++depth;
						else if (t == '|' && readChar() == '#') --depth;
					}
				}
				else break;
			}
			else break;
		}

		stream.reset();
		return c;
	}
}
