// Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.


package detroit;

public final class ArgList
{
	public Pair args;
	public Object[] currArgs;
	public Pair currEnv;
	public boolean immediates = false;

	public Pair next = new Pair(null, null);

	public final void setNext(Object result)
	{
		next.car = result;
		args = next;
		immediates = true;
	}

	public final Object next() throws Exception
	{
		Object car = args.car;
		args = args.rest();
		if (immediates)
		{
			return car;
		}

		Op arg = (Op)car;
		switch (arg.type)
		{
			case Interpreter.OP_ENV:
				{
					int up = arg.p1;
					Pair env = currEnv;
					while (--up >= 0)
						env = env.rest();
					return ((Object[])env.car)[arg.p2];
				}
			case Interpreter.OP_LIB:
				return arg.envSlots.elementAt(arg.p1);
			case Interpreter.OP_ARG:
				return currArgs[arg.p1];
			case Interpreter.OP_LMBD:
				{
					Procedure lcl = new Procedure();
					Procedure templ = arg.proc;
					lcl.flags = templ.flags;
					lcl.args = templ.args;
					lcl.env_size = templ.env_size;
					lcl.env = currEnv;
					lcl.name = templ.name;
					lcl.mappings = templ.mappings;
					return lcl;
				}
			case Interpreter.OP_LIT:
				return arg.literal;
			default:
				throw new Exception("invalid Op");
		}
	}
}

