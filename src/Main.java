// Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.


package detroit;

import java.util.*;
import java.io.*;

public class Main
{

	private static String banner = "Detroit Scheme";
	private static String version = "v1.1";
	private static String author = "Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.";

	public static void main(String[] args) throws Exception
	{
		try
		{
			Interpreter vm = new Interpreter();
			int i, j;

			Library detroitlib = vm.getLib("detroit");

			if (args.length == 0)
			{
				System.out.println(banner + " " + version + "\n" + author);
				vm.eval(new Pair("repl", new Pair(true, null)), vm.r5rs);
				return;
			}

			if (args.length == 1) 
			{
				if (args[0].equals("-"))
				{
					vm.eval(new Pair("repl", new Pair(false, null)), vm.r5rs);
					return;
				}
			}

			for (i=0; i<args.length; ++i)
			{
				if (args[i].equals("-e"))
					++i;
				else if (args[i].equals("--"))
				{
					Pair arglist = null;
					for (j=args.length -1; j>i; --j)
						arglist = new Pair(args[j].toCharArray(), arglist);
					vm.eval(new Pair("set!", new Pair("argv", new Pair(new Pair("quote", new Pair(arglist, null)), null))),
							detroitlib);
				}
			}

			for (i=0; i<args.length; ++i)
			{
				if (args[i].equals("-e"))
				{
					vm.load(new java.io.StringReader(args[++i]),
							(Library)vm.eval(new Pair("current-library", null), vm.r5rs));
				}
				else if (args[i].equals("--"))
					break;
				else vm.load(new java.io.FileReader(args[i]), vm.r5rs);
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}
}
