// Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.


package detroit;

public class Procedure
{
	public String name;
	public int flags;
	public int idx;
	public int args;
	public int env_size;
	public Pair env;
	public Pair mappings;

	public Procedure()
	{
	}

	public Procedure(int flags, int args, int env_size, Pair env, String name, Pair mappings)
	{
		this.flags = flags;
		this.args = args;
		this.env_size = env_size;
		this.env = env;
		this.name = name;
		this.mappings = mappings;
	}

	public Procedure(int flags, int idx, int args, int env_size, Pair env, String name, Pair mappings)
	{
		this.flags = flags;
		this.idx = idx;
		this.args = args;
		this.env_size = env_size;
		this.env = env;
		this.name = name;
		this.mappings = mappings;
	}
}
