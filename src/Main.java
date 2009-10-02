// Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

package detroit;
import java.util.*;
import java.io.*;

public class Main
{

	private static String banner = "Detroit Scheme";
	private static String version = "v1.2.1";
	private static String author = "Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.";
	private static String usage = "usage: ./detroit [--help|-h] [-e eval-form] [file.scm] [-]";

	public static void main(String[] args) throws Exception
	{
		try
		{
			Interpreter vm = new Interpreter();
			Environment detroit = vm.getEnv("detroit");

			// start a repl
			if (args.length == 0)
			{
				System.out.println(banner + " " + version + "\n" + author);
				vm.eval(new Pair("repl", new Pair(true, null)), vm.r5rs);
				return;
			}

			// display usage
			if (args[0].equals("-h") || args[0].equals("--help"))
			{
				System.out.println(banner + " " + version + "\n" + author);
				System.out.println(usage);
				return;
			}

			// evaluate a form
			if (args[0].equals("-e"))
			{
				vm.load(new java.io.StringReader(args[1]), (Environment)vm.eval(new Pair("current-environment", null), vm.r5rs));
				return;
			}

			// evaluate from standard input 
			if (args[0].equals("-"))
			{
				vm.eval(new Pair("repl", new Pair(false, null)), vm.r5rs);
				return;
			}

			// evaluate from a file
			vm.load(new java.io.FileReader(args[0]), vm.r5rs);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}
}
